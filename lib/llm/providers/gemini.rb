# frozen_string_literal: true

module LLM
  require "net/http"
  require "uri"
  require "json"
  require "llm/http/client"
  require "llm/adapter"
  require "llm/message"

  class Gemini < Adapter
    BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash"

    def initialize(secret)
      @uri = URI.parse(BASE_URL)
      @http = Net::HTTP.new(@uri.host, @uri.port).tap do |http|
        http.use_ssl = true
        http.extend(HTTPClient)
      end
      super
    end

    def complete(prompt, params = {})
      req = Net::HTTP::Post.new("#{@uri}:generateContent")

      body = {
        contents: [{parts: [{text: prompt}]}]
      }

      req.body = JSON.generate(body)
      auth(req)
      res = @http.post(req)

      Response.new(
        JSON.parse(res.body)["candidates"].map { |candidate|
          Message.new(candidate.dig("content", "role"), candidate.dig("content", "parts", 0, "text"))
        }
      )
    end

    private

    def auth(req)
      req.path.replace "#{req.path}?#{URI.encode_www_form(key: @secret)}"
    end
  end
end
