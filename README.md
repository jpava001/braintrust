# Braintrust + RubyLLM Sample

This sample demonstrates how to trace LLM calls using Braintrust with the RubyLLM gem.

## Setup

1. **Install dependencies:**

   ```bash
   bundle install
   ```

2. **Configure your API keys:**

   Edit the `.env` file and add your actual API keys:

   Get your Braintrust API key from: https://www.braintrust.dev/app/settings/api-keys

## Run

```bash
ruby sample_trace.rb
```

## What it does

- Initializes Braintrust with automatic tracing enabled for RubyLLM
- Makes a chat completion request to OpenAI's GPT-4o-mini model
- Automatically captures and sends the trace to Braintrust

## View your traces

After running the script, view your traces at:
https://www.braintrust.dev/app/[your-org]/p/RubyLLM%20Demo/logs
