---@class Builder_Lib
local Builder_Lib = {
    movementDirection = {
        height = "up",
        width = "right"
    }
}


---@type SCM
local scm = require("./scm")

---@type turtleController
local turtleController = scm:load("turtleController")

---@type TurtleResourceManager
local tResourceManager = scm:load("turtleResourceManager")

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

local function getTurningDirection(builderRef ,cHorizontal, cVertical, maxWidth)
    assert(type(builderRef) == "table", "needs self reference!")
    cHorizontal = cHorizontal or 1
    cVertical = cVertical or 1
    maxWidth = maxWidth or 2 -- default is even

    local hModulo = cHorizontal % 2
    local vModulo = cVertical % 2
    
    -- if odd, pretent to always be at base y-level and CONTINUE the left / right toggle
    -- making vModulo static
    if (maxWidth % 2 == 1) then
        vModulo = 1
    end

    if builderRef.movementDirection.width == "left" then
        hModulo = 1 - hModulo -- invert 1 <=> 0
    end

    if (hModulo == vModulo) then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end

end

local function returnToStartingPos()

end

---builds the floor with the given size
---@param length number | nil
---@param width number | nil
---@return boolean success
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
    return true
end

---clears an area with of specified size
---@param length number | nil
---@param width number | nil
---@param height number | nil
---@return boolean success
function Builder_Lib:clearArea(length, width, height)
    local upDownDig = function(cHeight, maxHeight)
        if Builder_Lib.movementDirection.height == "up" then
            if(cHeight < maxHeight) then
                turtleController:tryAction("digU")
            end
            if(cHeight > 1) then
                turtleController:tryAction("digD")
            end
        else
            if(cHeight < maxHeight) then
                turtleController:tryAction("digD")
            end
            if(cHeight > 1) then
                turtleController:tryAction("digU")
            end
        end
    end    
    
    local filterFunc = function(item)
        return string.find(item.name, "coal") == nil
    end
    
    length = length or 1
    width = width or 1
    height = height or 1


    local currentHeight = 1
    local k = 1
    local manageSpace = tResourceManager:checkSetup()
    while true do 
        for j = 1, width, 1 do
            for i = 1, length - 1, 1 do
                upDownDig(currentHeight, height)
                turtleController:goStraight(1)
            end
            if manageSpace and tResourceManager:getFreeSlots() < 5 then
                if tResourceManager:manageSpace(12, filterFunc) == 3 then
                    error("Errorhandling not finished, cound not pickup Chest!")
                end
            end
            upDownDig(currentHeight, height)
            if (j < width) then
                getTurningDirection(self, j, k, width)
                turtleController:goStraight(1)
                getTurningDirection(self, j, k, width)
            else
            end
        end
        upDownDig(currentHeight, height)

        -- go up 3 blocks
        local diff = height - currentHeight
        if diff > 3 then 
            diff = 3
        end
        if diff <= 1 then
            break
        end
        if self.movementDirection.height == "up" then
            turtleController:goUp(diff)
        else
            turtleController:goDown(diff)
        end
        currentHeight = currentHeight + diff
        
        k = k + 1
        turtleController:tryMove("tA")
    end

    returnToStartingPos()
    return true
end
return Builder_Lib