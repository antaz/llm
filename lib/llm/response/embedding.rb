# frozen_string_literal: true

module LLM
  class Response::Embedding < Response
    def model
      parsed[:model]
    end

    def embeddings
      parsed[:embeddings]
    end

    def prompt_tokens
      parsed[:prompt_tokens]
    end

    private

    def parsed
      @parsed ||= @provider.parse_embedding(raw)
    end
  end
end
