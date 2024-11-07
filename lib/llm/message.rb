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
        h[:content] = [{
          type: :image_url,
          image_url: {url: @content.to_s}
        }]
      else
        h[:type] = :text
        h[:content] = @content.to_s
      end

      h
    end
  end
end
