#!/usr/bin/env ruby
require 'dotenv/load'
require 'braintrust'
require 'json'

# =============================================================================
# CONFIGURATION
# =============================================================================
PROJECT_NAME = 'My Project'
DATA_FILE = File.join(__dir__, 'data', 'science_history_test_cases.json')

# =============================================================================
# SETUP
# =============================================================================

Braintrust.init
api = Braintrust::API.new
at_exit { OpenTelemetry.tracer_provider.shutdown }

# =============================================================================
# LOAD TEST CASES
# =============================================================================

puts "Loading test cases from #{DATA_FILE}..."
test_cases = JSON.parse(File.read(DATA_FILE))
puts "Loaded #{test_cases.length} test cases"

# =============================================================================
# DEFINE TASK AND SCORER
# =============================================================================

# Task: extract the actual score from the test case
task = ->(input) do
  input['llm_scoring_output']['total_score']
end

# Scorer: compute the difference between actual and expected scores
# Positive = actual > expected, Negative = actual < expected, Zero = match
score_difference = Braintrust::Eval.scorer("score_difference") do |input, expected, output|
  actual_score = output
  expected_score = expected
  actual_score - expected_score
end

# =============================================================================
# PREPARE DATA FOR EVALUATION
# =============================================================================

# Convert test cases to the format expected by Braintrust evaluation
eval_data = test_cases.map do |test_case|
  {
    input: test_case,
    expected: test_case['expected_score']
  }
end

# =============================================================================
# RUN EVALUATION
# =============================================================================

puts "\n" + "=" * 60
puts "Running Score Comparison Evaluation"
puts "=" * 60

Braintrust::Eval.run(
  project: PROJECT_NAME,
  experiment: "science-history-score-comparison-#{Time.now.to_i}",
  data: eval_data,
  task: task,
  scorers: [score_difference]
)

puts "\n--- Complete ---"
puts "Evaluation results have been pushed to Braintrust!"
puts "View them at: https://www.braintrust.dev"
