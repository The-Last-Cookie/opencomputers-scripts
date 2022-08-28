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

local function HorizontalLine(x, y, w, color)
    local previousBackground = gpu.getBackground()
    gpu.setBackground(color)
    gpu.fill(x, y, w, 1, " ")
    gpu.setBackground(previousBackground)
end

local function VerticalLine(x, y, h, color)
    local previousBackground = gpu.getBackground()
    gpu.setBackground(color)
    gpu.fill(x, y, 1, h, " ")
    gpu.setBackground(previousBackground)
end

local function BorderBox(x, y, w, h, text, borderColor)
    HorizontalLine(x, y, w, borderColor)
    HorizontalLine(x, y + h, w, borderColor)
    VerticalLine(x, y, h, borderColor)
    VerticalLine(x + w, y, h, borderColor)

    Text(x + 2, y, " " .. text .. " ", 0x000000, 0xFFFFFF)
end

return { Rectangle = Rectangle, Text = Text, HorizontalLine = HorizontalLine, VerticalLine = VerticalLine, BorderBox = BorderBox }
