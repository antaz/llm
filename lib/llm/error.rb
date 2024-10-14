# frozen_string_literal: true

module LLM
  ##
  # The superclass of all LLM errors
  class Error < RuntimeError
    def initialize
      block_given? ? yield(self) : nil
    end

    ##
    # The superclass of all HTTP protocol errors
    class HTTPError < Error
      ##
      # @return [Net::HTTPResponse]
      #  Returns the response associated with an error
      attr_accessor :response
    end

    ##
    # HTTPUnauthorized
    Unauthorized = Class.new(HTTPError)

    ##
    # HTTPTooManyRequests
    RateLimit = Class.new(HTTPError)
  end
end
