-- title:   Full Feature
-- author:  Author
-- desc:    Description
-- site:    https://example.com
-- license: MIT
-- version: 1.0


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

-- <TILES>
-- 000:4444444433344433333434424234334444433044343332423242332432443444
-- </TILES>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
