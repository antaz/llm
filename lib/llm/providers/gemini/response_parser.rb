# frozen_string_literal: true

class LLM::Gemini
  module ResponseParser
    ##
    # @param [Hash] raw
    #  The raw response from the LLM provider
    # @return [Hash]
    def parse_completion(raw)
      {
        model: raw["modelVersion"],
        choices: raw["candidates"].map do
          LLM::Message.new(
            _1.dig("content", "role"),
            _1.dig("content", "parts", 0, "text")
          )
        end,
        prompt_tokens: raw.dig("usageMetadata", "promptTokenCount"),
        completion_tokens: raw.dig("usageMetadata", "candidatesTokenCount")
      }
    end
  end
end
