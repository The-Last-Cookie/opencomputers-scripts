local drawAPI = require "Screens/UI/DrawAPI"

local x = 0
local y = 0
local width = 0
local height = 0

local backgroundColor = 0x5A5A5A
local lightColor = 0xFFFFFF

local function draw(self)
    drawAPI.Rectangle(self.x, self.y, self.width, self.height, self.backgroundColor)
    drawAPI.Rectangle(self.x + 1, self.y + 1, self.width - 1, self.height - 1, self.lightColor)
end

local function Lamp()
    local lamp = {
        x = x,
        y = y,
        width = width,
        height = height,
        backgroundColor = backgroundColor,
        lightColor = lightColor
    }
    return lamp
end

return { Lamp = Lamp, draw = draw }
