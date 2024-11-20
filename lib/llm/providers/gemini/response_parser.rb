# frozen_string_literal: true

class LLM::Gemini
  module ResponseParser
    def parse_embedding(raw)
      {
        embeddings: raw.dig("embedding", "values")
      }
    end

    ##
    # @param [Hash] raw
    #  The raw response from the LLM provider
    # @return [Hash]
    def parse_completion(raw)
      {
        model: raw["modelVersion"],
        choices: raw["candidates"].map do
          stop_reason = _1["finishReason"]
          LLM::Message.new(
            _1.dig("content", "role"),
            {text: _1.dig("content", "parts", 0, "text")},
            {stop_reason:}
          )
        end,
        prompt_tokens: raw.dig("usageMetadata", "promptTokenCount"),
        completion_tokens: raw.dig("usageMetadata", "candidatesTokenCount")
      }
    end
  end
end
