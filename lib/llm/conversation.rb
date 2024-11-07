# frozen_string_literal: true

module LLM
  ##
  # {LLM::Conversation LLM::Conversation} provides a conversation
  # object that maintains a thread of messages that act as the
  # context of the conversation.
  #
  # @example
  #   llm = LLM.openai(key)
  #   bot = llm.chat("What is the capital of France?")
  #   bot.chat("What should we eat in Paris?")
  #   bot.chat("What is the weather like in Paris?")
  #   p bot.thread.map { [_1.role, _1.content] }
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
      tap do
        bot = @provider.chat(prompt, role, **params.merge(messages: @thread))
        # The last two elements of the thread include the
        # last input prompt, and the response from the LLM
        @thread.concat(bot.thread[-2..-1])
      end
    end
  end
end
