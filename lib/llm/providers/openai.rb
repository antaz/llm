# frozen_string_literal: true

module LLM
  ##
  # The OpenAI class implements a provider for
  # [OpenAI](https://platform.openai.com/)
  class OpenAI < Provider
    require_relative "openai/error_handler"
    require_relative "openai/response_parser"

    HOST = "api.openai.com"
    DEFAULT_PARAMS = {model: "gpt-4o-mini"}.freeze

    ##
    # @param secret (see LLM::Provider#initialize)
    def initialize(secret)
      super(secret, HOST)
    end

    def embed(input, **params)
      req = Net::HTTP::Post.new ["/v1", "embeddings"].join("/")
      body = {input:, model: "text-embedding-3-small"}.merge!(params)
      req = preflight(req, body)
      res = request @http, req
      Response::Embedding.new(res.body, self)
    end

    def complete(message, **params)
      req = Net::HTTP::Post.new ["/v1", "chat", "completions"].join("/")
      messages = [*(params.delete(:messages) || []), message]
      params = DEFAULT_PARAMS.merge(params)
      body = {messages: messages.map(&:to_h)}.merge!(params)
      req = preflight(req, body)
      res = request(@http, req)
      Response::Completion.new(res.body, self).extend(response_parser)
    end

    def vision(prompt, **params)
      req = Net::HTTP::Post.new ["/v1", "images", "generations"].join("/")
      body = {prompt:, model: "dall-e-3", n: 1}.merge!(params)
      req = preflight(req, body)
      res = request @http, req
      Response::Vision.new(res.body, self).extend(response_parser)
    end

    ##
    # @param prompt (see LLM::Provider#transform_prompt)
    # @return (see LLM::Provider#transform_prompt)
    def transform_prompt(prompt)
      if URI === prompt
        [{type: :image_url, image_url: {url: prompt.to_s}}]
      else
        prompt
      end
    end

    private

    def auth(req)
      req["Authorization"] = "Bearer #{@secret}"
    end

    def response_parser
      LLM::OpenAI::ResponseParser
    end

    def error_handler
      LLM::OpenAI::ErrorHandler
    end
  end
end
