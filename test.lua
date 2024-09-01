---@diagnostic disable: unused-local, redefined-local
---@meta
local lib = require("lib")

local transforms = { { 10, 20, 0, 1, 1 }, { 30, 40, 90, 2, 3 } }
local filenames = { "hamis", "dog" }
-- test transform
function EntityGetTransform(entity_id)
	return unpack(transforms[entity_id])
end
function EntitySetTransform(entity_id, x, y, rotation, scale_x, scale_y)
	transforms[entity_id][1] = x
	transforms[entity_id][2] = y
	transforms[entity_id][3] = rotation
	transforms[entity_id][4] = scale_x
	transforms[entity_id][5] = scale_y
end
function EntityGetFilename(entity_id)
	return filenames[entity_id]
end
---@type entity_id
local e = 1
local x, y, rot, sx, sy = EntityGetTransform(e)
local ent = lib.entity(e)
assert(x == 10)
assert(ent.transform.x == x)
ent.transform.y = 5
local x, y, rot, sx, sy = EntityGetTransform(e)
assert(y == 5)
