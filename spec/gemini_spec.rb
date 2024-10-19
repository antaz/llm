# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe "LLM::Gemini" do
  subject(:gemini) { LLM.gemini("") }

  before(:each, :success) do
    stub_request(:post, "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 200,
        body: '{
          "candidates": [
            {
              "content": {
                "parts": [
                  {
                    "text": "Hello! How can I help you today? \n"
                  }
                ],
                "role": "model"
              },
              "finishReason": "STOP",
              "index": 0,
              "safetyRatings": [
                {
                  "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_HATE_SPEECH",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_HARASSMENT",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                  "probability": "NEGLIGIBLE"
                }
              ]
            }
          ],
          "usageMetadata": {
            "promptTokenCount": 2,
            "candidatesTokenCount": 10,
            "totalTokenCount": 12
          }
        }',
        headers: {"Content-Type" => "application/json"}
      )
  end

  before(:each, :auth_error) do
    stub_request(:post, "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 400,
        body: '{
          "error": {
            "code": 400,
            "message": "API key not valid. Please pass a valid API key.",
            "status": "INVALID_ARGUMENT",
            "details": [
              {
                "@type": "type.googleapis.com/google.rpc.ErrorInfo",
                "reason": "API_KEY_INVALID",
                "domain": "googleapis.com",
                "metadata": {
                  "service": "generativelanguage.googleapis.com"
                }
              }
            ]
          }
        }',
        headers: {"Content-Type" => "application/json"}
      )
  end

  it "Returns a successful completion", :success do
    completion = gemini.complete("Hello, world")
    expect(completion).to be_a(LLM::Completion)
    expect(completion.messages.first).to have_attributes(
      role: "model",
      content: "Hello! How can I help you today? \n"
    )
  end

  it "Returns an authentication error", :auth_error do
    expect { gemini.complete("Hello!") }.to raise_error(LLM::Error::Unauthorized)
  end
end
