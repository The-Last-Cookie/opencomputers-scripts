local component = require("component")
local gpu = component.gpu

local function Rectangle(x, y, w, h, color)
    local previousBackground = gpu.getBackground()
    gpu.setBackground(color)
    gpu.fill(x, y, w, h, " ")
    gpu.setBackground(previousBackground)
end

local function Text(x, y, text, color)
    local previousForeground = gpu.getForeground()
    gpu.setForeground(color)
    gpu.set(x, y, text)
    gpu.setForeground(previousForeground)
end

return { Rectangle = Rectangle, Text = Text }
