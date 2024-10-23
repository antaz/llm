# frozen_string_literal: true

module LLM
  module HTTPClient
    require "net/http"
    ##
    # Initiates a HTTP request
    # @param [Net::HTTP] http
    #  The HTTP object to use for the request
    # @param [Net::HTTPRequest] req
    #  The request to send
    # @return [Net::HTTPResponse]
    #  The response from the server
    # @raise [LLM::Error::Unauthorized]
    #  When authentication fails
    # @raise [LLM::Error::RateLimit]
    #  When the rate limit is exceeded
    # @raise [LLM::Error::HTTPError]
    #  When any other unsuccessful status code is returned
    # @raise [SystemCallError]
    #  When there is a network error at the operating system level
    def request(http, req)
      res = http.request(req)
      res.tap(&:value)
    rescue Net::HTTPClientException
      if [
        Net::HTTPBadRequest,   # Gemini (huh?)
        Net::HTTPForbidden,    # Anthropic
        Net::HTTPUnauthorized  # OpenAI
      ].any? { _1 === res }
        raise LLM::Error::Unauthorized.new { _1.response = res }, "Authentication error"
      elsif Net::HTTPTooManyRequests === res
        raise LLM::Error::RateLimit.new { _1.response = res }, "Too many requests"
      else
        raise LLM::Error::HTTPError.new { _1.response = res }, "Unexpected response"
      end
    end
  end
end
