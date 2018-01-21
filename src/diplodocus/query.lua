--   .    .     .
--  _|*._ | _  _| _  _.. . __    _.. . _ ._.  .
-- (_]|[_)|(_)(_](_)(_.(_|_)  * (_](_|(/,[  \_|
--     |                          |         ._|
--
-- one day i'll get around to making this the query system for lua that i need

local query = {}
local query_mt = {}


function query.new(t)
	local self = setmetatable({},{__index=query_mt})
	self.t = t
	return self
end

for k,v in pairs(table) do
	query_mt[v] = function(self, ...)
		return table[v](self.t, ...)
	end
end

function query_mt:clone()
	local t = {}
	for i,v in ipairs(self.t) do
		t[i] = v
	end
	return query.new(t)
end

function query_mt:filter(fn)
	local i = 1
	while i<=#self.t do
		if fn(self.t[i]) then
			i = i+1
		else
			table.remove(self.t, i)
		end
	end
	return self
end

function query_mt:map(fn)
	for i,v in ipairs(self.t) do
		self.t[i] = fn(self.t[i])
	end
	return self
end

function query_mt:first(fn)
	for i,v in ipairs(self.t) do
		if fn(v) then
			return v
		end
	end
end