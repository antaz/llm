# frozen_string_literal: true

module LLM
  class Response::Completion < Response
    ##
    # @return [Array<LLM::Message>]
    #  Returns an array of messages
    def messages
      @provider.__send__ :completion_messages, raw
    end
  end
end
