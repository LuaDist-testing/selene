local Set = {}

Set.__index = Set

function Set.new(...)
  local set = {}

  setmetatable(set, Set)

  for _, item in pairs({...}) do
    set:insert(item)
  end

  return set
end

function Set:insert(item)
  self[item] = true
  return self
end

function Set:remove(item)
  table.remove(self, item)
  return self
end

function Set:isMember(item)
  if self[item] == true then
    return true
  else
    return false
  end
end

function Set:size()
  local counter = 0

  for _, _ in pairs(self) do
    counter = counter + 1
  end

  return counter
end

function Set:union(other)
  local result = Set()

  for key, _ in pairs(self) do
    result:insert(key)
  end

  for key, _ in pairs(other) do
    result:insert(key)
  end

  return result
end

function Set:intersection(other)
  local result = Set()

  for key, _ in pairs(self) do
    if other:isMember(key) then
      result:insert(key)
    end
  end

  return result
end

function Set:difference(other)
  local result = Set()

  for key, _ in pairs(self) do
    if not other:isMember(key) then
      result:insert(key)
    end
  end

  return result
end

function Set:isSubset(other)
  for key, _ in pairs(self) do
    if not other:isMember(key) then
      return false
    end
  end

  return true
end

function Set:isProperSubset(other)
  return self:isSubset(other) and (self:size() ~= other:size())
end

function Set:isSuperset(other)
  return other:isSubset(self)
end

function Set:isProperSuperset(other)
  return (self:size() ~= other:size()) and self:isSuperset(other)
end

function Set:isEqual(other)
  return (self:size() == other:size()) and self:isSubset(other)
end

function Set:isEmpty()
  return self:size() == 0
end

function Set:toArray()
  local result = {}

  for key, _ in pairs(self) do
    table.insert(result, key)
  end

  return result
end

function Set:toString()
  return "set(" .. table.concat(self:toArray(), ", ") .. ")"
end

setmetatable(Set, {
  __call = function (_, ...)
    return Set.new(...)
  end
})

function Set.__add(a,b)
  return Set.union(a,b)
end

function Set.__sub(a,b)
  return Set.difference(a,b)
end

function Set.__concat(a,b)
  return Set.union(a,b)
end

function Set.__eq(a,b)
  return Set.isEqual(a,b)
end

function Set.__len(a)
  return Set.size(a)
end

function Set.__lt(a,b)
  return Set.isProperSubset(a,b)
end

function Set.__le(a,b)
  return Set.isSubset(a,b)
end

function Set.__tostring(a)
  return a:toString()
end

function Set.test()
  local a = Set()

  a:insert(1)
  assert(a:size() == 1)

  a:insert(2)
  assert(a:size() == 2)

  a:insert(1)
  assert(a:size() == 2)

  a:remove(3)
  assert(a:size() == 2)

  a:remove(1)
  assert(a:size() == 1)

  a:insert(3)
  a:insert(4)
  a:insert(5)

  local b = Set()

  b:insert(2)
  b:insert(3)
  b:insert(4)
  b:insert(5)
  b:insert(6)

  assert(b:size(), 5)

  local c = Set(1,2,3,4,5)
  local d = Set(3,4,5,6,7)
  local e = (c:intersection(d))

  assert(e:size() == 3)

  assert(e:isMember(3) == true)
  assert(e:isMember(4) == true)
  assert(e:isMember(5) == true)
  assert(e:isEqual(Set(4,5,3)))

  local f = c:union(d)

  assert(f:isEqual(Set(1,2,3,4,5,6,7)))

  local g = f:difference(Set(1,2,7,100))

  assert(g:isEqual(Set(3,4,5,6)))
  assert(g:isMember(100) == false)
  assert(g:isMember(101) == false)
  assert(g:isEqual(Set(4,5,3,6)))

  assert(g:union(g):isEqual(g))
  assert(g:difference(g):isEmpty())
  assert(g:intersection(g):isEqual(g))

  assert(Set(1,2,3):isEqual(Set(3,2,1)))
  assert(Set(1,2,3):isEqual(Set(1,3,2,2,3)))

  assert(Set():isEmpty() == true)
  assert(Set(1,2,3):isEmpty() == false)

  -- with meta methods

  local x = Set(1,2,3)
  local y = Set(3,4,5)
  local z = Set(5,6,7)
  local zero = Set()

  assert(#x == 3, x:toString()..tostring((#x)))
  assert(#y == 3, x:toString()..tostring((#y)))
  assert(#z == 3, x:toString()..tostring((#z)))
  assert(#zero == 0, x:toString()..tostring((#zero)))

  -- union properties

  -- A ∪ B = B ∪ A
  assert((x + y) == (y + x))

  -- A ∪ (B ∪ C) = (A ∪ B) ∪ C
  assert((x + (y + z)) == ((x + y) + z))

  -- A ⊆ (A ∪ B)
  assert(x <= (x + y))
  assert(y <= (y + z))
  assert(z <= (z + x))

  -- A ∪ A = A
  assert((x + x) == x)
  assert((zero + zero) == zero)

  -- A ∪ ∅ = A
  assert((x + zero) == x)

  -- intersection properties

  -- A ∩ B = B ∩ A
  assert(a:intersection(b) == b:intersection(a))

  -- A ∩ (B ∩ C) = (A ∩ B) ∩ C
  assert(a:intersection(b:intersection(c)) == a:intersection(b):intersection(c))

  -- A ∩ B ⊆ A
  assert(a:intersection(b) <= a)

  -- A ∩ A = A
  assert(a:intersection(a) == a)

  -- A ∩ ∅ = ∅
  assert(a:intersection(zero) == zero)

  -- check difference

  assert((a - zero) == a)
  assert((a - a) == zero)
  assert((zero - a) == zero)
  assert((Set(1,2,3) - Set(2,3,4)) == Set(1))

  -- check equals

  assert(Set(1,2,3) ~= Set(1,2,3,4))
  assert(Set(1,2,3) == Set(1,2,3,3))

  -- check subset
  assert(Set(1,2,3) <= Set(1,2,3))
  assert(Set(1,2,3) <= Set(1,2,3,4))

  -- check proper subset
  assert(Set(1,2,4) < Set(1,2,3,4,5))
  assert(Set(1) < Set(1,2,3,4,5))

  assert((Set(1,2,6) < Set(1,2,3,4,5)) == false)
  assert((Set(1,2,6) < Set(1,2,6)) == false)

  -- check superset
  assert(Set(1,2,3) >= Set(1,2,3))
  assert(Set(1,2,3,4) >= Set(1,2,3))

  -- check proper superset
  assert(Set(1,2,3,4) > Set(1,2,3))
  assert((Set(1,2,3) > Set(1,2,3,4)) == false)
  assert((Set(1,2,3) > Set.new(1,2,3)) == false)
end

return Set
