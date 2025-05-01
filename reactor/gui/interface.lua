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

function API.newButton(ID, text, textColor, buttonColor, x, y, width, height, func, params)
    local table = {}
    table["type"] = "button"
    table["text"] = text
    table["textColor"] = labelColor
    table["buttonColor"] = buttonColor
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["func"] = func
    table["params"] = params
    objects[ID] = table
end

function API.newLabel(ID, text, x, y, width, height, backgroundColor, textColor)
    local table = {}
    table["type"] = "label"
    table["text"] = text
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["backgroundColor"] = backgroundColor
    table["textColor"] = textColor
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
    objects = {}
end

function API.draw(ID)
    data = objects[ID]
    local objectType = data["type"]
    local x = data["x"]
    local y = data["y"]
    local width = data["width"]
    local height = data["height"]

    if objectType == "button" then
        local buttonColor = data["buttonColor"]
        local text = data["text"]
        local textColor = data["textColor"]

        gpu.setBackground(buttonColor, false)
        gpu.setForeground(textColor, false)
        gpu.fill(x, y, width, height, " ")
        gpu.set((x + width/2) - string.len(text)/2, y + height/2, text)

    elseif objectType == "label" then
        local text = data["text"]
        local textColor = data["textColor"]
        local backgroundColor = data["backgroundColor"]

        gpu.setBackground(backgroundColor, false)
        gpu.setForeground(textColor, false)
        gpu.fill(x, y, width, height, " ")
        gpu.set((x + width/2) - string.len(text)/2, y + height/2, text)

    elseif objectType == "bar" then
        gpu.setBackground(data["color2"], false)
        gpu.fill(x, y, width, height, " ")
        local amount = math.floor((width/100) * data["value"])
        gpu.setBackground(data["color1"], false)
        gpu.fill(x, y, amount, height, " ")
    end

    gpu.setBackground(colors.black, true)
    gpu.setForeground(colors.white, true)
end


function API.getButtonClicked(x, y)
    for ID, data in pairs(objects) do
        if data["type"] == "button" then
            local xmax = data["x"] + data["width"] - 1
            local ymax = data["y"] + data["height"] - 1

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
    for ID, data in pairs(objects) do
        API.draw(ID)
    end
end

function API.handleTouchEvent(x, y) 
    local ID = API.getButtonClicked(x, y)
    if not ID then return end
    local objectType = objects[ID]["type"]
    if not objectType == "button" then return end

    API.activateButton(ID)
end

function API.setBarValue(ID, value)
    local objectType = objects[ID]["type"]
    if not objectType == "bar" then return end

    objects[ID]["value"] = API.clamp(value, 0, 100)
    API.draw(ID)
end

function API.setLabelText(ID, text)
    local objectType = objects[ID]["type"]
    if not objectType == "label" or not objectType == "button" then return end
    if not text then text = " " end

    objects[ID]["text"] = text
    API.draw(ID)
end

return API
