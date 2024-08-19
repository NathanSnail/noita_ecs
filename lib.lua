---@class set<T>: {[T]: true, add: fun(self: set<T>, el: T), remove: fun(self: set<T>, el: T), stringify: fun(self: set<T>): string}

---@class (exact) transform
---@field x number
---@field y number
---@field rotation number
---@field scale_x number
---@field scale_y number

---@class (exact) component

---@class (exact) entity
---@field filename string
---@field name string
---@field tags set<string>
---@field transform transform
---@field alive boolean
---@field components component[]
---@field children entity[]
---@field parent entity
---@field id entity_id
