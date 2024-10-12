---@class ecs.ecs
local M = {}

---@type (fun(file: string): any)?
ECS_ACQUIRE = ECS_ACQUIRE or function(file)
	return require(file)
end

local transform_mt = ECS_ACQUIRE("transform")
-- ew forward declare
local component_mt
local entity_mt

---@param eid entity_id
---@return ecs.transform
local function construct_transform(eid)
	return setmetatable({ eid = eid }, transform_mt)
end

---@param eid entity_id
---@return ecs.entity
function M.entity(eid)
	-- the other fields must be dynamically created on request, this does mean you can assign to these fields to corrupt the table.
	---@type ecs.entity
	---@diagnostic disable-next-line: missing-fields
	local ent = { filename = EntityGetFilename(eid), id = eid, transform = construct_transform(eid) }
	return setmetatable(ent, entity_mt)
end

---@param cid component_id
---@return ecs.component
function M.component(eid, cid)
	---@type ecs.component
	local comp = {
		type = ComponentGetTypeName(cid),
		entity = M.entity(eid),
		id = cid,
		remove = function(self)
			EntityRemoveComponent(self.entity.id, self.id)
		end,
	}
	return setmetatable(comp, component_mt)
end

entity_mt = ECS_ACQUIRE("entity")(M)
component_mt = ECS_ACQUIRE("component")(M)

ECS_ACQUIRE = nil
return M
