# frozen_string_literal: true

module LLM
  class Response
    require "json"
    require_relative "response/completion"

    attr_reader :raw
    attr_reader :provider

    ##
    # @param [String] raw
    #  Response body
    # @param [LLM::Provider] provider
    #  A provider
    def initialize(raw, provider)
      @raw = JSON.parse(raw)
      @provider = provider
    end
  end
end
