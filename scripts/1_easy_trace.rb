#!/usr/bin/env ruby
require 'dotenv/load'
require 'braintrust'
require 'ruby_llm'

# Initialize Braintrust with your project name
Braintrust.init(default_project: 'My Project')

# Enable automatic tracing for RubyLLM
Braintrust.instrument!(:ruby_llm)

# Configure RubyLLM with your Anthropic API key
RubyLLM.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY']
end

# Create a chat instance with Claude 3.5 Haiku
chat = RubyLLM.chat(model: 'claude-3-5-haiku-latest')

# Make a traced request to the LLM
puts "Sending request to LLM..."
response = chat.ask('Explain what Braintrust is and how it helps with LLM observability in 2-3 sentences.')

puts "\n--- Response ---"
puts response.content
puts "\n--- Trace Info ---"
puts "Your trace has been logged to Braintrust!"
puts "View it at: https://www.braintrust.dev"
