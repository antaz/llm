# frozen_string_literal: true

module LLM
  require "net/http"
  require "uri"
  require "json"
  require "llm/http/client"
  require "llm/adapter"
  require "llm/message"
  require "llm/response"

  class OpenAI < Adapter
    BASE_URL = "https://api.openai.com/v1"
    DEFAULT_PARAMS = {
      model: "gpt-4o-mini"
    }.freeze

    def initialize(secret)
      super(secret, BASE_URL)
    end

    def complete(prompt, params = {})
      req = Net::HTTP::Post.new("#{@uri}/chat/completions")

      body = {
        messages: [{role: "user", content: prompt}],
        **DEFAULT_PARAMS,
        **params
      }

      req.body = JSON.generate(body)
      auth(req)

      res = @http.post(req)

      Response.new(JSON.parse(res.body)["choices"].map { |choice|
        Message.new(choice.dig("message", "role"), choice.dig("message", "content"))
      })
    end

    private

    def auth(req)
      req["Authorization"] = "Bearer #{@secret}"
    end
  end
end
