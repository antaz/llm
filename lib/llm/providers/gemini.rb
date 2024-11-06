# frozen_string_literal: true

module LLM
  ##
  # The Gemini class implements a provider for
  # [Gemini](https://ai.google.dev/)
  class Gemini < Provider
    require_relative "gemini/response_parser"

    HOST = "generativelanguage.googleapis.com"
    PATH = "/v1beta/models"
    DEFAULT_PARAMS = { model: "gemini-1.5-flash" }.freeze

    ##
    # @param secret (see LLM::Provider#initialize)
    def initialize(secret)
      super(secret, HOST)
    end

    def embed(input, **params)
      path = [PATH, "text-embedding-004"].join("/")
      req = Net::HTTP::Post.new [path, "embedContent"].join(":")
      body = { content: { parts: [{text: input}] } }
      req = preflight(req, body)
      res = request @http, req
      Response::Embedding.new(res.body, self)
    end

    def complete(prompt, role = :user, **params)
      params = DEFAULT_PARAMS.merge(params)
      path = [PATH, params.delete(:model)].join("/")
      req = Net::HTTP::Post.new [path, "generateContent"].join(":")
      messages = [*(params.delete(:messages) || []), Message.new(role.to_s, prompt)]
      body = {
        contents: [{
          parts: messages.map { |m| {text: m.content} }
        }]
      }
      req = preflight(req, body)
      res = request @http, req
      Response::Completion.new(res.body, self).extend(response_parser)
    end

    private

    def auth(req)
      req.path.replace [req.path, URI.encode_www_form(key: @secret)].join("?")
    end

    def response_parser
      LLM::Gemini::ResponseParser
    end
  end
end
