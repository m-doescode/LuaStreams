local Streams = require('../Streams')
local Stream = Streams.Stream
local viewpairs = Streams.viewpairs

function compareTables(t1, t2)
    if t1 == t2 then return true end
    local lasti = 0
    for i, v in viewpairs(t1) do
        lasti = i
        if t1[i] ~= t2[i] then
            return false
        end
    end
    if lasti < #t2 or lasti > #t2 then
        return false
    end
    return true
end

local original = {1, 2, 3, 4}
local model = {3, 4, 5}
local transformed = Stream.new(original)
            :map(function(x) return x + 1 end)
            :skip(1)
            :view()

assert(compareTables(transformed, model), "View test failed!")
print("View test passed!")

local original = {1, 2, 3}
local model = {1, 2, 3, 4}
local transformed = Stream.new(original)
            :view()

assert(not compareTables(transformed, model), "compareTables test failed!")
print("compareTables test passed!")

return {}