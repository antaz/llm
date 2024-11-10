# LLM

A lightweight Ruby library for interacting with multiple LLM providers

## Install

## Examples

### Conversation

The
[`LLM::Provider#chat`](https://0x1eef.github.io/x/llm/LLM/Provider.html#chat-instance_method)
method returns a
[`LLM::Conversation`](https://0x1eef.github.io/x/llm/LLM/Conversation.html)
object that
can maintain a conversation with a LLM provider. Because a conversation has a
thread of messages the LLM has a certain amount of extra context that can re-used within the conversation.
With the following example each call to `chat` corresponds to a HTTP request
to the provider:

```ruby
#!/usr/bin/env ruby
require "llm"

llm = LLM.openai("yourapikey")
bot = llm.chat "be a helpful assistant", :system
bot.chat "keep the answers short and sweet", :system
bot.chat "help me choose a good book"
bot.chat "books of poetry"
bot.thread.each do |message|
  print "[#{message.role}] ", message.text, "\n"
end

##
# [system] be a helpful assistant
# [assistant] Of course! How can I assist you today?
# [system] keep the answers short and sweet
# [assistant] Got it! What do you need help with?
# [user] help me choose a good book
# [assistant] Sure! What genre are you interested in?
# [user] books of poetry
# [assistant] Here are a few great poetry collections:
#
# 1. **"The Sun and Her Flowers" by Rupi Kaur**
# 2. **"The Carrying" by Ada Limón**
# 3. **"Milk and Honey" by Rupi Kaur**
# 4. **"Ariel" by Sylvia Plath**
# 5. **"The Poetry of Pablo Neruda"**
#
# Happy reading!
```

### Lazy conversation

The
[`LLM::Provider#chat!`](https://0x1eef.github.io/x/llm/LLM/Provider.html#chat!-instance_method)
method returns a
[`LLM::LazyConversation`](https://0x1eef.github.io/x/llm/LLM/LazyConversation.html)
object
that can maintain a "lazy" conversation where input prompts are sent to the
provider only when needed. The following example demonstrates a lazy conversation
with the OpenAI provider:

```ruby
#!/usr/bin/env ruby
require "llm"

llm = LLM.openai("yourapikey")
bot = llm.chat! URI("https://upload.wikimedia.org/wikipedia/commons/b/be/Red_eyed_tree_frog_edit2.jpg")
bot.chat "What is the frog's name?"
bot.chat "What is the frog's habitat?"
bot.chat "What is the frog's diet?"
bot.thread.each do |message|
  print "[#{message.role}] ", message.content, "\n"
end

##
# [user] [{:type=>:image_url, :image_url=>{:url=>"https://upload.wikimedia.org/wikipedia/commons/b/be/Red_eyed_tree_frog_edit2.jpg"}}]
# [system] keep the answer concise
# [user] What is the frog's name?
# [user] What is the frog's habitat?
# [user] What is the frog's diet?
# [assistant] The frog in the image is likely a Red-eyed Tree Frog.
#
#  #### Habitat:
#  - Typically found in tropical rainforests, especially in Central America.
#
#  #### Diet:
#   - Primarily insectivorous, feeding on insects like crickets and moths.
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
