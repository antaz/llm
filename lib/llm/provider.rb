# frozen_string_literal: true

module LLM
  # The Provider class represents a base class for LLM (Language Model) providers.
  class Provider
    # Initializes a new Provider instance.
    #
    # @param secret [String] The secret key for authentication.
    # @param host [String] The host address of the LLM provider.
    # @param port [Integer] The port number (default: 443).
    def initialize(secret, host, port = 443)
      @secret = secret
      @http = Net::HTTP.new(host, port).tap do |http|
        http.use_ssl = true
        http.extend(HTTPClient)
      end
    end

    # Completes a given prompt using the LLM.
    #
    # @param prompt [String] The input prompt to be completed.
    # @raise [NotImplementedError] This method must be implemented by subclasses.
    def complete(prompt)
      raise NotImplementedError
    end

    private

    # Authenticates the given request.
    #
    # @param req [Net::HTTP::Request] The request to be authenticated.
    # @raise [NotImplementedError] This method must be implemented by subclasses.
    def auth(req)
      raise NotImplementedError
    end
  end
end
