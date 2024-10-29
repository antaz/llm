# frozen_string_literal: true

module LLM
  class Message
    attr_accessor :role, :content

    def initialize(role, content)
      @role = role
      @content = content
    end

    def to_h
      {role:, content:}
    end
  end
end
