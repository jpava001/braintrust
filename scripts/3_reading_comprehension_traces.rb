#!/usr/bin/env ruby
require 'dotenv/load'
require 'braintrust'
require 'json'

# =============================================================================
# CONFIGURATION
# =============================================================================
PROJECT_NAME = 'My Project'
PROMPT_SLUG = 'assignment-feedback-0335'
DATA_FILE = File.join(__dir__, 'data', 'reading_comprehension_test_cases.json')

# =============================================================================
# SETUP
# =============================================================================

Braintrust.init(default_project: PROJECT_NAME)

# =============================================================================
# LOAD PROMPT FROM BRAINTRUST
# =============================================================================

puts "Loading prompt '#{PROMPT_SLUG}' from project '#{PROJECT_NAME}'..."
prompt = Braintrust::Prompt.load(project: PROJECT_NAME, slug: PROMPT_SLUG)
puts "Prompt loaded successfully!"
puts "  ID: #{prompt.id}"
puts "  Slug: #{prompt.slug}"
puts "---"

# =============================================================================
# LOAD TEST CASES
# =============================================================================

puts "\nLoading test cases from #{DATA_FILE}..."
test_cases = JSON.parse(File.read(DATA_FILE))
puts "Loaded #{test_cases.length} test cases"

# =============================================================================
# CREATE TRACES FOR EACH TEST CASE
# =============================================================================

puts "\nCreating traces for each test case..."

tracer = OpenTelemetry.tracer_provider.tracer("reading-comprehension-traces")

test_cases.each_with_index do |test_case, index|
  puts "\nProcessing test case #{index + 1}/#{test_cases.length}: #{test_case['id']}"

  params = prompt.build(
    passage: test_case['passage'],
    question: test_case['question'],
    rubric: test_case['rubric'],
    student_grade: test_case['student_grade'],
    student_answer: test_case['answer']
  )

  output = test_case['llm_scoring_output']

  metadata = {
    expected_score: test_case['expected_score'],
    test_case_id: test_case['id'],
    prompt_id: prompt.id,
    prompt_slug: prompt.slug,
    prompt_project_id: prompt.project_id,
    prompt_version: prompt_version
  }

  tracer.in_span("Assignment Feedback Evaluation") do |span|
    span.set_attribute("braintrust.input_json", JSON.generate(params[:messages]))
    span.set_attribute("braintrust.output_json", JSON.generate(output))
    span.set_attribute("braintrust.metadata_json", JSON.generate(metadata))

    puts "  Created trace for: #{test_case['id']}"
    puts "    Expected score: #{test_case['expected_score']}"
    puts "    Actual score: #{output['total_score']}"
  end
end

# =============================================================================
# FLUSH AND COMPLETE
# =============================================================================

puts "\n--- Flushing traces to Braintrust ---"
OpenTelemetry.tracer_provider.force_flush

puts "\n--- Complete ---"
puts "Created #{test_cases.length} traces in Braintrust!"
puts "View them at: https://www.braintrust.dev"
