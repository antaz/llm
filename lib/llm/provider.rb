# frozen_string_literal: true

module LLM
  require "llm/http_client"
  ##
  # The Provider class represents an abstract class for
  # LLM (Language Model) providers
  class Provider
    include HTTPClient
    ##
    # @param [String] secret
    #  The secret key for authentication
    # @param [String] host
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
    # @param [Symbol] role
    #  The role of the prompt (e.g. :user, :system)
    # @raise [NotImplementedError]
    #  When the method is not implemented by a subclass
    # @return [LLM::Response::Completion]
    def complete(prompt, role = :user, **params)
      raise NotImplementedError
    end

    ##
    # @param prompt (see LLM::Provider#complete)
    # @param role (see LLM::Provider#complete)
    # @raise (see LLM::Provider#complete)
    # @return [LLM::Conversation]
    def chat(prompt, role = :user, **params)
      raise NotImplementedError
    end

    private

    ##
    # Prepares a request for authentication
    # @param [Net::HTTP::Request] req
    #  The request to prepare for authentication
    # @raise [NotImplementedError]
    #  (see LLM::Provider#complete)
    def auth(req)
      raise NotImplementedError
    end

    ##
    # @return [Module]
    #  Returns the module responsible for parsing the LLM response
    # @raise [NotImplementedError]
    #  (see LLM::Provider#complete)
    def response_parser
      raise NotImplementedError
    end
  end
end
