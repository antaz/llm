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
    # @see https://cookbook.openai.com/examples/using_logprobs logprobs cookbook
    # @note logprobs are specific to OpenAI for now
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
