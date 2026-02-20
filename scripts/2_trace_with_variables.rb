#!/usr/bin/env ruby
require 'dotenv/load'
require 'braintrust'
require 'ruby_llm'

# =============================================================================
# CONFIGURATION - Update these placeholders with your actual values
# =============================================================================
PROJECT_NAME = 'My Project'      # Your Braintrust project name
PROMPT_SLUG = 'greeting-740a'    # The slug/name of your prompt in Braintrust

# =============================================================================
# SETUP
# =============================================================================

# Initialize Braintrust (enables auto-tracing)
Braintrust.init(default_project: PROJECT_NAME)

# Enable automatic tracing for RubyLLM
Braintrust.instrument!(:ruby_llm)

# Configure RubyLLM with Anthropic
RubyLLM.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY']
end

# =============================================================================
# LOAD PROMPT FROM BRAINTRUST
# =============================================================================

puts "Loading prompt '#{PROMPT_SLUG}' from project '#{PROJECT_NAME}'..."

# Load the prompt using Braintrust::Prompt.load
prompt = Braintrust::Prompt.load(project: PROJECT_NAME, slug: PROMPT_SLUG)

puts "Prompt loaded successfully!"
puts "  ID: #{prompt.id}"
puts "  Slug: #{prompt.slug}"
puts "  Model: #{prompt.model}"
puts "---"

# =============================================================================
# BUILD AND RUN THE PROMPT
# =============================================================================

# Build the prompt with Mustache variable substitution
puts "\nBuilding prompt with variables..."
params = prompt.build(
  name: 'Mia',
  language: 'Spanish'
)

puts "  Model: #{params[:model]}"
puts "  Messages:"
params[:messages].each do |msg|
  puts "    [#{msg[:role]}] #{msg[:content]}"
end

# Use RubyLLM to execute the prompt
puts "\nExecuting prompt with RubyLLM..."

model_name = params[:model] || params['model']
puts "  Using model: #{model_name}"

chat = RubyLLM.chat(model: model_name)

# Process messages from the built prompt
# Handle both symbol and string keys
response = nil
params[:messages].each do |msg|
  role = msg[:role] || msg['role']
  content = msg[:content] || msg['content']
  
  if role.to_s == 'system'
    chat.with_instructions(content)
  elsif role.to_s == 'user'
    response = chat.ask(content)
  end
end

# =============================================================================
# OUTPUT RESULTS
# =============================================================================

puts "\n--- Response ---"
puts response&.content || "No response received"

puts "\n--- Trace Info ---"
puts "Your trace has been logged to Braintrust!"
puts "View it at: https://www.braintrust.dev"
