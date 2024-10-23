# LLM

This library offers a unified API to interact with multiple LLM providers, simplifying integration and usage across different platforms.

## Install

## Usage

```ruby
completion = LLM.openai(SECRET_TOKEN).complete "Hello"
completion.messages

=> [#<LLM::Message:0x00007bd14788c8d8 @content="Hello! How can I assist you today?", @role="assistant">]
```

## Available providers

- [x] Anthropic
- [x] OpenAI
- [x] Gemini
- [ ] Hugging Face
- [ ] Cohere
- [ ] AI21 Labs
- [ ] Replicate
- [ ] Mistral AI
