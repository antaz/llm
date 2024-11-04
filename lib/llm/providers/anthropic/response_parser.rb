# frozen_string_literal: true

class LLM::Anthropic
  module ResponseParser
    def parse_completion(raw)
      {
        model: raw["model"],
        choices: raw["content"].map do
          # TODO: don't hardcode role
          LLM::Message.new("assistant", _1["text"])
        end,
        prompt_tokens: raw.dig("usage", "input_tokens"),
        completion_tokens: raw.dig("usage", "output_tokens")
      }
    end
  end
end
