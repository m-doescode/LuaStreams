-- ## LUASTREAMS ##
-- Java 8 Streams in Luau
-- by majdTRM
-- Github: https://github.com/m-doescode/LuaStreams
-------------------

-- Classes

local Stream = {}
Stream.__index = Stream
type Stream = typeof(Stream)

-- Helper Funcs

type Iterator = ({ any }, number) -> (number, any)

function viewpairs( view: { any } ): (Iterator, any, number)
	local function iter(a: { any }, i: number): (number, any)
		i = i + 1
		local v = a[i]
		if v then
			return i, v
		end
	end

	return iter, view, 0
end

-- Constructors

function Stream.new(t : { any }) : Stream
	local self = {}

	self.reference = t
	self.tailoperation = function(i) return t[i] end

	return (setmetatable(self, Stream) :: any)
end

function Stream.values(t : { any }) : Stream
	local newt = setmetatable({}, {__index = table})

	for _, v in pairs(t) do
		newt:insert(v)
	end

	return Stream.new(newt)
end

function Stream.entrySet(t : { any }) : Stream
	local newt = setmetatable({}, {__index = table})

	for k, v in pairs(t) do
		newt:insert({ key = k, value = v })
	end

	return Stream.new(newt)
end

---

function Stream:filter( predicate : (any) -> boolean ) : Stream
	local prev = self.tailoperation

	self.tailoperation = function(i)
		local validi = 0
		local j = 1
		local v = prev(j)
		while v ~= nil do
			if predicate(v) then
				validi += 1
			end

			if validi == i then
				return v
			elseif validi > i then
				return nil
			end

			j += 1
			v = prev(j)
		end
	end

	return self
end

function Stream:map( mappingFunction : (any) -> any ) : Stream
	local prev = self.tailoperation

	self.tailoperation = function(i)
		local v = prev(i)
		if v == nil then return nil end
		return mappingFunction(v)
	end

	return self
end

function Stream:sorted() : Stream
	return self:sortedUsing(nil)
end

type Comparator = (any, any) -> boolean

--TODO: Implement an actual sorting system instead of this stupid hack
function Stream:sortedUsing( comparator: Comparator ) : Stream
	local prev = self.tailoperation

	local tcache = nil

	self.tailoperation = function(i)
		if tcache == nil then
			tcache = {}
			for i, v in function(_, i) i += 1 local v = prev(i) if v then return i, v end end, nil, 0 do tcache[i] = v end
			table.sort(tcache, comparator)
		end

		return tcache[i]
	end

	return self
end


function Stream:limit( maxSize : number ) : Stream
	local prev = self.tailoperation

	self.tailoperation = function(i)
		if i > maxSize then
			return nil
		else
			return prev(i)
		end
	end

	return self
end

function Stream:skip( n : number ) : Stream
	local prev = self.tailoperation

	self.tailoperation = function(i)
		return prev(i + n)
	end

	return self
end

--

function Stream:view(): { any }
	return setmetatable({}, {
		__index = function(t, i) return self.tailoperation(i) end,
		__newindex = function(t, i, n) return self.tailsetoperation(i, n) end
	})
end

function Stream:collect(): { any }
	local t = {}

	local i = 1
	local v = nil
	repeat
		v = self.tailoperation(i)
		t[i] = v
		i += 1
	until v == nil

	return t
end

function Stream:forEach( action : (any) -> nil )
	for i, v in streampairs(self:view()) do
		action(v)
	end
end

function Stream:reduceIdentity<T>( identity : T, accumulator : (T) -> T )
	local result : T = identity
	for i, v in streampairs(self:view()) do
		result = accumulator(result, v)
	end
	return result
end

function Stream:reduce<T>( accumulator : (T) -> T )
	local found : boolean = false
	local result : T
	for i, v in streampairs(self:view()) do
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
Streams.streampairs = streampairs

return Streams