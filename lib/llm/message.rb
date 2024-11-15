# frozen_string_literal: true

module LLM
  class Message
    attr_accessor :role, :content, :logprobs, :top_logprobs

    def initialize(role, content, logprobs: nil)
      @role = role
      @content = content
      @logprobs = logprobs
    end

    def to_h
      {role:, content:}
    end
  end
end
