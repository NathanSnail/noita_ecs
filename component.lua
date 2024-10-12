local tag_mt = ECS_ACQUIRE("tags")
return function(ecs)
	---@cast ecs ecs.ecs
	---@type ecs.component
	---@diagnostic disable-next-line: missing-fields
	local component_mt = {}
	---@diagnostic disable-next-line: inject-field
	function component_mt:__index(field)
		local t = {
			enabled = function()
				return ComponentGetIsEnabled(self.id)
			end,
			tags = function()
				return setmetatable(
					{},
					tag_mt(function(val)
						return ComponentHasTag(self.id, val)
					end, function(val)
						ComponentAddTag(self.id, val)
					end, function(val)
						ComponentRemoveTag(self.id, val)
					end, function()
						return ComponentGetTags(self.id)
					end)
				)
			end,
		}
		if t[field] then
			return t[field]()
		end
		return rawget(self, field)
	end
	---@diagnostic disable-next-line: inject-field
	function component_mt:__newindex(field, value)
		local t = {
			enabled = function()
				EntitySetComponentIsEnabled(self.entity.id, self.id, value)
			end,
			tags = function()
				if type(value) == "string" then
					local t = {}
					for v in value:gmatch("[^,]+") do
						t[v] = true
					end
					value = t
				end
				local mt = getmetatable(value)
				if mt and mt.__call then
					value = value()
				elseif #value == 0 then
					local new = {}
					for k, v in pairs(value) do
						if v then
							table.insert(new, k)
						end
					end
					value = new
				end
				for _, tag in ipairs(self.tags()) do
					ComponentRemoveTag(self.id, tag)
				end
				for _, v in ipairs(value) do
					ComponentAddTag(self.id, v)
				end
			end,
		}
		if not t[field] then
			error("illegal component field to write to: " .. field)
		end
		t[field]()
	end

	return component_mt
end
