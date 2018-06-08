package.path = './src/?.lua;' .. package.path

local set = require("src/set")
local stack = require("src/stack")

local function test()
  set.test()
  stack.test()
end

return {
  set = set,
  stack = stack,
  test = test
}
