# frozen_string_literal: true

module LLM
  require "net/http"
  require "uri"
  require "json"
  require "llm/http/client"
  require "llm/adapter"
  require "llm/message"

  class OpenAI < Adapter
    BASE_URL = "https://api.openai.com/v1"
    DEFAULT_PARAMS = {
      model: "gpt-4o-mini"
    }.freeze

    def initialize(secret)
      @uri = URI.parse(BASE_URL)
      @http = Net::HTTP.new(@uri.host, @uri.port).tap do |http|
        http.use_ssl = true
        http.extend(HTTPClient)
      end
      super
    end

    def complete(prompt, params = {})
      req = Net::HTTP::Post.new("#{@uri}/chat/completions")

      body = {
        messages: [{role: "user", content: prompt}],
        **DEFAULT_PARAMS,
        **params
      }

      req.content_type = "application/json"
      req.body = JSON.generate(body)
      auth(req)

      response = @http.post(req)

      JSON.parse(response.body)["choices"].map do |choice|
        Message.new(choice.dig("message", "role"), choice.dig("message", "content"))
      end
    end

    private

    def auth(req)
      req["Authorization"] = "Bearer #{@secret}"
    end
  end
end
