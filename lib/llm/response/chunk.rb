# frozen_string_literal: true

module LLM
  class Response::Chunk < Response::Completion
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
