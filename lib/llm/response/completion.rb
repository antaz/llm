# frozen_string_literal: true

module LLM
  class Response::Completion < Response
    ##
    # @return [String]
    #   Returns the model name used for the completion
    def model
      @provider.__send__ :completion_model, raw
    end

    ##
    # @return [Array<LLM::Message>]
    #  Returns an array of messages
    def messages
      @provider.__send__ :completion_messages, raw
    end
  end
end
