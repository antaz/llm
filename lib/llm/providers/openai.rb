# frozen_string_literal: true

module LLM
  require "net/http"
  require "uri"
  require "json"
  require "llm/http/client"
  require "llm/adapter"
  require "llm/choice"

  class OpenAI < Adapter
    BASE_URL = "https://api.openai.com/v1"
    ENDPOINT = "/chat/completions"
    DEFAULT_PARAMS = {
      model: "gpt-4o-mini",
      temperature: 0.7
    }.freeze

    attr_reader :http

    def initialize(secret)
      @uri = URI.parse("#{BASE_URL}#{ENDPOINT}")
      @http = Net::HTTP.new(@uri.host, @uri.port).tap do |http|
        http.use_ssl = true
        http.extend(HTTPClient)
      end
      super
    end

    def complete(prompt, params = {})
      body = {
        messages: [{role: "user", content: prompt}],
        **DEFAULT_PARAMS,
        **params
      }

      response = @http.request(@uri, @secret, body)

      JSON.parse(response.body)["choices"].map do |choice|
        Choice.new(choice.dig("message", "role"), choice.dig("message", "content"))
      end
    end
  end
end
