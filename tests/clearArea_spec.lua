---@class are
---@field same function
---@field equal function
---@field equals function

---@class is
---@field truthy function
---@field falsy function
---@field not_true function
---@field not_false function

---@class has
---@field error function
---@field errors function

---@class assert
---@field are are
---@field is is
---@field are_not are
---@field is_not is
---@field has has
---@field has_no has
---@field True function
---@field False function
---@field has_error function
---@field is_false function
---@field is_true function
---@field equal function
assert = assert

package.path = package.path .. ";"
    .."libs/?.lua;"
    .."libs/inventory/?.lua;"
    .."libs/peripherals/?.lua;"

---@type TurtleEmulator
local turtleEmulator = require("turtleEmulator")

---@type HelperFunctions
local helper = require("helperFunctions")

---@type Vector
_G.vector = require("vector")

_G.textutils = require("textutils")

---@type SettingsManager
_G.settings = require("settings")


---@type Builder_Lib
local builder

local function beforeeach()
    turtleEmulator:clearBlocks()
    turtleEmulator:clearTurtles()
    _G.turtle = turtleEmulator:createTurtle()
    local peripheral = turtle.getPeripheralModule()
    _G.peripheral = peripheral
    if builder == nil then
        builder = require("builder-lib")
    end
    builder.movementDirection.width = "right"
    builder.movementDirection.height = "up"

    ---@type Item
    local coal = {name = "minecraft:coal", count = 64, fuelgain = 8}
    turtle.addItemToInventory(coal, 1)
end

local function fillWorld()
    local existingBlock = {item = {count = 1, name = "minecraft:stone", placeAble = true}}
    local tmpBlock
    local n = 0
    for y = 0, 9, 1 do
        for x = 0, 9, 1 do
            for z = 0, 9, 1 do
                if x == 0 and y == 0 and z == 0 then
                    --skip
                else
                    n = n + 1
                    tmpBlock = helper.copyTable(existingBlock) --[[@as block]]
                    tmpBlock.position = vector.new(x, y, z)
                    turtleEmulator:createBlock(tmpBlock)
                end
            end
        end
    end
end

---counts the length of a table
---@param t table
---@return number
local function countTableLength(t)
    local length = 0
    for _, _ in pairs(t) do
        length = length + 1
    end
    return length
end



---@param p1 Vector
---@param p2 Vector
---@return table<string, number>
local function get_bounds(p1, p2)
  return {
    x_min = math.min(p1.x, p2.x),
    x_max = math.max(p1.x, p2.x),
    y_min = math.min(p1.y, p2.y),
    y_max = math.max(p1.y, p2.y),
    z_min = math.min(p1.z, p2.z),
    z_max = math.max(p1.z, p2.z),
  }
end

---@param pos1 Vector
---@param pos2 Vector
---@return number
---@return table<block>
local function checkEmptyFromTo(pos1, pos2)
    local tmpBlock
    local n = 0
    ---@type table<block>
    local blocks = {}
    local bounds = get_bounds(pos1, pos2)
    for x = bounds.x_min, bounds.x_max do
        for y = bounds.y_min, bounds.y_max do
            for z = bounds.z_min, bounds.z_max do
                tmpBlock = turtleEmulator:getBlock(vector.new(x,y,z)) --[[@as block|TurtleEmulator]]
                if tmpBlock ~= nil and not tmpBlock.item.name:find("turtle") then
                    n = n + 1
                    table.insert(blocks, tmpBlock)
                end
            end
        end
    end
    return n, blocks
end

describe("Testing ClearArea Function", function()
    ---@type block
    
    before_each(function ()
        beforeeach()
        fillWorld()
    end)

    it("testing the basic Test setup", function()
        -- pending("jup")
        local n, _ = checkEmptyFromTo(vector.new(0,0,0),vector.new(3,3,3))
        assert.are.equal(63, n)
        assert(998, countTableLength(turtleEmulator.blocks))
    end)

    it("Clear 4 x 4 x 4 | Moving: right up", function()
        -- pending("pending")
        builder.movementDirection.height = "up"
        builder.movementDirection.width = "right"

        
        builder:clearArea(4,4,4)

        local n = countTableLength(turtleEmulator.blocks)
        assert(998 - (4*4*4), n)
        local m, blocks = checkEmptyFromTo(vector.new(0,0,0),vector.new(3,3,3))
        assert.are.equal(0,m)
    end)

    it("Clear 4 x 4 x 4 | Moving: left up", function()
        -- pending("pending")
        builder.movementDirection.height = "up"
        builder.movementDirection.width = "left"
        
        ---position turtle at 0, 0, 3
        turtle.position = vector.new(-1, 0, 3)
        turtle.refuel()
        turtle.dig()
        assert.is_true(turtle.forward())

        builder:clearArea(4,4,4)

        local n = countTableLength(turtleEmulator.blocks)
        assert(998 - (4*4*4), n)
        local m, blocks = checkEmptyFromTo(vector.new(0,0,0),vector.new(3,3,3))
        assert.are.equal(0,m)
    end)

    it("Clear 5 x 5 x 5 | Moving: right down", function()
        -- pending("pending")
        builder.movementDirection.height = "down"
        builder.movementDirection.width = "right"
        
        ---position turtle at 0, 4, 0
        turtle.position = vector.new(-1, 4, 0)
        turtle.refuel()
        turtle.dig()
        assert.is_true(turtle.forward())

        builder:clearArea(5,5,5)

        local n = countTableLength(turtleEmulator.blocks)
        assert(998 - (5*5*5), n)
        local m, blocks = checkEmptyFromTo(vector.new(0,0,0),vector.new(4,4,4))
        assert.are.equal(0,m)
    end)

    it("Clear 5 x 5 x 5 | Moving: left down", function()
        -- pending("pending")
        builder.movementDirection.height = "down"
        builder.movementDirection.width = "left"
        
        ---position turtle at 0, 4, 0
        turtle.position = vector.new(-1, 4, 4)
        turtle.refuel()
        turtle.dig()
        assert.is_true(turtle.forward())

        builder:clearArea(5,5,5)

        local n = countTableLength(turtleEmulator.blocks)
        assert(998 - (5*5*5), n)
        local m, blocks = checkEmptyFromTo(vector.new(0,0,0),vector.new(4,4,4))
        assert.are.equal(0,m)
    end)

    it("Test ChestDumping", function()
        builder.movementDirection.height = "up"
        builder.movementDirection.width = "right"
        
        for i = 2, 14, 1 do
            turtle.addItemToInventory({name = "minecraft:dirt", count = 64, maxcount = 64, placeAble = true}, i)
        end
        local tmpChest = {name = "enderchests:ender_chest", count = 1, maxcount = 1, placeAble = true}
        turtle.addItemToInventory(tmpChest, 16)
        local enderCHest = turtleEmulator:addInventoryToItem(tmpChest)

        builder:clearArea(5,5,5)
        local n = countTableLength(turtleEmulator.blocks)
        assert(998 - (5*5*5), n)
        local m, blocks = checkEmptyFromTo(vector.new(0,0,0),vector.new(4,4,4))
        assert.are.equal(0,m)
        assert.are.same("minecraft:coal", turtle.getItemDetail(1).name)
        assert.are.same("minecraft:stone", turtle.getItemDetail(2).name) -- only does the last Line without clearing inventory
    end)

end)