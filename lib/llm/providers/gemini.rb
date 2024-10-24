# frozen_string_literal: true

module LLM
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

      Response::Completion.new(res.body, self)
    end

    private

    ##
    # @param (see LLM::Provider#completion_model)
    # @return (see LLM::Provider#completion_model)
    def completion_model(raw)
      raw["modelVersion"]
    end

    ##
    # @param (see LLM::Provider#completion_messages)
    # @return (see LLM::Provider#completion_messages)
    def completion_messages(raw)
      raw["candidates"].map do
        LLM::Message.new(
          _1.dig("content", "role"),
          _1.dig("content", "parts", 0, "text")
        )
      end
    end

    def auth(req)
      req.path.replace [req.path, URI.encode_www_form(key: @secret)].join("?")
    end
  end
end
