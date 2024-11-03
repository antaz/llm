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

    ##
    # @return [Integer]
    #   Returns the count of prompt tokens
    def prompt_tokens
      @provider.__send__ :completion_prompt_tokens, raw
    end

    ##
    # @return [Integer]
    #   Returns the count of completion tokens
    def completion_tokens
      @provider.__send__ :completion_completion_tokens, raw
    end

    ##
    # @return [Integer]
    #   Returns the total count of tokens
    def total_tokens
      @provider.__send__ :completion_total_tokens, raw
    end
  end
end
