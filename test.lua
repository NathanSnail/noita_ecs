---@diagnostic disable: unused-local, redefined-local
---@meta
local lib = require("lib")
-- deceive lua_ls so it doesn't ruin completions
local deceive = _G

local transforms = { { 10, 20, 0, 1, 1 }, { 30, 40, 90, 2, 3 } }
local filenames = { "hamis", "dog" }
local tags = { { animal = true, evil = true }, { animal = true } }
local names = { "silly", "cat" }
local parents = { 0, 1 }

-- test transform
---@diagnostic disable-next-line: inject-field
function deceive.EntityGetTransform(entity_id)
	return unpack(transforms[entity_id])
end

---@diagnostic disable-next-line: inject-field
function deceive.EntitySetTransform(entity_id, x, y, rotation, scale_x, scale_y)
	transforms[entity_id][1] = x
	transforms[entity_id][2] = y
	transforms[entity_id][3] = rotation
	transforms[entity_id][4] = scale_x
	transforms[entity_id][5] = scale_y
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityGetFilename(entity_id)
	return filenames[entity_id]
end

---@type entity_id
---@diagnostic disable-next-line: assign-type-mismatch
local e = 1
---@type entity_id
---@diagnostic disable-next-line: assign-type-mismatch
local second = 2
local ent2 = lib.entity(second)
local x, y, rot, sx, sy = EntityGetTransform(e)
local ent = lib.entity(e)
assert(x == 10)
assert(ent.transform.x == x)
ent.transform.y = 5
local x, y, rot, sx, sy = EntityGetTransform(e)
assert(y == 5)
assert(x == 10)
assert(rot == 0)

-- test names
---@diagnostic disable-next-line: inject-field
function deceive.EntityGetName(entity_id)
	return names[entity_id]
end

assert(ent.name == "silly")

-- test parents

---@diagnostic disable-next-line: inject-field
function deceive.EntityGetParent(entity_id)
	return parents[entity_id]
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityRemoveFromParent(entity_id)
	parents[entity_id] = 0
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityRemoveFromParent(entity_id)
	parents[entity_id] = 0
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityAddChild(parent_id, child_id)
	parents[child_id] = parent_id
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityGetAllChildren(entity_id) -- tag not used
	local children = {}
	for k, parent in ipairs(parents) do
		if parent == entity_id then
			table.insert(children, k)
		end
	end
	if #children == 0 then
		return nil
	end
	return children
end

ent2.parent.transform.x = 60
assert(ent.transform.x == 60)
ent2.parent = nil
ent.parent = ent2
assert(parents[1] == 2)
assert(#ent.children == 0)
assert(#ent2.children == 1)
ent2.children = { ent }
assert(ent2.parent == nil)
assert(#ent2.children == 1)
assert(#ent.children == 0)
--[[
--TODO:
	--local ok, res, err = pcall(function()
		ent.filename = "illegal"
	end)
	print(ok)
	assert(not ok)
	print(res)
]]

-- test tags

---@diagnostic disable-next-line: inject-field
function deceive.EntityHasTag(entity_id, tag)
	return tags[entity_id][tag] == true
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityAddTag(entity_id, tag)
	tags[entity_id][tag] = true
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityRemoveTag(entity_id, tag)
	tags[entity_id][tag] = nil
end

---@diagnostic disable-next-line: inject-field
function deceive.EntityGetTags(entity_id)
	local s = ""
	for k, _ in pairs(tags[entity_id]) do
		s = s .. k .. ","
	end
	s = s:sub(1, #s - 1)
	return s
end

assert(tostring(ent.tags) == "evil,animal" or tostring(ent.tags) == "animal,evil")
assert(ent.tags["evil"])
assert(not ent2.tags["evil"])
ent2.tags.evil = true
ent2.tags.animal = false
assert(ent2.tags["evil"])
assert(not ent2.tags.animal)
