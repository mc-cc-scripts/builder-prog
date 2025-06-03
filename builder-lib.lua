---@class Builder_Lib
local Builder_Lib = {
    movementDirection = {
        height = "up",
        width = "right"
    }
}


---@class SCM
local scm = require("./scm")

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
        turtleController:tryAction("digD")
    end
    local succ, txt = turtle.placeDown()
    if not succ then error(txt) end
end

local function getTurningDirection(builderRef ,cHorizontal, cVertical)
    assert(type(builderRef) == "table", "needs self reference!")
    cHorizontal = cHorizontal or 1
    cVertical = cVertical or 1
    local hModulo = cHorizontal % 2
    local vModulo = cVertical % 2
    if builderRef.movementDirection.width == "left" then
        hModulo = 1 - hModulo -- toggle between 1 / 0
    end
    if builderRef.movementDirection.height == "down" and cVertical ~= 0 then
        vModulo = 1 - vModulo -- toggle between 1 / 0
    end
    -- TODO Simplify
    if (hModulo == 1 and vModulo == 1) or (hModulo == 0 and vModulo == 0) then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end

end

local function returnToStartingPos()

end

---builds the floor with the given size
---@param length number
---@param width number
function Builder_Lib:floor(length, width)
    length = length or 1
    width = width or 1
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
            getTurningDirection(self, j)
            turtleController:goStraight(1)
            getTurningDirection(self, j)
        end
    end
    returnToStartingPos()
end

function Builder_Lib:clearArea(length, width, height)
    local upDownDig = function(cHeight, maxHeight)
        if(cHeight < maxHeight) then
            turtleController:tryAction("digU")
        end
        if(cHeight > 1) then
            turtleController:tryAction("digD")
        end
    end
    local currentHeight = 1
    local k = 1
    while true do 
        for j = 1, width, 1 do
            for i = 1, length - 1, 1 do
                upDownDig(currentHeight, height)
                turtleController:goStraight(1)
            end
            upDownDig(currentHeight, height)
            if (j < width) then
                getTurningDirection(self, j, k)
                turtleController:goStraight(1)
                getTurningDirection(self, j, k)
            end
        end
        upDownDig(currentHeight, height)

        -- go up 3 blocks
        local u = height - currentHeight
        if u > 3 then 
            u = 3
        end
        if u == 0 then
            break
        end
        currentHeight = currentHeight + u
        k = k + 1
        turtleController:goUp(u)
        turtleController:tryMove("tA")
    end

    returnToStartingPos()
end
return Builder_Lib