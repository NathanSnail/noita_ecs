local map = { x = 1, y = 2, rotation = 3, scale_x = 4, scale_y = 5 }
local mt = {
	__index = function(self, field)
		return ({ EntityGetTransform(self.eid) })[map[field]]
	end,
	__newindex = function(self, field, value)
		local cur = { EntityGetTransform(self.eid) }
		cur[map[field]] = value
		EntitySetTransform(self.eid, unpack(cur))
	end,
}
return mt
