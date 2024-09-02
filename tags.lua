---@param read fun(key: string): boolean
---@param add fun(key: string)
---@param remove fun(key: string)
---@param str fun(): string
---@return ecs.tags
local function construct_tag_mt(read, add, remove, str)
	---@type ecs.tags
	local tag_mt = {}
	---@diagnostic disable-next-line: assign-type-mismatch
	function tag_mt:__index(key)
		return read(key)
	end
	---@diagnostic disable-next-line: assign-type-mismatch
	function tag_mt:__newindex(key, value)
		if value then
			add(key)
		else
			remove(key)
		end
	end
	---@diagnostic disable-next-line: assign-type-mismatch
	function tag_mt:__call()
		local t = {}
		for v in str():gmatch("[^,]+") do
			table.insert(t, v)
		end
		return t
	end

	---@diagnostic disable-next-line: assign-type-mismatch
	function tag_mt:__tostring()
		return str()
	end

	return tag_mt
end
return construct_tag_mt
