local string = require("string")
local component = require("component")
local gpu = component.gpu

local drawAPI = require "Screens/UI/DrawAPI"

local x = 0
local y = 0
local width = 0
local height = 0

local backgroundColor = 0xFF0000
local foregroundColor = 0x000000

local text = ""

local function isClicked(self, eventData)
    if (eventData.x >= self.x and (self.x + self.width) >= eventData.x)
        and (eventData.y >= self.y and (self.y + self.height) >= eventData.y) then
        return true
    end

    return false
end

local function draw(self)
    drawAPI.Rectangle(self.x, self.y, self.width, self.height, self.backgroundColor)
    drawAPI.Text((self.x + (self.width/2)) - (string.len(self.text)/2), self.y + (self.height/2),
        self.text, self.backgroundColor, self.foregroundColor)
end

local function Button()
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        backgroundColor = backgroundColor,
        foregroundColor = foregroundColor,
        text = text
    }
    return button
end

return { Button = Button, draw = draw, isClicked = isClicked }
