local component = require("component")
local gpu = component.gpu

local function Rectangle(x, y, w, h, backgroundColor, foregroundColor)
    local previousBackground = gpu.getBackground()
    local previousForeground = gpu.getForeground()

    gpu.setBackground(backgroundColor)
    gpu.setForeground(foregroundColor)
    gpu.fill(x, y, w, h, " ")

    gpu.setBackground(previousBackground)
    gpu.setForeground(previousForeground)
end

return { Rectangle = Rectangle }
