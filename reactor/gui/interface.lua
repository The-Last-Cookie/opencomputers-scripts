-- Original by TankNut: https://github.com/OpenPrograms/MiscPrograms/blob/master/TankNut/interface.lua

local component = require("component")
local colors = require("colors")

local objects = {}
local API = {}

local gpu = component.gpu
local maxWidth, maxHeight = gpu.getResolution()

function API.clearScreen()
    gpu.setForeground(colors.white, true)
    gpu.setBackground(colors.black, true)
    gpu.fill(1, 1, maxWidth, maxHeight, " ")
end

function API.clamp(n, min, max) return math.min(math.max(n, min), max) end

function API.newButton(ID, label, x, y, width, height, func, params, oncolor, offcolor, toggle)
    local table = {}
    table["type"] = "button"
    table["label"] = label
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["active"] = false
    table["func"] = func -- is action as a name better?
    table["params"] = params
    table["oncolor"] = oncolor
    table["offcolor"] = offcolor
    table["toggle"] = toggle
    objects[ID] = table
end

function API.newLabel(ID, label, x, y, width, height, color)
    local table = {}
    table["type"] = "label"
    table["label"] = label
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["color"] = color
    objects[ID] = table
end
    
function API.newBar(ID, x, y, width, height, color1, color2, value)
    local table = {}
    table["type"] = "bar"
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["color1"] = color1 --Left color
    table["color2"] = color2 --Right color
    table["value"] = value
    objects[ID] = table
end

function API.removeObject(ID)
    objects[ID] = {}
end

function API.clearAllObjects()
    API.clearScreen()
    objects = {}
end

function API.draw(ID)
    data = objects[ID]
    local objectType = data["type"]
    local label = data["label"] -- move to local context because it's not in every ui element
    local x = data["x"]
    local y = data["y"]
    local width = data["width"]
    local height = data["height"]

    if objectType == "button" then
        local drawColor = 0x000000
        if data["active"] == true then
            drawColor = data["oncolor"]
        else
            drawColor = data["offcolor"]
        end
        gpu.setBackground(drawColor, false)
        gpu.fill(x, y, width, height, " ")
        gpu.set((x+width/2)-string.len(label)/2, y+height/2, label)
        gpu.setBackground(colors.black, true)

    elseif objectType == "label" then
        gpu.setBackground(data["color"], false)
        gpu.fill(x, y, width, height, " ")
        gpu.set((x+width/2)-string.len(label)/2, y+height/2, label)
        gpu.setBackground(colors.black, true)

    elseif objectType == "bar" then
        gpu.setBackground(data["color2"], false)
        gpu.fill(x, y, width, height, " ")
        local amount = math.floor((width/100)*data["value"])
        gpu.setBackground(data["color1"], false)
        gpu.fill(x, y, amount, height, " ")
        gpu.setBackground(colors.black, true)
    end
end

function API.toggleButton(ID)
    local objectType = objects[ID]["type"]
    if not objectType == "button" then return end
    objects[ID]["active"] = not objects[ID]["active"]
    API.draw(ID)
end

-- useable for my case?
function API.flashButton(ID)
    local objectType = objects[ID]["type"]
    if not objectType == "button" then return end
    API.toggleButton(ID)
    os.sleep(0.15)
    API.toggleButton(ID)
end

function API.getButtonState(ID)
    local objectType = objects[ID]["type"]
    if not objectType == "button" then return end
    return objects[ID]["active"]
end

function API.getButtonClicked(x, y)
    for ID, data in pairs(objects) do
		-- check with my own algorithm
        local xmax = data["x"]+data["width"]-1
        local ymax = data["y"]+data["height"]-1
        if data["type"] == "button" then
            if x >= data["x"] and x <= xmax then
                if y >= data["y"] and y <= ymax then
                    return ID
                end
            end
        end
    end
    return nil
end

function API.activateButton(ID)
    local objectType = objects[ID]["type"]
    if not objectType == "button" then return end
    local parameters = objects[ID]["params"]
    objects[ID]["func"](parameters)
end

function API.updateAll()
    API.clearScreen()
    for ID, data in pairs(objects) do
        API.draw(ID)
    end
end

function API.handleTouchEvent(x, y) 
    local ID = API.getButtonClicked(x, y)
    if not ID then return end
    local objectType = objects[ID]["type"]
    if not objectType == "button" then return end

    if objects[ID]["toggle"] == true then
        API.toggleButton(ID)
        API.activateButton(ID)
    else
        --API.flashButton(ID)
        API.activateButton(ID)
    end
end

function API.setBarValue(ID, value)
    local objectType = objects[ID]["type"]
    if not objectType == "bar" then return end
    objects[ID]["value"] = API.clamp(value, 0, 100)
    API.draw(ID)
end

function API.setLabelText(ID, label)
    local objectType = objects[ID]["type"]
    if not objectType == "label" or not objectType == "button" then return end
    if not label then label = " " end
    objects[ID]["label"] = label
    API.draw(ID)
end

return API
