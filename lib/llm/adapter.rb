# frozen_string_literal: true

module LLM
  class Adapter
    def initialize(secret)
      @secret = secret
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
