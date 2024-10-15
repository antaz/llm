# frozen_string_literal: true

require "webmock/rspec"
require "llm/providers/anthropic"

RSpec.describe LLM::Anthropic do
  subject(:anthropic) { LLM.anthropic("") }

  before(:each, :success) do
    stub_request(:post, "https://api.anthropic.com/v1/messages")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 200,
        body: '{
          "content": [
            {
              "text": "Hi! My name is Claude.",
              "type": "text"
            }
          ],
          "id": "msg_013Zva2CMHLNnXjNJJKqJ2EF",
          "model": "claude-3-5-sonnet-20240620",
          "role": "assistant",
          "stop_reason": "end_turn",
          "stop_sequence": null,
          "type": "message",
          "usage": {
            "input_tokens": 2095,
            "output_tokens": 503
          }
        }',
        headers: {"Content-Type" => "application/json"}
      )
  end

  before(:each, :auth_error) do
    stub_request(:post, "https://api.anthropic.com/v1/messages")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 403,
        body: '{
          "type": "error",
          "error": {
            "type": "invalid_request_error",
            "message": "<string>"
          }
          }',
        headers: {"Content-Type" => "application/json"}
      )
  end

  it "Returns a successful completion", :success do
    response = anthropic.complete("Hello, world")
    expect(response).to be_a(LLM::Response)
    expect(response.messages.first).to have_attributes(
      role: "assistant",
      content: "Hi! My name is Claude."
    )
  end

  it "Returns an authentication error", :auth_error do
    expect { anthropic.complete("Hello!") }.to raise_error(LLM::Error::Unauthorized)
  end
end
