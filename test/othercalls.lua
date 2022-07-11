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

-- ForEach
local original = {1, 2, 3, 4}
local model = {2, 3, 4, 5}
local i = 1
local transformed = Stream.new(original)
            :map(function(x) return x + 1 end)
            :forEach(function(x) assert(model[i] == x, "ForEach test failed!") i += 1 end)

print("ForEach test passed!")

-- ReduceIdentity
local original = {1, 2, 3, 4}
local model = 12
local transformed = Stream.new(original)
            :reduceIdentity(2, function(a, b) return a + b end)

assert(model == transformed, "ReduceIdentity test failed!")
print("ReduceIdentity test passed!")

-- Reduce
local original = {1, 2, 3, 4}
local model = 10
local transformed = Stream.new(original)
            :reduce(function(a, b) return a + b end)

assert(model == transformed, "Reduce test failed!")
print("Reduce test passed!")

return {}