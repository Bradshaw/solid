--   .    .     .                , .
--  _|*._ | _  _| _  _.. . __   -+-|_ *._  _
-- (_]|[_)|(_)(_](_)(_.(_|_)  *  | [ )|[ )(_]
--     |                                  ._|
--
-- diplodocus.thing is a simple system for collected objects
--
-- + call like `monkey = diplodocus.thing()` to create a new prototype
-- + to create a new instance, call like `monkey.new()`
-- + add new methods to the prototype like
--		`function monkey.mt:doThing() --[[ STUFF ]] end`
-- + add a method called `init`, it will be called on instanciation
-- + `self.options` contains the parameter sent to `.new()`
-- + call like `monkey.map.doThing()` to call a method on all instances
--		this also removes "purged" instances (instances where .purge is set)
--

local thing = function(defaultOptions)
	require("diplodocus")
	local useful = diplodocus.useful
	local obj = {}
	obj.mt = {
		init = function() end
	}
	obj.all = {}
	obj.default = defaultOptions or {}

	function obj.new(options, ...)
		local self = setmetatable({},{__index=obj.mt})
		for k,v in pairs(options or obj.default) do
			self[k] = useful.copy(v)
		end
		self.options = options
		self:init(...)
		table.insert(obj.all,self)
		return self
	end

	function obj.sort(compare)
		table.sort(obj.all, compare or obj.compare)
	end
	function obj.bubble(compare)
		local compare = compare or obj.compare
		for i = 1,#obj.all-1 do
			local u = obj.all[i]
			local v = obj.all[i+1]
			if not compare(u, v) then
				obj.all[i], obj.all[i+1] = v, u
			end
		end
	end

	obj.map = setmetatable({},{
		__index = function(table,name)
			return function(...)
				for _, v in useful.upairs(obj.all, obj.purge, obj.onPurge) do
					if (v[name]) then
						v[name](v,...)
					end
				end
			end
		end
	})



	return obj
end


return thing