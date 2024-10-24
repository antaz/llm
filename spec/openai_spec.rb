# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe "LLM::OpenAI" do
  subject(:openai) { LLM.openai("") }

  before(:each, :success) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 200,
        body: '{
          "id": "chatcmpl-AFIwpAMVniQWeOJZDYZ1IZpcf8zQa",
          "object": "chat.completion",
          "created": 1728211119,
          "model": "gpt-4o-mini-2024-07-18",
          "choices": [
            {
              "index": 0,
              "message": {
                "role": "assistant",
                "content": "Hello! How can I assist you today?",
                "refusal": null
              },
              "logprobs": null,
              "finish_reason": "stop"
            }
          ],
          "usage": {
            "prompt_tokens": 9,
            "completion_tokens": 9,
            "total_tokens": 18,
            "prompt_tokens_details": {
              "cached_tokens": 0
            },
            "completion_tokens_details": {
              "reasoning_tokens": 0
            }
          },
          "system_fingerprint": "fp_f85bea6784"
        }',
        headers: {"Content-Type" => "application/json"}
      )
  end

  before(:each, :unauthorized) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 401,
        body: '{
          "error": {
            "message": "Incorrect API key provided: sk-6WQZM***************************************t6ea. You can find your API key a t https://platform.openai.com/account/api-keys.",
            "type": "invalid_request_error",
            "param": null,
            "code": "invalid_api_key"
          }
          }',
        headers: {"Content-Type" => "application/json"}
      )
  end

  context "with successful completion", :success do
    let(:completion) { openai.complete("Hello!") }

    it "has model" do
      expect(completion).to have_attributes(model: "gpt-4o-mini-2024-07-18")
    end

    it "has messages" do
      expect(completion).to be_a(LLM::Response::Completion).and have_attributes(
        messages: [
          have_attributes(
            role: "assistant",
            content: "Hello! How can I assist you today?"
          )
        ]
      )
    end
  end

  context "with an unauthorized error", :unauthorized do
    it "raises an error" do
      expect { openai.complete("Hello!") }.to raise_error(LLM::Error::Unauthorized)
    end

    it "includes the response" do
      openai.complete("Hello!")
    rescue LLM::Error::Unauthorized => ex
      expect(ex.response).to be_kind_of(Net::HTTPResponse)
    end
  end
end
