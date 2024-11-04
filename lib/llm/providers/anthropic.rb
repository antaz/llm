# frozen_string_literal: true

module LLM
  ##
  # The Anthropic class implements a provider for
  # [Anthropic](https://www.anthropic.com)
  class Anthropic < Provider
    require_relative "anthropic/response_parser"

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

    def complete(prompt, role = :user, **params)
      req = Net::HTTP::Post.new [PATH, "messages"].join("/")
      body = {
        messages: ((params[:messages] || []) + [Message.new(role.to_s, prompt)]).map(&:to_h),
        **DEFAULT_PARAMS,
        **params
      }

      req.content_type = "application/json"
      req.body = JSON.generate body
      auth req
      res = request @http, req

      Response::Completion.new(res.body, self).extend(response_parser)
    end

    def chat(prompt, role = :user, **params)
      completion = complete(prompt, **params)
      thread = [*params[:messages], Message.new(role.to_s, prompt), completion.choices.first]
      Conversation.new(self, thread)
    end

    private

    def auth(req)
      req["x-api-key"] = @secret
    end

    def response_parser
      LLM::Anthropic::ResponseParser
    end
  end
end
