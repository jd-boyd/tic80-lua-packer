# tic80-lua-packer

Bundle require'd lua scripts into one lua script.

```
Usage: lua script_name.lua [options] file1 file2 ...
Options:
  --title=TITLE          Sets the title of the project (required)
  --author=AUTHOR        Sets the author's name (optional)
  --desc=DESCRIPTION     Sets a description of the project (optional)
  --site=URL             Sets the website URL of the project (optional)
  --license=LICENSE      Sets the license of the project (optional)
  --version=VERSION      Sets the version number of the project (optional)
  --output=FILEPATH      Specifies the output file path (optional)
  --main=FILEPATH        Specifies a main file to be appended without modifications (optional)
  --help                 Displays this help message
Example:
  lua script_name.lua --title="Project Title" --author="Your Name" file1.txt file2.txt --output=output.txt
```