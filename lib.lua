---@class ecs.ecs
local M = {}

---@type (fun(file: string): any)?
ACQUIRE = ACQUIRE or function(file)
	return require(file)
end

local transform_mt = ACQUIRE("transform")
local entity_mt = ACQUIRE("entity")
local component_mt = ACQUIRE("component")

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

ACQUIRE = nil
return M
