#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv/load'
require "bundler/setup"
require "braintrust"

# Project name
project_name = "My Project"
Braintrust.init(default_project: project_name)

# Create a dataset with test cases
dataset_name = "Science History Test Cases"

# Define task: simple string upcase
task = ->(input) do
  rand(1..5)
end

# Define scorer: exact match
scorer = Braintrust::Eval.scorer("exact_match") do |input, expected, output|
  0
end

# Example 1: Run eval with dataset as string (uses same project)
puts "\n" + "=" * 60
puts "Example 1: Dataset as string (same project)"
puts "=" * 60

Braintrust::Eval.run(
  project: project_name,
  experiment: "dataset-eval-string",
  dataset: dataset_name,  # Simple string - fetches from same project
  task: task,
  scorers: [scorer]
)

OpenTelemetry.tracer_provider.force_flush

puts "Done"
