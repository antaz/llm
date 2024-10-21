# frozen_string_literal: true

module LLM
  require "net/http"
  require "json"
  require "llm/provider"
  require "llm/message"
  require "llm/completion"

  class Gemini < Provider
    HOST = "generativelanguage.googleapis.com"
    PATH = "/v1beta/models"

    def initialize(secret)
      super(secret, HOST)
    end

    def complete(prompt, params = {})
      params = {model: "gemini-1.5-flash"}.merge(params)
      path = [PATH, params[:model]].join("/")
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

    ##
    # @param (see LLM::Provider#completion_messages)
    # @return (see LLM::Provider#completion_messages)
    def completion_messages(raw)
      Message.new(raw["candidate"].dig("content", "role"), candidate.dig("content", "parts", 0, "text"))
    end

    private

    def auth(req)
      req.path.replace [req.path, URI.encode_www_form(key: @secret)].join("?")
    end
  end
end
