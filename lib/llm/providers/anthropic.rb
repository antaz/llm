# frozen_string_literal: true

module LLM
  require "net/http"
  require "json"
  require "llm/provider"
  require "llm/message"
  require "llm/completion"

  class Anthropic < Provider
    HOST = "api.anthropic.com"
    PATH = "/v1"

    DEFAULT_PARAMS = {
      model: "claude-3-5-sonnet-20240620"
    }.freeze

    def initialize(secret)
      super(secret, HOST)
    end

    def complete(prompt, params = {})
      req = Net::HTTP::Post.new [PATH, "messages"].join("/")
      body = {
        messages: [{role: "user", content: prompt}],
        **DEFAULT_PARAMS,
        **params
      }

      req.content_type = "application/json"
      req.body = JSON.generate body
      auth req
      res = request @http, req

      Completion.new(res.body, :anthropic)
    end

    private

    def auth(req)
      req["x-api-key"] = @secret
    end
  end
end
