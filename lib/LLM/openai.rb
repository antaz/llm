# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module LLM
  class OpenAI < Adapter
    URL = "https://api.openai.com/v1"
    DEFAULT_PARAMS = {
      model: "gpt-4o-mini",
      temperature: 0.7
    }

    def initialize(secret)
      super
    end

    def complete(prompt, params = DEFAULT_PARAMS)
      uri = URI.parse("#{URL}/chat/completions")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@secret}"
      }

      request = Net::HTTP::Post.new(uri.path, headers)

      request.body = {messages: [{role: "user", content: prompt}]}.merge(params).to_json

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)["choices"][0]["message"]["content"]
      else
        raise "API request failed with status #{response.code}: #{response.message}"
      end
    end
  end
end
