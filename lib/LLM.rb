# frozen_string_literal: true

require_relative "LLM/version"
require_relative "LLM/providers/openai"

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
