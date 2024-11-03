# frozen_string_literal: true

module LLM
  class Response::Embedding < Response
    def model
      parsed[:model]
    end

    def embeddings
      parsed[:embeddings]
    end

    private

    def parsed
      @parsed ||= @provider.parse_embedding(raw)
    end
  end
end
