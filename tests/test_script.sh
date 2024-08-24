#!/bin/bash

# Path to the Lua script
SCRIPT_PATH="../packer.lua"

# Directory to store output files for inspection
OUTPUT_DIR="./test_outputs"
mkdir -p "$OUTPUT_DIR"

# Variable to track overall test status
overall_status=0

# Function to run a test case
run_test() {
    local desc="$1"
    local args="$2"
    local output_file="$3"
    local expected_to_fail="$4"

    echo "Running test: $desc"
    lua $SCRIPT_PATH $args

    # Check if output file exists
    if [ -f "$output_file" ] && [ "$expected_to_fail" == "0" ]; then
        echo "Test '$desc': Pass (output file exists)"
    elif [ ! -f "$output_file" ] && [ "$expected_to_fail" == "1" ]; then
        echo "Test '$desc': Pass (failed as expected)"
    else
        echo "Test '$desc': Fail (unexpected result)"
        overall_status=1
    fi
    echo
}

# Test cases
run_test "Basic Test with Title" "--title='Test Project' file1.txt file2.txt" "$OUTPUT_DIR/output1.txt" 0
run_test "Test with Assets" "--title='Test Project' --assets='assets.txt' file1.txt file2.txt --output=$OUTPUT_DIR/output2.txt" 0
run_test "Test with Main" "--title='Test Project' --main='main.lua' file1.txt file2.txt --output=$OUTPUT_DIR/output3.txt" 0
run_test "Full Feature Test" "--title='Full Feature' --author='Author' --desc='Description' --site='https://example.com' --license='MIT' --version='1.0' --main='main.lua' --assets='assets.txt' file1.txt file2.txt --output=$OUTPUT_DIR/output4.txt" 0

# Final script exit status check
if [ $overall_status -ne 0 ]; then
    echo "Some tests failed. Check the outputs for details."
    exit $overall_status
else
    echo "All tests passed. Outputs are available in $OUTPUT_DIR for manual inspection."
    exit 0
fi
