local Streams = require('../Streams')
local Stream = Streams.Stream

local printtable = require("printtable")

local oldt = {1, 2, 3, 4}
local t = Stream.new(oldt)
            :map(function(x) return x + 1 end)
            :collect()

printtable(oldt)
printtable(t)


return {}