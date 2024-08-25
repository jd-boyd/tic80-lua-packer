-- title:   Test Project


package.preload['file1'] = function ()
return function() 
    return "Hello from file1!"
end

end
package.preload['file2'] = function ()
-- file2.lua
return function ()
    return "Goodbye from file2!"
end

end
-- main.lua
local hello = require("file1")
local goodbye = require("file2")

print(hello())
print(goodbye())

