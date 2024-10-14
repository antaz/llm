# frozen_string_literal: true

module LLM
  require "net/http"
  require "json"
  require "llm/http/client"
  require "llm/adapter"
  require "llm/message"
  require "llm/response"

  class Anthropic < Adapter
    HOST = "api.anthropic.com"
    PORT = 443
    PATH = "/v1"

    DEFAULT_PARAMS = {
      model: "claude-3-5-sonnet-20240620"
    }.freeze

    def initialize(secret)
      @http = Net::HTTP.new(HOST, PORT).tap do |http|
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

      req = Net::HTTP::Post.new [PATH, "messages"].join("/")
      req.body = JSON.generate(body)
      auth(req)

      res = @http.post(req)

      Response.new(JSON.parse(res.body)["content"].map { |content|
        Message.new("assistant", content.dig("text"))
      })
    end

    private

    def auth(req)
      req["x-api-key"] = @secret
    end
  end
end
