# frozen_string_literal: true

class LLM::Gemini
  class ErrorHandler
    ##
    # @return [Net::HTTPResponse]
    #  Non-2XX response from the server
    attr_reader :res

    ##
    # @param [Net::HTTPResponse] res
    #  The response from the server
    # @return [LLM::Gemini::ErrorHandler]
    def initialize(res)
      @res = res
    end

    ##
    # @raise [LLM::Error]
    #  Raises a subclass of {LLM::Error LLM::Error}
    def raise_error!
      case res
      when Net::HTTPBadRequest
        # FIXME:
        # Parse the response body for more information
        # Based on the request body, raise a more specific error
        raise LLM::Error::Unauthorized.new { _1.response = res }, "Authentication error"
      when Net::HTTPTooManyRequests
        raise LLM::Error::RateLimit.new { _1.response = res }, "Too many requests"
      else
        raise LLM::Error::BadResponse.new { _1.response = res }, "Unexpected response"
      end
    end
  end
end
