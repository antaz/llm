# frozen_string_literal: true

module LLM
  class Response::Chunk < Response
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

    private

    ##
    # @private
    # @return [Hash]
    #  Returns the parsed completion response from the provider
    def parsed
      @parsed ||= parse_completion_chunk(raw)
    end
  end
end
