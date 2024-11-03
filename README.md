# LLM

A lightweight Ruby library for interacting with multiple LLM providers

## Install

## Usage

```ruby
LLM
  .openai(OPENAI_KEY)
  .chat("Be a helpful assistant", :system)
  .chat("How many moons Jupiter has?")
  .thread
  .last # => "As of my last update in October 2023, Jupiter has 80 known moons. The four largest moons, known as the Galilean moons ..."
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
