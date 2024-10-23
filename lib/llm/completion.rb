# frozen_string_literal: true

module LLM
  require "llm/response"
  require "llm/message"
  class Completion < Response
    def model
    end

    def messages
      parser = message_parsers[@provider]
      parser.call(JSON.parse(@raw))
    end

    private

    def message_parsers
      {
        openai: ->(data) {
          data["choices"].map { |choice| Message.new(*choice["message"].values_at("role", "content")) }
        },
        anthropic: ->(data) {
          data["content"].map { |message| Message.new("assistant", message["text"]) }
        },
        gemini: ->(data) {
          data["candidates"].map { |candidate| Message.new(candidate.dig("content", "role"), candidate.dig("content", "parts", 0, "text")) }
        }
      }
    end
  end
end
