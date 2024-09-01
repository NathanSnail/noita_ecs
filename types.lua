---@class (exact) ecs.tags: {[string]: true?}
---@field add fun(self: ecs.tags, el: string)
---@field remove fun(self: ecs.tags, el: string)
---@field stringify fun(self: ecs.tags): string

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
---@field tags ecs.tags
---@field entity ecs.entity
---@field objects {[string]: component_object}
---@field id component_id
---@field remove fun(self: ecs.component)

---@class (exact) ecs.entity
---@field filename string
---@field name string
---@field tags ecs.tags
---@field transform ecs.transform
---@field alive boolean
---@field components ecs.component[]
---@field children ecs.entity[]
---@field parent ecs.entity?
---@field id entity_id
