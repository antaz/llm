# frozen_string_literal: true

module LLM
  ##
  # The Anthropic class implements a provider for
  # [Anthropic](https://www.anthropic.com)
  class Anthropic < Provider
    HOST = "api.anthropic.com"
    PATH = "/v1"

    DEFAULT_PARAMS = {
      model: "claude-3-5-sonnet-20240620"
    }.freeze

    ##
    # @param secret (see LLM::Provider#initialize)
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

      Response::Completion.new(res.body, self)
    end

    private

    ##
    # @param (see LLM::Provider#completion_messages)
    # @return (see LLM::Provider#completion_messages)
    def completion_messages(raw)
      raw["content"].map { LLM::Message.new("assistant", _1["text"]) }
    end

    def auth(req)
      req["x-api-key"] = @secret
    end
  end
end
