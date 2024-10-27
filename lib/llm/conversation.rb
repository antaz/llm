# frozen_string_literal: true

module LLM
  class Conversation
    def initialize(provider, messages)
      @provider = provider
      @messages = messages
    end

    def chat(prompt)
      @provider.complete(@messages + [Message.new("user", prompt)])
        .then { Conversation.new(@provider, @messages + [Message.new("user", prompt), *_1.messages]) }
    end
  end
end
