local component = require("component")
local gpu = component.gpu

local function Rectangle(x, y, w, h, color)
    local previousBackground = gpu.getBackground()
    gpu.setBackground(color)
    gpu.fill(x, y, w, h, " ")
    gpu.setBackground(previousBackground)
end

local function Text(x, y, text, backgroundColor, foregroundColor)
    local previousBackground = gpu.getBackground()
    local previousForeground = gpu.getForeground()
    gpu.setBackground(backgroundColor)
    gpu.setForeground(foregroundColor)
    gpu.set(x, y, text)
    gpu.setBackground(previousBackground)
    gpu.setForeground(previousForeground)
end

return { Rectangle = Rectangle, Text = Text }
