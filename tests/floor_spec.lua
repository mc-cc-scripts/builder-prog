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

---@type Vector
_G.vector = require("vector")
---@type Builder_Lib
local builder

_G.textutils = require("textutils")


---@type TurtleEmulator
local turtleEmulator = require("turtleEmulator")

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

describe("Testing placing Floor", function ()
    local blockAmount = 64
    before_each(function ()
        beforeeach()
        ---@type Item
        local itemToAdd = {name = "minecraft:cobblestone", count = blockAmount, placeAble = true}
        local itemToAdd2 = {name = "minecraft:cobblestone", count = blockAmount, placeAble = true}
        turtle.addItemToInventory(itemToAdd, 1)
        turtle.addItemToInventory(itemToAdd2, 3)
        ---@type Item
        local coal = {name = "minecraft:coal", count = 64, fuelgain = 8}
        turtle.addItemToInventory(coal, 2)
    end)

    it("Place line", function()
        assert.are.equal(0, countTableLength(turtleEmulator.blocks))
        builder:floor(15, 1)
        assert.are.equal(15, countTableLength(turtleEmulator.blocks))
        local blocksTested = 0
        for i = 0, 14, 1 do
            blocksTested = blocksTested + 1
            assert.is.truthy(
                turtleEmulator:getBlock(vector.new(i, -1, 0))
            )
        end
        assert.are.equal(15, blocksTested)
    end)

    
    it("Create 9x9 floor", function()
        assert.are.equal(0, countTableLength(turtleEmulator.blocks))
        local succ, err = xpcall(function ()
            builder.movementDirection.width = "right"
            builder:floor(9, 9)
        end, debug.traceback)
        if err then error(err) end
        assert.are.equal(81, countTableLength(turtleEmulator.blocks))
        local blocksTested = 0
        for j = 0, 8, 1 do
            for i = 0, 8, 1 do
                blocksTested = blocksTested + 1
                assert.is.truthy(
                    turtleEmulator:getBlock(vector.new(i, -1, j))
                )
            end
        end
        assert.are.equal(81, blocksTested)
    end)

    it("Create 9x9 floor - to Left", function()
        assert.are.equal(0, countTableLength(turtleEmulator.blocks))
        local succ, err = xpcall(function ()
            builder.movementDirection.width = "left"
            builder:floor(9, 9)
        end, debug.traceback)
        if err then error(err) end
        assert.are.equal(81, countTableLength(turtleEmulator.blocks))
        local blocksTested = 0
        for j = -8, 0, 1 do
            for i = 0, 8, 1 do
                blocksTested = blocksTested + 1
                assert.is.truthy(
                    turtleEmulator:getBlock(vector.new(i, -1, j))
                )
            end
        end
        assert.are.equal(81, blocksTested)
    end)


    it("Create 10x10 floor", function()
        assert.are.equal(0, countTableLength(turtleEmulator.blocks))
        local succ, err = xpcall(function ()
            builder.movementDirection.width = "right"
            builder:floor(10, 10)
        end, debug.traceback)
        if err then error(err) end
        assert.are.equal(100, countTableLength(turtleEmulator.blocks))
        local blocksTested = 0
        for j = 0, 9, 1 do
            for i = 0, 9, 1 do
                blocksTested = blocksTested + 1
                assert.is.truthy(
                    turtleEmulator:getBlock(vector.new(i, -1, j))
                )
            end
        end
        assert.are.equal(100, blocksTested)
    end)

    it("Create 10x10 floor - to Left", function()
        assert.are.equal(0, countTableLength(turtleEmulator.blocks))
        local succ, err = xpcall(function ()
            builder.movementDirection.width = "left"
            builder:floor(10, 10)
        end, debug.traceback)
        if err then error(err) end
        assert.are.equal(100, countTableLength(turtleEmulator.blocks))
        local blocksTested = 0
        -- print("Blocks placed", textutils.serialize(turtleEmulator.blocks))
        for j = -9, 0, 1 do
            for i = 0, 9, 1 do
                blocksTested = blocksTested + 1
                assert.is.truthy(
                    turtleEmulator:getBlock(vector.new(i, -1, j))
                )
            end
        end
        assert.are.equal(100, blocksTested)
    end)


    it("Error on too few Blocks", function()
        local blocksToTest = blockAmount * 2 + 1
        assert.are.equal(0, countTableLength(turtleEmulator.blocks))
        local succ, err = xpcall(function ()
            builder:floor(blocksToTest, 1)
        end, debug.traceback)
        assert.is_false(succ)
        assert.are.equal(turtle.position.x + 1, blocksToTest)        
    end)
end)