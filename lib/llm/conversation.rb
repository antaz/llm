module LLM
  ##
  # The Conversation class represents a conversation with
  # a provider where there is a thread of messages that act
  # as context for the conversation
  class Conversation
    ##
    # @param [LLM::Response] completion
    #  A completion object
    # @param [LLM::Provider] provider
    #  A provider
    def initialize(completion, provider)
      @completion = completion
      @provider = provider
    end

    ##
    # @param prompt (see LLM::Provider#prompt)
    # @return [LLM::Conversation]
    def chat(prompt, **params)
      @provider.chat(prompt, **params.merge(thread:))
    end

    ##
    # @return (see LLM::Response::Completion#messages)
    def messages
      @completion.messages
    end
    alias_method :thread, :messages
  end
end
