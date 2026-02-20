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

## Scripts

The `scripts/` folder contains examples demonstrating different Braintrust features:

| Script | Description |
|--------|-------------|
| `1_easy_trace.rb` | Basic tracing setup with RubyLLM and Claude |
| `2_trace_with_variables.rb` | Load prompts from Braintrust and use Mustache variable substitution |
| `3_reading_comprehension_traces.rb` | Batch trace creation using OpenTelemetry with test case data |
| `4_score_comparison_eval.rb` | Run evaluations against a Braintrust dataset with custom scorers |

Run any script with:

```bash
ruby scripts/1_easy_trace.rb
```

## View your traces

After running the script, view your traces at:
https://www.braintrust.dev/app/[your-org]/p/RubyLLM%20Demo/logs
