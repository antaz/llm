# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module LLM
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
      case response
      when Net::HTTPSuccess
        choices = JSON.parse(response.body)["choices"]
        choices.map { |choice| {role: choice["message"]["role"], message: choice["message"]["content"]} }
      when Net::HTTPUnauthorized
        raise "Authentication Error"
      else
        raise "HTTP Error: #{response.code} - #{response.message}"
      end
    end
  end
end
