local Item = { }

Item.__index = Item

function Item.new(value, next)
  local item = {}
  setmetatable(item, Item)
  item.value = value
  item.next = next
  return item
end

setmetatable(Item, {
  __call = function (_, ...)
    return Item.new(...)
  end
})

local Stack = {}

Stack.__index = Stack

function Stack.new(...)
  local stack = { head = nil, size = 0}

  setmetatable(stack, Stack)

  for _, item in pairs({...}) do
    stack:push(item)
  end

  return stack
end


function Stack:isEmpty()
  return self.size > 0
end

function Stack:push(value)
  self.head = Item(value, self.head)
  self.size = self.size + 1
  return self
end

function Stack:pop()
  assert(self.size > 0, "Stack is empty")
  local item = self.head
  self.head = item.next
  self.size = self.size - 1
  return item.value
end

function Stack:toArray()
  local array = {}
  local current = self.head

  while current ~= nil do
    table.insert(array, current.value)
    current = current.next
  end

  return array
end

function Stack:toString()
  return "stack(" .. table.concat(self:toArray(), ",") .. ")"
end

setmetatable(Stack, {
  __call = function (_, ...)
    return Stack.new(...)
  end
})

function Stack.__tostring(a)
  return Stack.toString(a)
end

function Stack.__len(a)
  return Stack.size(a)
end

function Stack:test()
  local a = Stack(1)

  assert(a.size == 1)
  assert(a:pop() == 1)
  assert(a.size == 0)

  assert(a:push(1))
  assert(a.size == 1)

  assert(a:push(2))
  assert(a.size == 2)

  assert(a:push(3))
  assert(a.size == 3)

  assert(a:toString() == "stack(3,2,1)")
  assert(a:pop() == 3)
  assert(a:pop() == 2)
  assert(a:toString() == "stack(1)")
end

return Stack
