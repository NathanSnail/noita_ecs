---@class ecs.ecs
local M = {}

---@type (fun(file: string): any)?
ECS_ACQUIRE = ECS_ACQUIRE or function(file)
	return require(file)
end

local transform_mt = ECS_ACQUIRE("transform")
local component_mt = ECS_ACQUIRE("component")
-- ew forward declare
local entity_mt

---@param eid entity_id
---@return ecs.transform
local function construct_transform(eid)
	return setmetatable({ eid = eid }, transform_mt)
end

---@param eid entity_id
---@return ecs.entity
function M.entity(eid)
	---@type ecs.entity
	---@diagnostic disable-next-line: missing-fields
	local ent = { filename = EntityGetFilename(eid), id = eid, transform = construct_transform(eid) } -- the other fields must be dynamically created on request
	return setmetatable(ent, entity_mt)
end
entity_mt = ECS_ACQUIRE("entity")(M)

ECS_ACQUIRE = nil
return M
