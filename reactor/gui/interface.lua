-- Original by TankNut: https://github.com/OpenPrograms/MiscPrograms/blob/master/TankNut/interface.lua

local component = require("component")

local objects = {}
local API = {}

local gpu = component.gpu
local maxWidth, maxHeight = gpu.getResolution()

function API.clearScreen()
    gpu.setForeground(0xFFFFFF, false)
    gpu.setBackground(0x000000, false)
    gpu.fill(1, 1, maxWidth, maxHeight, " ")
end

function API.clamp(n, min, max) return math.min(math.max(n, min), max) end

function API.newButton(ID, text, textColor, buttonColor, x, y, width, height, func, params)
    local table = {}
    table["type"] = "button"
    table["text"] = text
    table["textColor"] = textColor
    table["buttonColor"] = buttonColor
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["func"] = func
    table["params"] = params
    objects[ID] = table
end

function API.newLabel(ID, text, x, y, textColor)
    local table = {}
    table["type"] = "label"
    table["text"] = text
    table["x"] = x
    table["y"] = y
    table["textColor"] = textColor
    objects[ID] = table
end

function API.newBorderBox(ID, x, y, width, height, borderColor, innerColor, text, textColor)
    local table = {}
    table["type"] = "borderBox"
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["borderColor"] = borderColor
    table["innerColor"] = innerColor -- background color for text label
    table["text"] = text
    table["textColor"] = textColor
    objects[ID] = table
end

function API.newLine(ID, x, y, length, direction, color)
    local table = {}
    table["type"] = "line"
    table["x"] = x
    table["y"] = y
    table["length"] = length
    table["direction"] = direction
    table["color"] = color
    objects[ID] = table
end

function API.newLamp(ID, x, y, width, height, backgroundColor, lightColor)
    local table = {}
    table["type"] = "lamp"
    table["x"] = x
    table["y"] = y
    table["width"] = width
    table["height"] = height
    table["backgroundColor"] = backgroundColor
    table["lightColor"] = lightColor
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

    if objectType == "button" then
        local width = data["width"]
        local height = data["height"]
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

        gpu.setForeground(textColor, false)
        gpu.fill(x, y, string.len(text), 1, " ")
        gpu.set(x, y, text)
    
    elseif objectType == "borderBox" then
        local width = data["width"]
        local height = data["height"]
        local borderColor = data["borderColor"]
        local innerColor = data["innerColor"]
        local text = data["text"]
        local textColor = data["textColor"]

        -- Rectangle
        -- 4 draw calls (each box side), so elements in the box don't get overdrawn (draw order is random)
        gpu.setBackground(borderColor, false)
        gpu.fill(x, y, width, 1, " ")
        gpu.fill(x, y, 1, height, " ")
        gpu.fill(x, y + height, width + 1, 1, " ")
        gpu.fill(x + width, y, 1, height + 1, " ")

        -- Label
        gpu.setBackground(innerColor, false)
        gpu.setForeground(textColor, false)
        gpu.set(x + 2, y, " " .. text .. " ")

    elseif objectType == "line" then
        local color = data["color"]
        local length = data["length"]
        local direction = data["direction"]

        gpu.setBackground(color, false)

        if direction == "vertical" then
            gpu.fill(x, y, 1, length, " ")
        else
            gpu.fill(x, y, length, 1, " ")
        end

    elseif objectType == "lamp" then
        local width = data["width"]
        local height = data["height"]
        local lightColor = data["lightColor"]
        local backgroundColor = data["backgroundColor"]

        gpu.setBackground(backgroundColor, false)
        gpu.fill(x, y, width, height, " ")
        gpu.setBackground(lightColor, false)
        gpu.fill(x + 1, y + 1, width - 2, height - 2, " ")
    end

    gpu.setForeground(0xFFFFFF, false)
    gpu.setBackground(0x000000, false)
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

function API.setLabelText(ID, text)
    local objectType = objects[ID]["type"]
    if not objectType == "label" and not objectType == "button" then return end
    if not text then text = " " end

    objects[ID]["text"] = text
    API.draw(ID)
end

function API.setLampColor(ID, lightColor)
    local objectType = objects[ID]["type"]
    if not objectType == "lamp" then return end

    objects[ID]["lightColor"] = lightColor
    API.draw(ID)
end

return API
