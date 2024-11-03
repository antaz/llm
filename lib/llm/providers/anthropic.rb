# frozen_string_literal: true

module LLM
  ##
  # The Anthropic class implements a provider for
  # [Anthropic](https://www.anthropic.com)
  class Anthropic < Provider
    module Parsable
      def parse_embedding(raw)
        {
          model: raw["model"],
          embeddings: raw.dig("data").map do |data|
            data["embedding"]
          end,
          total_tokens: raw.dig("usage", "total_tokens")
        }
      end

      def parse_completion(raw)
        {
          model: raw["model"],
          choices: raw["content"].map do
            # TODO: don't hardcode role
            LLM::Message.new("assistant", _1["text"])
          end,
          prompt_tokens: raw.dig("usage", "input_tokens"),
          completion_tokens: raw.dig("usage", "output_tokens")
        }
      end
    end

    include Parsable

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

    def embed(input, **params)
      req = Net::HTTP::Post.new ["api.voyageai.com/v1", "embeddings"].join("/")
      body = {
        input: input,
        model: "voyage-2",
        **params
      }

      req.content_type = "application/json"
      req.body = JSON.generate body
      auth req
      res = request @http, req

      Response::Embedding.new(res.body, self)
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

      Response::Completion.new(res.body, self)
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
  end
end
