# frozen_string_literal: true

module LLM
  class Response::Completion < Response
    ##
    # @return [Array<LLM::Message>]
    #  Returns a thread of messages
    attr_accessor :thread

    ##
    # @return [String]
    #  Returns the model name used for the completion
    def model
      @provider.__send__ :completion_model, self, raw
    end

    ##
    # @return [Array<LLM::Message>]
    #  Returns an array of messages
    def messages
      @provider.__send__ :completion_messages, self, raw
    end
  end
end
