class LLM::OpenAI
  module ResponseParser
    ##
    # @param [Hash] raw
    #  The raw response from the LLM provider
    # @return [Hash]
    def parse_completion(raw)
      {
        model: raw["model"],
        choices: raw["choices"].map do
          LLM::Message.new(*_1["message"].values_at("role", "content"))
        end,
        prompt_tokens: raw.dig("usage", "prompt_tokens"),
        completion_tokens: raw.dig("usage", "completion_tokens"),
        total_tokens: raw.dig("usage", "total_tokens")
      }
    end
  end
end
