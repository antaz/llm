# frozen_string_literal: true

module LLM
  require "llm/error"
  ##
  # The Provider class represents an abstract class for
  # LLM (Language Model) providers
  class Provider
    ##
    # @param [String] secret
    #  The secret key for authentication
    # @param [String]
    #  The host address of the LLM provider
    # @param [Integer] port
    #  The port number
    def initialize(secret, host, port = 443)
      @secret = secret
      @http = Net::HTTP.new(host, port).tap do |http|
        http.use_ssl = true
      end
    end

    ##
    # Completes a given prompt using the LLM
    # @param [String] prompt
    #  The input prompt to be completed
    # @raise [NotImplementedError]
    #  When the method is not implemented by a subclass
    def complete(prompt)
      raise NotImplementedError
    end

    private

    ##
    # Sends an HTTP request and handles the response
    # @param [Net::HTTP::Request] req
    #  The HTTP request to be sent
    # @return [Net::HTTPResponse]
    #  The HTTP response
    # @raise [LLM::Error::Unauthorized]
    #  When authentication fails
    # @raise [LLM::Error::RateLimit]
    #  When too many requests are made
    # @raise [LLM::Error::HTTPError]
    #  For unexpected HTTP responses
    def request(http, req)
      req.content_type = "application/json"
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

    ##
    # Prepares a request for authentication
    # @param [Net::HTTP::Request] req
    #  The request to prepare for authentication
    # @raise [NotImplementedError]
    #  (see LLM::Provider#complete)
    def auth(req)
      raise NotImplementedError
    end
  end
end
