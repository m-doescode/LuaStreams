<p align="center"><img src="https://github.com/m-doescode/LuaStreams/raw/alpha-2/docs/logo.png"></p>
<h1 align="center">LuaStreams</h1>

(Icon designed by m-doescode using Lunacy created by [Icons8](https://icons8.com/))

LuaStreams brings the Java 8 Streams library to Lua or Luau (Roblox).

Streams are away to easily apply logic to a list without cluttering your code with many for-loops and if-statements.
e.g.
```lua
local t = {1, 6, 2, 3, 8}

table.sort(t)
local squared = {}
for i, num in ipairs(t) do
	squared[i] = math.pow(num, 2)
end
local randomNumber = math.random(1, #t)
print(randomNumber .. " of list is: " .. squared[i]) 
```
Can be written as:
```lua
local Streams = require(game.ServerScriptService.Streams)
local Stream = Streams.Stream

local t = {1, 6, 2, 3, 8}

local final = Stream.new(t)
		:sorted()
		:map(function(num) return math.pow(num, 2) end)
		:collect()

local randomNumber = math.random(1, #t)
print(randomNumber .. " of list is: " .. squared[i]) 
```

## Importing
### In plain-Luau projects (non-Roblox)
Use the same steps as for [in lua projects](#in-lua-projects) but use the Luau file at [Streams.lua](https://github.com/m-doescode/LuaStreams/blob/master/Streams.lua)

### In Roblox projects
1. Download the latest Luau file at [Streams.lua](https://github.com/m-doescode/LuaStreams/blob/master/Streams.lua)
2. Rename it to "Streams"
3. Put it in ServerScriptService
4. Require it via ```require(game.ServerScriptService.Streams)```

## Usage
### Basic Tutorial
If you have not used Java 8 Streams or you aren't completely sure how to use them, you can refer to here.

First, you must create a Stream via `Stream.new(t : table)` where t is a table that you want to use streams with.

Then you can chain function calls on the returned value like so:
```lua
Stream.new(t)
	:map(...)
	:sorted()
	:filter(...)
	...
```
Then finally, you may either use `forEach` to iterate over it or `collect` to convert it to a table.
e.g.
```lua
local t = {5, 2, 3, 1, 4}

Stream.new(t)
	:sorted(function(a, b) return a > b end)
	:forEach(function(num)
		print("Countdown: " .. num)
	end)
```
### Constructors
`Stream.new( t : { any } )` - Creates a new stream based on the list t.

`Stream.values( t : { any } )` - Gets the values from the dictionary t and creates a new Stream based on it.

`Stream.entrySet( t : { any } )` - Converts the dictionary t into a list of entries that go `{ key = <key>, value = <value> }`.

### Chain functions
`:filter( predicate : (any) -> boolean )` - Checks if the function returns true on each element. If it returns true, the element is kept, otherwise it is discarded.

`:map( mappingFunction : (any) -> any )` - Passes each element into the function and replaces it with the return value.

`:sorted()` - Sorts the table in ascending order according to `table.sort(t)`

`:sorted( comparator : (any, any) -> boolean )` - Sorts the table via `table.sort(t, comparator)`

`:limit( maxSize : number )` - Limits the size of the table to maxSize. If there are any more elements they are discarded.

`:skip( n : number )` - Skips first n elements in the table and discards them.

### Tail functions (final functions)
`:collect() : { any }` - Completes all the operations and converts the Stream into a table.

`:forEach( iterator : (any) -> nil )` - Iterates over the collected value of the Stream.

`:pairs()` - Returns an iterator. Works like `forEach` but in for loops.

`:reduce<T>( identity : T, accumulator : (T, T) -> T )` - Passes each element as the second argument into the accumulator, and the last result (return value) as the first argument. If there was no last result, it will pass identity.

`:reduce<T>( accumulator : (T, T) -> T )` - Passes each element as the second argument into the accumulator, and the last result (return value) as the first argument. If there was no last result, the accumulator will not be called and result will be set to the first item in the table.
