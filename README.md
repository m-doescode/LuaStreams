<p align="center"><img src="https://github.com/m-doescode/LuaStreams/raw/master/docs/logo.png"></p>
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
Use the same steps as for [in lua projects](#in-lua-projects) but use the Luau file at [Streams - Luau-Roblox](https://github.com/m-doescode/LuaStreams/blob/master/Streams%20-%20Luau-Roblox.lua)
### In Lua projects
1. Download the latest Lua file at [Streams - Lua](https://github.com/m-doescode/LuaStreams/blob/master/Streams%20-%20Lua.lua)
2. Rename it to "Streams"
3. Put in your project
4. Require it via ```require(<file path>)```.

### In Roblox projects
1. Download the latest Luau file at [Streams - Luau-Roblox](https://github.com/m-doescode/LuaStreams/blob/master/Streams%20-%20Luau-Roblox.lua)
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
### Chain functions
`:filter( predicate : (any) -> boolean )` - Checks if the function returns true on each element. If it returns true, the element is kept, otherwise it is discarded.

`:map( mappingFunction : (any) -> any )` - Passes each element into the function and replaces it with the return value.

`:sorted()` - Sorts the table in ascending order according to `table.sort(t)`

`:sorted( comparator : (any, any) -> boolean )` - Sorts the table via `table.sort(t, comparator)`

`:limit( maxSize : number )` - Limits the size of the table to maxSize. If there are any more elements they are discarded.

`:skip( n : number )` - Skips first n elements in the table and discards them.

### Tail functions (final functions)
`:collect()` - Completes all the operations and converts the Stream into a table.

`:forEach( iterator : (any) -> nil )` - Iterates over the collected value of the Stream.
