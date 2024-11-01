# frozen_string_literal: true

module LLM
  class Conversation
    attr_accessor :thread

    ##
    # @param [Array<LLM::Message>] thread
    #  An array of messages that form the conversation history
    # @param [LLM::Provider] provider
    #  A provider
    def initialize(provider, thread)
      @provider = provider
      @thread = thread
    end

    ##
    # @param prompt (see LLM::Provider#prompt)
    # @return [LLM::Conversation]
    def chat(prompt, **params)
      @provider.chat(prompt, **params.merge(messages: @thread))
    end
  end
end
