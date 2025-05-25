--- UI for Builder

---@class SCM
local scm = require("scm")

---@class Builder_Lib
local builder = require("/libs/builder-prog/builder-lib")


local function help()
    print("Usage:")
    print("builder <command> <options>")
    print("")
    print("Commands: ")
    print("- 'floor'")
    print("")
    print("Options:")
    print("-m[movementDirection] <'left'|'right'> [default: right]")
    print("-w[width] <number>")
    print("-l[length] <number>")
    print("-h[help]")
end
if #arg == 0 then
    help()
    return
end


local stopExec = false

local size = {
    ["length"] = 0,
    ["width"] = 0,
    ["height"] = 0
}

local argsSwitch = {
    ["-m"] = function(no)
        no[1] = no[1] + 1
        builder.movementDirection.width = arg[no[1]]
    end,
    ["-l"] = function(no)
        no[1] = no[1] + 1
        size["length"] = tonumber(arg[no[1]]) or error("length not valid")
    end,
    ["-w"] = function(no)
        no[1] = no[1] + 1
        size["width"] = tonumber(arg[no[1]]) or error("width not valid")
    end,
    ["-h"] = function()
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
