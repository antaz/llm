# frozen_string_literal: true

module LLM
  module HTTPClient
    def request(uri, secret, payload)
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{secret}"
      }

      Net::HTTP.post(uri, payload.to_json, headers)
    end
  end
end
