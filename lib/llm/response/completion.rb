# frozen_string_literal: true

module LLM
  class Response::Completion < Response
    ##
    # @return [String]
    #   Returns the model name used for the completion
    def model
      parsed[:model]
    end

    ##
    # @return [Array<LLM::Message>]
    #  Returns an array of messages
    def choices
      parsed[:choices]
    end

    ##
    # @return [Integer]
    #   Returns the count of prompt tokens
    def prompt_tokens
      parsed[:prompt_tokens]
    end

    ##
    # @return [Integer]
    #   Returns the count of completion tokens
    def completion_tokens
      parsed[:completion_tokens]
    end

    ##
    # @return [Integer]
    #   Returns the total count of tokens
    def total_tokens
      @provider.respond_to?(:completion_total_tokens) ?
        parsed[:total_tokens] :
        prompt_tokens + completion_tokens
    end

    private

    def parsed
      @parsed ||= @provider.parse_completion(raw)
    end
  end
end
