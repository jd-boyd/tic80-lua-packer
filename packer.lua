-- Function to print help information
local function printHelp()
    print("Usage: lua script_name.lua [options] file1 file2 ...")
    print("Options:")
    print("  --title=TITLE          Sets the title of the project (required)")
    print("  --author=AUTHOR        Sets the author's name (optional)")
    print("  --desc=DESCRIPTION     Sets a description of the project (optional)")
    print("  --site=URL             Sets the website URL of the project (optional)")
    print("  --license=LICENSE      Sets the license of the project (optional)")
    print("  --version=VERSION      Sets the version number of the project (optional)")
    print("  --output=FILEPATH      Specifies the file path where the output will be written (optional)")
    print("  --main=FILEPATH        Specifies a main file to be appended at the end without additional formatting (optional)")
    print("  --assets=FILEPATH      Specifies an assets file. Content below '-- <TILES>' in this file will be appended at the end of the output (optional)")
    print("  --help                 Displays this help message")
    print("\nExample:")
    print("  lua script_name.lua --title=\"Project Title\" --author=\"Your Name\" --output=output.txt --assets=assets.txt file1.txt file2.txt")
end

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

-- Function to append assets from a specified file
local function appendAssets(filePath)
    local assetsContent = ""
    local copy = false
    local f = io.open(filePath, "r")  -- Open the assets file for reading
    if f then
        for line in f:lines() do
            if line == "-- <TILES>" or copy then
                copy = true  -- Start copying from the line where -- <TILES> is found
                assetsContent = assetsContent .. line .. "\n"
            end
        end
        f:close()
    else
        print("Failed to open assets file: " .. filePath)
    end
    return assetsContent
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
local helpRequested = false

for i = 1, #arg do
    if arg[i]:match("^--help$") then
        helpRequested = true
    elseif arg[i]:match("^--output=") then
        options.outputFilePath = arg[i]:sub(10)
    elseif arg[i]:match("^--main=") then
       options.mainFilePath = arg[i]:sub(8)
    elseif arg[i]:match("^--assets=") then
       options.assetsFilePath = arg[i]:sub(10)
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

if helpRequested then
    printHelp()
    return
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

-- Append assets content if specified
if options.assetsFilePath then
    local assetsContent = appendAssets(options.assetsFilePath)
    concatenatedContent = concatenatedContent .. assetsContent  -- Append the assets content to the output
end

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
