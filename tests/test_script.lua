-- Path to the Lua script
local script_path = "../packer.lua"

-- Directory to store output files for inspection
local output_dir = "./test_outputs"
os.execute("mkdir -p " .. output_dir)

-- Function to run a test case
function run_test(description, args, use_stdout, output_file,
                  reference_file, expected_to_fail)
   print("\nRunning test: " .. description)
   print("Test args: " .. args)
   -- print("Test output: " .. output_file)
   -- Run the Lua script with the provided arguments
   local cmd = "lua " .. script_path .. " " .. args
   if use_stdout then
      cmd = cmd .. " > " .. output_file
   end
   print("Test cmd: " .. cmd)
   os.execute(cmd)

    -- Compare output with the reference file
    local diff_command = "diff -u " .. output_file .. " " .. reference_file .. " > /dev/null"
    local diff_result = os.execute(diff_command)

    if diff_result == true then
        if expected_to_fail == false then
            print("Test '" .. description .. "': Pass (output matches reference)")
            return true
        else
            print("Test '" .. description .. "': Fail (expected failure but passed)")
            return false
        end
    else
        if expected_to_fail == true then
            print("Test '" .. description .. "': Pass (failed as expected)")
            return true
        else
            print("Test '" .. description .. "': Fail (output does not match reference)")
            return false
        end
    end
end

-- Define tests
local tests = {
   {description = "Basic Test with Title",
    args = "--title='Test Project' file1.lua file2.lua",
    use_stdout = true,
    output_file = output_dir .. "/output1.lua",
    reference_file = "./references/reference_output1.lua",
    expected_to_fail = false},
   {description = "Test with Assets",
    args = "--title='Test Project' --assets='assets.lua' file1.lua file2.lua --output=" .. output_dir .. "/output2.lua",
    use_stdout = false,
    output_file = output_dir .. "/output2.lua",
    reference_file = "./references/reference_output2.lua",
    expected_to_fail = false},
   {description = "Test with Main",
    args = "--title='Test Project' --main='main.lua' file1.lua file2.lua --output=" .. output_dir .. "/output3.lua",
    use_stdout = false,
    output_file = output_dir .. "/output3.lua",
    reference_file = "./references/reference_output3.lua",
    expected_to_fail = false},
   {description = "Full Feature Test",
    args = "--title='Full Feature' --author='Author' --desc='Description' --site='https://example.com' --license='MIT' --version='1.0' --main='main.lua' --assets='assets.lua' file1.lua file2.lua --output=" .. output_dir .. "/output4.lua",
    use_stdout = false,
    output_file = output_dir .. "/output4.lua",
    reference_file = "./references/reference_output4.lua",
    expected_to_fail = false}
}

-- Run all tests
local overall_status = true
for _, test in ipairs(tests) do
   local result = run_test(test.description,
                           test.args,
                           test.use_stdout,
                           test.output_file,
                           test.reference_file,
                           test.expected_to_fail)
    if result == false then
        overall_status = false
    end
end

-- Final status check
if overall_status then
    print("All tests passed. Outputs are available in " .. output_dir .. " for manual inspection.")
    os.exit(0)
else
    print("Some tests failed. Check the outputs and diffs for details.")
    os.exit(1)
end
