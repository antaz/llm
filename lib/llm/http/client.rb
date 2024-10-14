# frozen_string_literal: true

module LLM
  module HTTPClient
    def request(uri, secret, payload)
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{secret}"
      }

      begin
        response = Net::HTTP.post(uri, payload.to_json, headers)
        response.value
        response
      rescue Net::HTTPUnauthorized, Net::HTTPClientException
        raise LLM::AuthError
      rescue SystemCallError
        raise LLM::NetError
      rescue JSON::ParserError
        raise LLM::ParseError
      rescue => e
        raise LLM::Error, "Unexpected Error: #{e.message}"
      end
    end
  end
end
