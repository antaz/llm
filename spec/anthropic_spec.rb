# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe "LLM::Anthropic" do
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

  context "with successful completion", :success do
    let(:completion) { anthropic.complete(LLM::Message.new("user", "Hello, world")) }

    it "has model" do
      expect(completion).to have_attributes(model: "claude-3-5-sonnet-20240620")
    end

    it "has choices" do
      expect(completion).to be_a(LLM::Response::Completion).and have_attributes(
        choices: [
          have_attributes(
            role: "assistant",
            content: "Hi! My name is Claude."
          )
        ]
      )
    end

    it "has prompt_tokens" do
      expect(completion.prompt_tokens).to eq(2095)
    end

    it "has completion_tokens" do
      expect(completion.completion_tokens).to eq(503)
    end

    it "has total_tokens" do
      expect(completion.total_tokens).to eq(2095 + 503)
    end
  end

  it "returns an authentication error", :auth_error do
    expect { anthropic.complete(LLM::Message.new("user", "Hello!")) }.to raise_error(LLM::Error::Unauthorized)
  end
end
