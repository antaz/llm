# frozen_string_literal: true

module LLM
  require_relative "llm/version"
  require_relative "llm/error"
  require_relative "llm/message"
  require_relative "llm/response"
  require_relative "llm/provider"

  module_function

  def anthropic(secret)
    require_relative "llm/providers/anthropic" unless defined?(LLM::Anthropic)
    LLM::Anthropic.new(secret)
  end

  def gemini(secret)
    require_relative "llm/providers/gemini" unless defined?(LLM::Gemini)
    LLM::Gemini.new(secret)
  end

  def openai(secret)
    require_relative "llm/providers/openai" unless defined?(LLM::OpenAI)
    LLM::OpenAI.new(secret)
  end
end
