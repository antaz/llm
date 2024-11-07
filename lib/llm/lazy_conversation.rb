module LLM
  ##
  # {LLM::LazyConversation LLM::LazyConversation} provides a
  # conversation object that allows input prompts to be stacked
  # and only sent to the LLM when a response is needed.
  #
  # @example
  #   llm = LLM.openai(key)
  #   bot = llm.chat!("What is the capital of France?")
  #   bot.chat("What should we eat in Paris?")
  #   bot.chat("What is the weather like in Paris?")
  #   bot.thread.each do |message|
  #     # A single request is made at this point
  #   end
  class LazyConversation
    ##
    # @return [LLM::LazyThread]
    attr_reader :thread

    ##
    # @param [LLM::Provider] provider
    #  A provider
    def initialize(provider)
      @provider = provider
      @thread = LLM::LazyThread.new(provider)
    end

    ##
    # @param prompt (see LLM::Provider#prompt)
    # @return [LLM::Conversation]
    def chat(prompt, role = :user, **params)
      tap { @thread << [prompt, role, params] }
    end
  end
end
