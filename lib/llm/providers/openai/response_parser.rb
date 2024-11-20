class LLM::OpenAI
  module ResponseParser
    def parse_embedding(raw)
      {
        model: raw["model"],
        embeddings: raw.dig("data").map do |data|
          data["embedding"]
        end,
        prompt_tokens: raw.dig("usage", "prompt_tokens"),
        total_tokens: raw.dig("usage", "total_tokens")
      }
    end

    ##
    # @param [Hash] raw
    #  The raw response from the LLM provider
    # @return [Hash]
    def parse_completion(raw)
      {
        model: raw["model"],
        choices: raw["choices"].map do
          logprobs = _1["logprobs"]
          stop_reason = _1["finish_reason"]
          LLM::Message.new(*_1["message"].values_at("role", "content"), {logprobs:, stop_reason:})
        end,
        prompt_tokens: raw.dig("usage", "prompt_tokens"),
        completion_tokens: raw.dig("usage", "completion_tokens"),
        total_tokens: raw.dig("usage", "total_tokens")
      }
    end
  end
end
