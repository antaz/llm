# frozen_string_literal: true

module LLM
  class Response
    attr_reader :messages

    def initialize(messages)
      @messages = messages
    end
  end
end
