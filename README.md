# LLM

This library offers a unified API to interact with multiple LLM providers, simplifying integration and usage across different platforms.

## Install

## Usage

```ruby
openai = LLM::OpenAI(SECRET_TOKEN)
openai.complete("Hello")
```

```
[
  {:role=>"assistant", :message=>"Hello! How can I assist you today?"}
]
```
