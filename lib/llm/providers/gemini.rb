# frozen_string_literal: true

module LLM
  require "net/http"
  require "json"
  require "llm/provider"
  require "llm/message"

  class Gemini < Provider
    HOST = "generativelanguage.googleapis.com"
    PATH = "/v1beta/models"

    DEFAULT_PARAMS = {
      model: "gemini-1.5-flash"
    }.freeze

    def initialize(secret)
      super(secret, HOST)
    end

    def complete(prompt, params = {})
      params = DEFAULT_PARAMS.merge(params)
      path = [PATH, params.delete(:model)].join("/")
      req = Net::HTTP::Post.new [path, "generateContent"].join(":")

      body = {
        contents: [{parts: [{text: prompt}]}]
      }

      req.content_type = "application/json"
      req.body = JSON.generate body
      auth req
      res = request @http, req

      Response.new(
        JSON.parse(res.body)["candidates"].map { |candidate|
          Message.new(candidate.dig("content", "role"), candidate.dig("content", "parts", 0, "text"))
        }
      )
    end

    private

    def auth(req)
      req.path.replace [req.path, URI.encode_www_form(key: @secret)].join("?")
    end
  end
end
