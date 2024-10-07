# frozen_string_literal: true

require_relative "LLM/version"
require_relative "LLM/adapter"
require_relative "LLM/http/client"
require_relative "LLM/openai"

module LLM
  class Error < StandardError; end

  class AuthError < StandardError
    def initialize(msg = "Authentication failed")
      super
    end
  end

  class NetError < StandardError
    def initialize(msg = "A network error occurred")
      super
    end
  end
end
