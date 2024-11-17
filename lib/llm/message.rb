# frozen_string_literal: true

module LLM
  class Message
    attr_accessor :role, :content

    def initialize(role, content, extra = {})
      @role = role
      @content = content
      @extra = extra
    end

    ##
    # @see https://platform.openai.com/docs/api-reference/chat/object#chat/object-choices logprobs docs
    # Returns log probabilities
    # @return [Hash]
    def logprobs
      @extra[:logprobs]
    end

    def to_h
      {role:, content:}
    end
  end
end
