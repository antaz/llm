# frozen_string_literal: true

module LLM
  ##
  # The OpenAI class implements a provider for
  # [OpenAI](https://platform.openai.com/)
  class OpenAI < Provider
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

      Response::Completion.new(res.body, self)
    end

    def chat(prompt, role = :user, **params)
      completion = complete(prompt, role, **params)
      thread = [*params[:messages], Message.new(role.to_s, prompt), completion.choices.first]
      Conversation.new(self, thread)
    end

    private

    ##
    # @param (see LLM::Provider#completion_model)
    # @return (see LLM::Provider#completion_model)
    def completion_model(raw)
      raw["model"]
    end

    ##
    # @param (see LLM::Provider#completion_choices)
    # @return (see LLM::Provider#completion_choices)
    def completion_choices(raw)
      raw["choices"].map do
        LLM::Message.new(*_1["message"].values_at("role", "content"))
      end
    end

    def completion_prompt_tokens(raw)
      raw.dig("usage", "prompt_tokens")
    end

    def completion_completion_tokens(raw)
      raw.dig("usage", "completion_tokens")
    end

    def completion_total_tokens(raw)
      raw.dig("usage", "total_tokens")
    end

    def auth(req)
      req["Authorization"] = "Bearer #{@secret}"
    end
  end
end
