local entity_mt = {}
local transform_mt = ACQUIRE("transform")
entity_mt.__index = {
	name = function(self)
		return EntityGetName(self.eid)
	end,
}
return entity_mt
