# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe LLM::OpenAI do
  subject(:openai) { LLM::OpenAI.new("") }

  before(:each, :success) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
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

  before(:each, :auth_error) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
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

  it "Returns a successful completion", :success do
    expect(openai.complete("Hello!")).to be_a(LLM::Response).and have_attributes(
      messages: [
        have_attributes(
          role: "assistant",
          content: "Hello! How can I assist you today?"
        )
      ]
    )
  end

  it "Returns an authentication error", :auth_error do
    expect { openai.complete("Hello!") }.to raise_error(LLM::AuthError)
  end
end
