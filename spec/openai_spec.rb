# frozen_string_literal: true

require "webmock/rspec"
require "LLM/providers/openai"
require "LLM/choice"

RSpec.describe LLM::OpenAI do
  subject(:openai) { LLM::OpenAI.new("") }

  before(:each, :success) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 200,
        body: File.read(File.join(File.dirname(__FILE__), "fixtures", "openai_success.json")),
        headers: {"Content-Type" => "application/json"}
      )
  end

  before(:each, :auth_error) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(
        status: 401,
        body: File.read(File.join(File.dirname(__FILE__), "fixtures", "openai_keyerror.json")),
        headers: {"Content-Type" => "application/json"}
      )
  end

  it "Returns a successful completion", :success do
    expect(openai.complete("Hello!")).to match([
      have_attributes(
        role: "assistant",
        message: "Hello! How can I assist you today?"
      )
    ])
  end

  it "Returns an authentication error", :auth_error do
    expect { openai.complete("Hello!") }.to raise_error(LLM::AuthError)
  end
end
