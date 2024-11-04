# frozen_string_literal: true

module LLM
  ##
  # The OpenAI class implements a provider for
  # [OpenAI](https://platform.openai.com/)
  class OpenAI < Provider
    require_relative "openai/response_parser"

    HOST = "api.openai.com"
    PATH = "/v1"
    DEFAULT_PARAMS = {
      model: "gpt-4o-mini"
    }.freeze

    ##
    # @param secret (see LLM::Provider#initialize)
    def initialize(secret)
      super(secret, HOST)
    end

    def embed(input, **params)
      req = Net::HTTP::Post.new [PATH, "embeddings"].join("/")

      body = {
        input: input,
        model: "text-embedding-3-small",
        **params
      }

      req.content_type = "application/json"
      req.body = JSON.generate(body)
      auth req

      res = request @http, req

      Response::Embedding.new(res.body, self)
    end

    def complete(prompt, role = :user, **params)
      req = Net::HTTP::Post.new [PATH, "chat", "completions"].join("/")

      body = {
        messages: ((params[:messages] || []) + [Message.new(role.to_s, prompt)]).map(&:to_h),
        **DEFAULT_PARAMS,
        **params.except(:messages)
      }

      req.content_type = "application/json"
      req.body = JSON.generate(body)
      auth req

      res = request @http, req

      Response::Completion.new(res.body, self).extend(response_parser)
    end

    def chat(prompt, role = :user, **params)
      completion = complete(prompt, role, **params)
      thread = [*params[:messages], Message.new(role.to_s, prompt), completion.choices.first]
      Conversation.new(self, thread)
    end

    private

    def auth(req)
      req["Authorization"] = "Bearer #{@secret}"
    end

    def response_parser
      LLM::OpenAI::ResponseParser
    end
  end
end
