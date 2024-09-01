return function(ecs)
	---@cast ecs ecs.ecs
	---@type ecs.entity
	---@diagnostic disable-next-line: missing-fields
	local entity_mt = {}
	---@diagnostic disable-next-line: inject-field
	function entity_mt:__index(field)
		local t = {
			name = function()
				return EntityGetName(self.id)
			end,
			alive = function()
				return EntityGetIsAlive(self.id)
			end,
			parent = function()
				local parent = EntityGetParent(self.id)
				if parent == 0 then
					return nil
				end
				return ecs.entity(parent)
			end,
			children = function()
				local children = EntityGetAllChildren(self.id) or {}
				local children_ents = {}
				for _, child in ipairs(children) do
					table.insert(children_ents, ecs.entity(child))
				end
				return children_ents
			end,
		}
		if t[field] then
			return t[field]()
		end
		return rawget(self, field)
	end
	---@diagnostic disable-next-line: inject-field
	function entity_mt:__newindex(field, value)
		local t = {
			name = function()
				EntitySetName(self.id, value)
			end,
			alive = function()
				if value == true then
					return
				end
				EntityKill(self.id)
			end,
			parent = function()
				EntityRemoveFromParent(self.id)
				if value ~= nil then
					EntityAddChild(value.id, self.id)
				end
			end,
			children = function()
				for _, child in ipairs(EntityGetAllChildren(self.id) or {}) do
					EntityRemoveFromParent(child)
				end
				for _, child in ipairs(value) do
					EntityRemoveFromParent(child.id)
					EntityAddChild(self.id, child.id)
				end
			end,
		}
		if not t[field] then
			error("illegal entity field to write to: " .. field)
		end
		t[field]()
	end
	return entity_mt
end
