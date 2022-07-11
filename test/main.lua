local Streams = require('../Streams')
local Stream = Streams.Stream

function compareTables(t1, t2)
    if t1 == t2 then return true end
    if #t1 ~= #t2 then return false end
    for k, v in pairs(t1) do
        if t1[k] ~= t2[k] then
            return false
        end
    end
    return true
end

-- Map
local original = {1, 2, 3, 4}
local model = {2, 3, 4, 5}
local transformed = Stream.new(original)
            :map(function(x) return x + 1 end)
            :collect()

assert(compareTables(model, transformed), "Map test failed!")
print("Map test passed!")

-- Filter
local original = {1, 2, 3, 4}
local model = {2, 4}
local transformed = Stream.new(original)
            :filter(function(x) return x % 2 == 0 end)
            :collect()

assert(compareTables(model, transformed), "Filter test failed!")
print("Filter test passed!")

-- Sorted
local original = {4, 2, 3, 1}
local model = {1, 2, 3, 4}
local transformed = Stream.new(original)
            :sorted()
            :collect()

assert(compareTables(model, transformed), "Sorted test failed!")
print("Sorted test passed!")

-- Skip
local original = {1, 2, 3, 4}
local model = {3, 4}
local transformed = Stream.new(original)
            :skip(2)
            :collect()

assert(compareTables(model, transformed), "Skip test failed!")
print("Skip test passed!")

-- Limit
local original = {1, 2, 3, 4}
local model = {1, 2}
local transformed = Stream.new(original)
            :limit(2)
            :collect()

assert(compareTables(model, transformed), "Limit test failed!")
print("Limit test passed!")

return {}