# frozen_string_literal: true

require_relative "llm/version"
require_relative "llm/providers/openai"
require_relative "llm/providers/anthropic"
require_relative "llm/providers/gemini"

module LLM
  class Error < StandardError; end

  class AuthError < StandardError
    def initialize(msg = "Authentication Error")
      super
    end
  end

  class NetError < StandardError
    def initialize(msg = "Network Error")
      super
    end
  end

  class ParseError < StandardError
    def initialize(msg = "Parsing Error")
      super
    end
  end
end
