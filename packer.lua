-- Function to read and concatenate file contents with custom lines
local function readAndConcatenateFiles(fileList)
    local concatenatedContent = ""  -- Initialize the variable to hold the concatenated content locally

    for _, file in ipairs(fileList) do
        local f = io.open(file, "r")  -- Open the file for reading
        if f then  -- If the file exists and is open
            local moduleName = file:match("^(.+)%..+$")  -- Extract the file name without extension
            concatenatedContent = concatenatedContent .. "package.preload['" .. moduleName .. "'] = function ()\n"  -- Add custom line before content
            local content = f:read("*a")  -- Read the entire content of the file
            concatenatedContent = concatenatedContent .. content  -- Concatenate the content
            concatenatedContent = concatenatedContent .. "\nend\n"  -- Add custom line after content
            f:close()  -- Close the file
        else
            print("Failed to open " .. file)
        end
    end

    return concatenatedContent
end

-- Process command line arguments
local files = {}
local outputFilePath = nil

for i = 1, #arg do
    if arg[i]:match("^--output=") then
        outputFilePath = arg[i]:sub(10)
    else
        table.insert(files, arg[i])
    end
end

-- Call the function with the list of files
local concatenatedContent = readAndConcatenateFiles(files)

-- Check if output to file is requested
if outputFilePath then
    local outFile = io.open(outputFilePath, "w")
    if outFile then
        outFile:write(concatenatedContent)
        outFile:close()
        print("Output written to " .. outputFilePath)
    else
        print("Failed to open output file " .. outputFilePath)
    end
else
    -- Print the concatenated contents to standard output if no output file specified
    print(concatenatedContent)
end
