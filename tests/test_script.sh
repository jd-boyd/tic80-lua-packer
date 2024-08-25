#!/bin/bash

# Path to the Lua script
SCRIPT_PATH="../packer.lua"

# Directory to store output files for inspection
OUTPUT_DIR="./test_outputs"
mkdir -p "$OUTPUT_DIR"

# Variable to track overall test status
overall_status=0

# Function to run a test case
# Function to run a test case
run_test() {
    local desc="$1"
    local args="$2"
    local output_file="$3"
    local reference_file="$4"
    local expected_to_fail="$5"

    echo "Running test: $desc"
    lua $SCRIPT_PATH $args

    # Check if output matches the reference file
    if diff -u "$output_file" "$reference_file" > /dev/null; then
        if [ "$expected_to_fail" == "0" ]; then
            echo "Test '$desc': Pass (output matches reference)"
        else
            echo "Test '$desc': Fail (expected failure but passed)"
            overall_status=1
        fi
    else
        if [ "$expected_to_fail" == "1" ]; then
            echo "Test '$desc': Pass (failed as expected)"
        else
            echo "Test '$desc': Fail (output does not match reference)"
            overall_status=1
        fi
    fi
    echo
}

# Test cases
# Test cases - Ensure to include paths to the reference files for comparison
run_test "Basic Test with Title" "--title='Test Project' file1.lua file2.lua" "$OUTPUT_DIR/output1.lua" "./references/reference_output1.lua" 0
run_test "Test with Assets" "--title='Test Project' --assets='assets.lua' file1.lua file2.lua --output=$OUTPUT_DIR/output2.lua" "./references/reference_output2.lua" 0
run_test "Test with Main" "--title='Test Project' --main='main.lua' file1.lua file2.lua --output=$OUTPUT_DIR/output3.lua" "./references/reference_output3.lua" 0
run_test "Full Feature Test" "--title='Full Feature' --author='Author' --desc='Description' --site='https://example.com' --license='MIT' --version='1.0' --main='main.lua' --assets='assets.lua' file1.lua file2.lua --output=$OUTPUT_DIR/output4.lua" "./references/reference_output4.lua" 0

# Final script exit status check
if [ $overall_status -ne 0 ]; then
    echo "Some tests failed. Check the outputs for details."
    exit $overall_status
else
    echo "All tests passed. Outputs are available in $OUTPUT_DIR for manual inspection."
    exit 0
fi
