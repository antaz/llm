# frozen_string_literal: true

module LLM
  class Response
    attr_reader :raw

    def initialize(raw, provider)
      @raw = raw
      @provider = provider
    end
  end
end
