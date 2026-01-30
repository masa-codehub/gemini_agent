#!/bin/bash

# Test Runner for Gemini Implementer Script
# Usage: bash .github/workflows/tests/run_test_issue.sh

# Ensure we are in the project root
if [ ! -f ".github/workflows/script/gemini_implementer.sh" ]; then
    echo "Error: Please run this script from the project root directory."
    echo "Usage: bash .github/workflows/tests/run_test_issue.sh"
    exit 1
fi

# Load Test Issue
TEST_ISSUE_FILE=".github/workflows/tests/test_issue_001.md"

if [ ! -f "$TEST_ISSUE_FILE" ]; then
    echo "Error: Test issue file not found at $TEST_ISSUE_FILE"
    exit 1
fi

# Parse Title from Frontmatter
# Example: title: "Add Hello World Function"
export ISSUE_TITLE=$(grep '^title:' "$TEST_ISSUE_FILE" | head -n 1 | sed 's/title: "\(.*\)"/\1/')

# Parse Body (remove frontmatter)
# We find the second '---' and take everything after it.
# This is a bit tricky with sed/awk across different OS, 
# but a common way is to use awk.
export ISSUE_BODY=$(awk 'BEGIN {f=0} /^---$/ {f++; next} f>=2 {print}' "$TEST_ISSUE_FILE")

# Set Dummy Issue Number
export ISSUE_NUMBER="999"

echo "=== Test Environment Setup ==="
echo "ISSUE_NUMBER: $ISSUE_NUMBER"
echo "ISSUE_TITLE: $ISSUE_TITLE"
echo "ISSUE_BODY (First 50 chars): $(echo "$ISSUE_BODY" | head -c 50 | tr -d '\n')..."
echo "=============================="

# Run the implementer script
echo "Running Gemini Implementer Script..."
bash .github/workflows/script/gemini_implementer.sh