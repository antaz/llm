# frozen_string_literal: true

require_relative "llm/version"

module LLM
  module_function

  def anthropic(secret)
    require_relative "llm/providers/anthropic" unless defined?(Anthropic)
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
