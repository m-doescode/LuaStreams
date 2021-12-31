-- ## LUASTREAMS ##
-- Java 8 Streams in Luau
-- by majdTRM
-- Github: https://github.com/m-doescode/LuaStreams
																																																--[[
# Example #

local t = {
	4,
	10,
	50,
	500,
	230,
	160,
	300,
	20,
	15,
	60
}

local newTable = Stream.new(t)
					:sorted(function(a, b) return a < b end)
					:skip(5)
					:limit(4)
					:collect()

print(newTable)
-------------------
Output:
{
	60,
	160,
	230,
	300
}

# Usage #

local Streams = require(game.ServerScriptService.Streams) -- Replace with location of module
local Stream = Streams.Stream

Stream.new(t : { any }) -- Create a stream

Stream:collect() -- Finish the stream and return a new table

Stream:filter( predicate : (any) -> bool ) -- Filters the table based on the boolean return value. If it returns true, the value is kept.
If it returns false, the value is discarded.

Stream:map( mappingFunction : (any) -> any ) -- Converts (maps) each item in a table by passing it to the mappingFunction and replacing it with
the returned value.

type Comparator = (any, any) -> boolean

Stream:sorted( comparator : Comparator ) -- Sorts the table by passing each two values into the function. If the function returns true,
the first argument is put before, and the second argument is put after. If the function returns false, the second argument is put before,
and the first argument is put after. Equivalent to table.sort

Stream:limit( maxSize : number ) -- Limits the size of the table to maxSize. If there are more elements than maxSize, then those elements are
discarded.

Stream:skip( n : number ) -- Skips the first n elements in the table, discarding them.

Stream:forEach( action : (any) -> nil ) -- Iterates over the table, passing the value into the function every time. Equivalent to for-pairs loop.
																																						]]
-------------------

-- Helper Funcs

function doubleipairs(t)
	local function iter(t, i)
		i += 2
		local a = t[i]
		local b = t[i + 1]
		if a and b then
			return i, a, b
		end
	end
	return iter, t, -1
end

function comparingipairs(t)
	local function iter(t, i)
		i += 1
		local a = t[i]
		local b = t[i + 1]
		if a and b then
			return i, a, b
		end
	end
	return iter, t, 0
end

function shallowCopy(original : { any }) : { any }
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- Classes

local Stream = {}
Stream.__index = Stream
type Stream = typeof(Stream)

function Stream.new(t : { any }) : Stream
	local self = {}

	self.table = t
	self.operations = setmetatable({}, {__index = table})

	return (setmetatable(self, Stream) :: any)
end

function Stream:collect(): { any }
	local t = self.table
	for _, operation in pairs(self.operations) do
		t = operation(t)
	end
	return t
end

function Stream:filter( predicate : (any) -> boolean ) : Stream
	self.operations:insert(function(t)
		local newt = setmetatable({}, {__index = table})
		for k, v in ipairs(t) do
			if predicate(v) then
				newt[k] = v
			end
		end
		return newt
	end)

	return self
end

function Stream:map( mappingFunction : (any) -> any ) : Stream
	self.operations:insert(function(t)
		local newt = setmetatable({}, {__index = table})
		for i, v in ipairs(t) do
			newt[i] = mappingFunction(v)
		end
		return newt
	end)

	return self
end

function Stream:sorted() : Stream
	self.operations:insert(function(t)
		local newt = setmetatable(shallowCopy(t), {__index = table})
		table.sort(newt)
		return newt	
	end)

	return self
end

type Comparator = (any, any) -> boolean

function Stream:sorted( comparator : Comparator ) : Stream
	self.operations:insert(function(t)
		local newt = setmetatable(shallowCopy(t), {__index = table})
		table.sort(newt, comparator)
		return newt	
	end)

	return self
end

function Stream:limit( maxSize : number ) : Stream
	self.operations:insert(function(t)
		local newt = setmetatable({}, {__index = table})
		for i = 1, math.min(#t, maxSize) do
			newt[i] = t[i]
		end
		return newt
	end)

	return self
end

function Stream:skip( n : number ) : Stream
	self.operations:insert(function(t)
		local newt = setmetatable(shallowCopy(t), {__index = table})
		for i = 1, math.max(1, n) do
			newt:remove(1)
		end
		return newt
	end)

	return self
end

--

function Stream:forEach( action : (any) -> nil )
	for i, v in ipairs(self:collect()) do
		action(v)
	end
end

function Stream:reduce<T>( identity : T, accumulator : (T) -> T )
	local result : T = identity
	for i, v in ipairs(self:collect()) do
		result = accumulator(result, v)
	end
	return result
end

function Stream:reduce<T>( accumulator : (T) -> T )
	local found : boolean = false
	local result : T
	for i, v in ipairs(self:collect()) do
		if not found then
			found = true
			result = v
		else
			result = accumulator(result, v)
		end
	end
	return result
end

local Streams = {}

Streams.Stream = Stream

return Streams