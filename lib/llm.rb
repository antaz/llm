# frozen_string_literal: true

require_relative "llm/version"
require_relative "llm/providers/openai"
require_relative "llm/providers/anthropic"
require_relative "llm/providers/gemini"

module LLM
  class Error < StandardError; end

  class AuthError < Error
    ##
    # @return [Net::HTTPResponse]
    #  Returns the response associated with an error
    attr_accessor :response

    def initialize(msg = "Authentication Error")
      super
    end
  end

  class NetError < Error
    def initialize(msg = "Network Error")
      super
    end
  end

  class ParseError < Error
    def initialize(msg = "Parsing Error")
      super
    end
  end
end
