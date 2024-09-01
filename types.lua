---@class (exact) ecs.set<T>: {[T]: true, add: fun(self: ecs.set<T>, el: T), remove: fun(self: ecs.set<T>, el: T), stringify: fun(self: ecs.set<T>): string}

---@class (exact) ecs.transform
---@field x number
---@field y number
---@field rotation number
---@field scale_x number
---@field scale_y number

---@class (exact) component_object
---@field values {[string]: any}

---@class (exact) ecs.component
---@field enabled boolean
---@field values {[string]: any}
---@field tags ecs.set<string>
---@field entity ecs.entity
---@field objects {[string]: component_object}
---@field id component_id
---@field remove fun(self: ecs.component)

---@class (exact) ecs.entity
---@field filename string
---@field name string
---@field tags ecs.set<string>
---@field transform ecs.transform
---@field alive boolean
---@field components ecs.component[]
---@field children ecs.entity[]
---@field parent ecs.entity
---@field id entity_id
