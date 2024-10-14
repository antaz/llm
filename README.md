# LLM

This library offers a unified API to interact with multiple LLM providers, simplifying integration and usage across different platforms.

## Install

## Usage

```ruby
LLM::OpenAI(SECRET_TOKEN).complete("Hello")

=> [#<LLM::Message:0x00007857a3ec8bc8 @content="Hello! How can I assist you today?", @role="assistant">]
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
