-- Function to generate metadata header based on command line flags
local function generateHeader(options)
    local header = ""
    if options.title then header = header .. "-- title:   " .. options.title .. "\n" end
    if options.author then header = header .. "-- author:  " .. options.author .. "\n" end
    if options.desc then header = header .. "-- desc:    " .. options.desc .. "\n" end
    if options.site then header = header .. "-- site:    " .. options.site .. "\n" end
    if options.license then header = header .. "-- license: " .. options.license .. "\n" end
    if options.version then header = header .. "-- version: " .. options.version .. "\n" end
    return header
end

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
local options = {}

for i = 1, #arg do
    if arg[i]:match("^--output=") then
        options.outputFilePath = arg[i]:sub(10)
    elseif arg[i]:match("^--main=") then
        options.mainFilePath = arg[i]:sub(8)
    elseif arg[i]:match("^--title=") then
        options.title = arg[i]:sub(9)
    elseif arg[i]:match("^--author=") then
        options.author = arg[i]:sub(10)
    elseif arg[i]:match("^--desc=") then
        options.desc = arg[i]:sub(8)
    elseif arg[i]:match("^--site=") then
        options.site = arg[i]:sub(8)
    elseif arg[i]:match("^--license=") then
        options.license = arg[i]:sub(11)
    elseif arg[i]:match("^--version=") then
        options.version = arg[i]:sub(11)
    else
        table.insert(files, arg[i])
    end
end

if not options.title then
    print("Error: --title flag is required")
    return
end

-- Call the function with the list of files
local concatenatedContent = readAndConcatenateFiles(files)
local header = generateHeader(options)

-- Append main file content if specified
if options.mainFilePath then
    local mainFile = io.open(options.mainFilePath, "r")
    if mainFile then
        concatenatedContent = concatenatedContent .. mainFile:read("*a")  -- Read and append the entire content of the main file
        mainFile:close()
    else
        print("Failed to open main file " .. options.mainFilePath)
    end
end

-- Combine header with the concatenated content
concatenatedContent = header .. concatenatedContent

-- Check if output to file is requested
if options.outputFilePath then
    local outFile = io.open(options.outputFilePath, "w")
    if outFile then
        outFile:write(concatenatedContent)
        outFile:close()
        print("Output written to " .. options.outputFilePath)
    else
        print("Failed to open output file " .. options.outputFilePath)
    end
else
    -- Print the concatenated contents to standard output if no output file specified
    print(concatenatedContent)
end
