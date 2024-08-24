#!/bin/bash

# Path to the Lua script
SCRIPT_PATH="./your_lua_script.lua"

# Directory to store output files for inspection
OUTPUT_DIR="./test_outputs"
mkdir -p "$OUTPUT_DIR"

# Function to run a test case
run_test() {
    local desc="$1"
    local args="$2"
    local output_file="$3"

    echo "Running test: $desc"
    lua $SCRIPT_PATH $args
    if [ -f "$output_file" ]; then
        echo "Test '$desc': Pass (output file exists)"
    else
        echo "Test '$desc': Fail (output file does not exist)"
    fi
    echo
}

# Test cases
run_test "Basic Test with Title" "--title='Test Project' file1.txt file2.txt" "$OUTPUT_DIR/output1.txt"
run_test "Test with Assets" "--title='Test Project' --assets='assets.txt' file1.txt file2.txt --output=$OUTPUT_DIR/output2.txt"
run_test "Test with Main" "--title='Test Project' --main='main.lua' file1.txt file2.txt --output=$OUTPUT_DIR/output3.txt"
run_test "Full Feature Test" "--title='Full Feature' --author='Author' --desc='Description' --site='https://example.com' --license='MIT' --version='1.0' --main='main.lua' --assets='assets.txt' file1.txt file2.txt --output=$OUTPUT_DIR/output4.txt"

# Display all output files for manual inspection
echo "All tests completed. Outputs are available in $OUTPUT_DIR for manual inspection."
