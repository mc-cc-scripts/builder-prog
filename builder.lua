--- UI for Builder

---@class Builder_Lib
local builder = require("builder-lib")


local function help()
    print("Usage:")
    print("builder <command> <options>")
    print("Commands: ")
    print("'floor'")
    print("'clearArea'")
    print("Options:")
    print("-mH[movementDir. Horizon] <'left'|'right'> [default: right]")
    print("-mV[movementDir. Vertical] <'down'|'up'> [default: up]")
    print("-w[width] <number>")
    print("-l[length] <number>")
    print("-h[height] <number>")
    print("-help")
end
if #arg == 0 then
    help()
    return
end


local stopExec = false

local size = {
    ["length"] = nil,
    ["width"] = nil,
    ["height"] = nil
}

local argsSwitch = {
    ["-mH"] = function(no)
        no[1] = no[1] + 1
        builder.movementDirection.width = arg[no[1]]
    end,
    ["-mV"] = function (no)
        no[1] = no[1] + 1
        builder.movementDirection.height = arg[no[1]]
    end,
    ["-l"] = function(no)
        no[1] = no[1] + 1
        size["length"] = tonumber(arg[no[1]]) or error("length not valid")
    end,
    ["-w"] = function(no)
        no[1] = no[1] + 1
        size["width"] = tonumber(arg[no[1]]) or error("width not valid")
    end,
    ["-h"] = function(no)
        no[1] = no[1] + 1
        if not tonumber(arg[no[1]]) then
            help()
            stopExec = true
            return
        end
        size["height"] = tonumber(arg[no[1]])
    end,
    ["-help"] = function()
        help()
        stopExec = true
    end,
    ["help"] = function()
        help()
        stopExec = true
    end
}
local commands = {
    ["floor"] = function()
        builder:floor(size["length"], size["width"])
    end,
    ["clearArea"] = function()
        builder:clearArea(size["length"], size["width"], size["height"])
    end
}


local function main()
    -- table to allow manipulation in argsSwitch
    local currentArgNo = {2}
    while currentArgNo[1] <= #arg do
        if argsSwitch[arg[currentArgNo[1]]] == nil then
            help()
            return
        end
        argsSwitch[arg[currentArgNo[1]]](currentArgNo)
        currentArgNo[1] = currentArgNo[1] + 1
    end
    if stopExec then return end

    if commands[arg[1]] == nil then
        help()
        return
    end
    commands[arg[1]]()
end

main()
