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
    def choices
      @provider.__send__ :completion_choices, raw
    end
  end
end
