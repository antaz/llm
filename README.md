# LLM

This library offers a unified API to interact with multiple LLM providers, simplifying integration and usage across different platforms.

## Install

## Usage

```ruby
openai = LLM::OpenAI(SECRET_TOKEN)
response = openai.complete("Hello")

[#<LLM::Choice:0x00007237ddbb6250 @message="Hello! How can I assist you today?", @role="assistant">]
```
