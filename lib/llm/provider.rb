# frozen_string_literal: true

module LLM
  class Provider
    def initialize(secret, host, port)
      @secret = secret
      @http = Net::HTTP.new(host, port).tap do |http|
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
