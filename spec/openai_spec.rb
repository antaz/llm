# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe LLM::OpenAI do
  subject(:openai) { LLM::OpenAI.new("") }

  it "Returns a successful completion" do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 200,
        body: File.read(File.join(File.dirname(__FILE__), "fixtures", "openai_success.json")),
        headers: {"Content-Type" => "application/json"}
      )
    expect(openai.complete("Hello!")).to eq([
      {
        role: "assistant",
        message: "Hello! How can I assist you today?"
      }
    ])
  end

  it "Returns an authentication error" do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 401,
        body: File.read(File.join(File.dirname(__FILE__), "fixtures", "openai_keyerror.json")),
        headers: {"Content-Type" => "application/json"}
      )
    expect { openai.complete("Hello!") }.to raise_error("Authentication Error")
  end
end
