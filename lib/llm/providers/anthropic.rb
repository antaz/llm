# frozen_string_literal: true

module LLM
  require "net/http"
  require "uri"
  require "json"
  require "llm/http/client"
  require "llm/adapter"
  require "llm/message"

  class Anthropic < Adapter
    BASE_URL = "https://api.anthropic.com/v1"
    DEFAULT_PARAMS = {
      model: "claude-3-5-sonnet-20240620"
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
      body = {
        messages: [{role: "user", content: prompt}],
        **DEFAULT_PARAMS,
        **params
      }

      req = Net::HTTP::Post.new("#{@uri}/messages")
      req.content_type = "application/json"
      req.body = JSON.generate(body)
      auth(req)
      res = @http.post(req)

      JSON.parse(res.body)["content"].map do |content|
        Message.new("assistant", content.dig("text"))
      end
    end

    private

    def auth(req)
      req["x-api-key"] = @secret
    end
  end
end
