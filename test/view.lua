local Streams = require('../Streams')
local Stream = Streams.Stream
local viewpairs = Streams.viewpairs

local oldt = {1, 2, 3, 4}
local t = Stream.new(oldt)
            :map(function(x) return x + 1 end)
            --:sorted()
            :view()

for i,v in viewpairs(t) do
    print(i, v)
end

return {}