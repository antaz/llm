# frozen_string_literal: true

module LLM
  class Message
    attr_accessor :role, :content

    def initialize(role, content)
      @role = role
      @content = content
    end

    def to_h
      h = {role:}
      if URI === @content
        h.merge!({type: :image_url, content: @content.to_s})
      else
        h.merge!({type: :text, content: @content.to_s})
      end
      h
    end
  end
end
