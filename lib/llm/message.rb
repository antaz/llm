# frozen_string_literal: true

module LLM
  class Message
    attr_accessor :role, :content

    def initialize(role, content, extra = {})
      @role = role
      @content = content
      @extra = extra
    end

    def logprobs
      extra[:logprobs]
    end

    def to_h
      {role:, content:}
    end
  end
end
