---@class Builder_Lib
local Builder_Lib = {
    movementDirection = {
        height = "bottom",
        width = "right"
    }
}


---@class SCM
local scm = require("scm")

---@class turtleController
local turtleController = scm:load("turtleController")

turtleController.canBreakBlocks = true

local function selectItemToPlace(itemname)
    local item = turtle.getItemDetail()
    if item == nil or item.name ~= itemname then
        local slot = turtleController:findItemInInventory(itemname)
        if slot == nil then
            error("No more blocks available to build")
        end
        turtle.select(slot)
    end
end

local function placeDownItem(itemname)
    selectItemToPlace(itemname)
    if turtle.detectDown() then
        local _, down = turtle.inspectDown()
        print("Fond block to replace: ", down.name)
        turtleController:tryAction("digD")
    end
    local succ, txt = turtle.placeDown()
    if not succ then error(txt) end
end

local function returnToStartingPos()

end

---builds the floor with the given size
---@param length number
---@param width number
function Builder_Lib:floor(length, width)

    local t
    if self.movementDirection.width == "right" then
        t = function(modulo)
            if modulo == 1 then
                turtle.turnRight()
            else
                turtle.turnLeft()
            end
        end
    else
        t = function(modulo)
            if modulo == 1 then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end
        end
    end

    turtle.select(1)
    local block = turtle.getItemDetail()
    if block == nil then error("No block at item slot 1") end
    for j = 1, width, 1 do
        for i = 1, length - 1, 1 do
            placeDownItem(block.name)
            turtleController:goStraight(1)
        end
        placeDownItem(block.name)
        if (j < width) then
            t(j % 2)
            turtleController:goStraight(1)
            t(j % 2)
        end
    end
    returnToStartingPos()
end
return Builder_Lib