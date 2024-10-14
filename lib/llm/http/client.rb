# frozen_string_literal: true

module LLM
  module HTTPClient
    def post(req)
      req.content_type = "application/json"
      response = request(req)
      response.value
      response
    rescue Net::HTTPUnauthorized, Net::HTTPClientException
      error = LLM::AuthError.new("Authentication Error")
      error.tap { _1.response = response }
      raise error
    rescue SystemCallError
      raise LLM::NetError
    rescue JSON::ParserError
      raise LLM::ParseError
    rescue => e
      raise LLM::Error, "Unexpected Error: #{e.message}"
    end
  end
end
