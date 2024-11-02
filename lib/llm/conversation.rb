# frozen_string_literal: true

module LLM
  class Conversation
    attr_reader :thread

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
    def chat(prompt, role = :user, **params)
      @provider.chat(prompt, role, **params.merge(messages: @thread))
    end
  end
end
