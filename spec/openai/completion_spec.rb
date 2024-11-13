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

  before(:each, :bad_request) do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 400,
        body: {
          error: {
            message: "Failed to download image from /path/to/nowhere.bin. Image URL is invalid.",
            type: "invalid_request_error",
            param: nil,
            code: "invalid_image_url"
          }
        }.to_json
      )
  end

  before(:each, :vision) do
    stub_request(:post, "https://api.openai.com/v1/images/generations")
      .with(headers: {"Content-Type" => "application/json"})
      .to_return(
        status: 200,
        body: {
          created: 1731499418,
          data: [
            {
              revised_prompt: "Create a detailed image showing a white Siamese cat. The cat has pierce blue eyes and slightly elongated ears. It should be sitting gracefully with its tail wrapped around its legs. The Siamese cat's unique color points on its ears, face, paws and tail are in a contrast with its creamy white fur. The background is peaceful and comforting, perhaps a softly lit quieter corner of a home, with tantalizing shadows and welcoming warm colors.",
              url: "https://oaidalleapiprodscus.blob.core.windows.net/private/org-onsUXMUK28Zzsh9Vv8iWj80q/user-VcliHUdhkKDdohyDGnVsJzYg/img-C5OCBxw69p4vKtcLLIlL9xCz.png?st=2024-11-13T11%3A03%3A37Z&se=2024-11-13T13%3A03%3A37Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=d505667d-d6c1-4a0a-bac7-5c84a87759f8&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-11-12T19%3A49%3A57Z&ske=2024-11-13T19%3A49%3A57Z&sks=b&skv=2024-08-04&sig=9Bp9muevzDLdjymf%2BsnVuorprp6iCol/wI8Ih95xjhE%3D"
            }
          ]
        }.to_json
      )
  end

  context "with successful completion", :success do
    let(:completion) { openai.complete(LLM::Message.new("user", "Hello!")) }

    it "returns a completion" do
      expect(completion).to be_a(LLM::Response::Completion)
    end

    it "has model" do
      expect(completion.model).to eq("gpt-4o-mini-2024-07-18")
    end

    it "has choices" do
      expect(completion.choices.first).to have_attributes(
        role: "assistant",
        content: "Hello! How can I assist you today?"
      )
    end

    it "has token usage" do
      expect(completion).to have_attributes(
        prompt_tokens: 9,
        completion_tokens: 9,
        total_tokens: 18
      )
    end
  end

  context "with an unauthorized error", :unauthorized do
    let(:completion) { openai.complete(LLM::Message.new("user", "Hello!")) }

    it "raises an error" do
      expect { completion }.to raise_error(LLM::Error::Unauthorized)
    end

    it "includes a response" do
      completion
    rescue LLM::Error::Unauthorized => ex
      expect(ex.response).to be_kind_of(Net::HTTPResponse)
    end
  end

  context "with a bad request", :bad_request do
    subject(:completion) { openai.complete(LLM::Message.new("user", URI("/path/to/nowhere.bin"))) }

    it "raises an error" do
      expect { completion }.to raise_error(LLM::Error::BadResponse)
    end

    it "includees a response" do
      completion
    rescue LLM::Error => ex
      expect(ex.response).to be_instance_of(Net::HTTPBadRequest)
    end
  end

  context "with vision request", :vision do
    let(:vision) { openai.vision("a white siamese cat") }

    it "generates an image" do
      expect(vision).to be_a(URI).and have_attributes(to_s: "https://oaidalleapiprodscus.blob.core.windows.net/private/org-onsUXMUK28Zzsh9Vv8iWj80q/user-VcliHUdhkKDdohyDGnVsJzYg/img-C5OCBxw69p4vKtcLLIlL9xCz.png?st=2024-11-13T11%3A03%3A37Z&se=2024-11-13T13%3A03%3A37Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=d505667d-d6c1-4a0a-bac7-5c84a87759f8&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-11-12T19%3A49%3A57Z&ske=2024-11-13T19%3A49%3A57Z&sks=b&skv=2024-08-04&sig=9Bp9muevzDLdjymf%2BsnVuorprp6iCol/wI8Ih95xjhE%3D")
    end
  end
end
