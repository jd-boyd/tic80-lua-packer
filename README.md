# tic80-lua-packer

Bundle require'd lua scripts into one lua script.

```lua
Usage: lua script_name.lua [options] file1 file2 ...
Options:
  --title=TITLE          Sets the title of the project (required)
  --author=AUTHOR        Sets the author's name (optional)
  --desc=DESCRIPTION     Sets a description of the project (optional)
  --site=URL             Sets the website URL of the project (optional)
  --license=LICENSE      Sets the license of the project (optional)
  --version=VERSION      Sets the version number of the project (optional)
  --output=FILEPATH      Specifies the file path where the output will be written (optional)
  --main=FILEPATH        Specifies a main file to be appended at the end without additional formatting (optional)
  --assets=FILEPATH      Specifies an assets file. Content below '-- <TILES>' in this file will be appended at the end of the output (optional)
  --help                 Displays this help message

Example:
  lua script_name.lua --title="Project Title" --author="Your Name" --output=output.lua --assets=assets.lua file1.lua file2.lua
```
