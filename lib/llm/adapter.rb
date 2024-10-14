# frozen_string_literal: true

module LLM
  class Adapter
    def initialize(secret, uri)
      @uri = URI.parse(uri)
      @secret = secret
      @http = Net::HTTP.new(@uri.host, @uri.port).tap do |http|
        http.use_ssl = true
        http.extend(HTTPClient)
      end
    end

    def complete(prompt)
      raise NotImplementedError
    end

    private

    def auth(req)
      raise NotImplementedError
    end
  end
end
