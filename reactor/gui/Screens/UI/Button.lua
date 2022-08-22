local string = require("string")
local component = require("component")
local gpu = component.gpu

local drawAPI = require "Screens/UI/DrawAPI"

local ButtonStatus = {
    INACTIVE = 0,
    ACTIVE = 1
}

local x = 0
local y = 0
local width = 0
local height = 0

local inactiveBackgroundColor = 0x000000
local inactiveForegroundColor = 0xFFFFFF

local activeBackgroundColor = 0x222222
local activeForegroundColor = 0xFFFFFF

local text = ""

local holdOnClick = false

local state = ButtonStatus.INACTIVE

local action = nil

local function handleClick(self, eventData)
    if self.action == nil then
        return
    end

    if (eventData.x >= self.x and (eventData.x + self.width) <= self.x) and (eventData.y >= self.y and (eventData.y + self.height) <= self.y) then
        if self.state == ButtonStatus.INACTIVE then
            self.state = ButtonStatus.ACTIVE
            self.action()
        else
            self.state = ButtonStatus.INACTIVE
        end
    end
end

local function draw(self)
    if not self.holdOnClick and self.state == ButtonStatus.ACTIVE then
        self.state = ButtonStatus.INACTIVE
    end

    if self.state == ButtonStatus.INACTIVE then
        print(self.x .. " " .. self.y .. " " .. self.text)
        drawAPI.Rectangle(self.x, self.y, self.width, self.height, self.activeBackgroundColor, self.activeForegroundColor)
        gpu.set((self.x + (self.width/2)) - (string.len(self.text)/2), self.y + (self.height/2), self.text)
        return
    end

    drawAPI.Rectangle(self.x, self.y, self.width, self.height, self.inactiveBackgroundColor, self.inactiveForegroundColor)
    gpu.set((self.x + (self.width/2)) - (string.len(self.text)/2), self.y + (self.height/2), self.text)
end

local function Button()
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        inactiveBackgroundColor = inactiveBackgroundColor,
        inactiveForegroundColor = inactiveForegroundColor,
        activeBackgroundColor = activeBackgroundColor,
        activeForegroundColor = activeForegroundColor,
        text = text,
        holdOnClick = holdOnClick,
        action = action,
        handleClick = handleClick,
        draw = draw
    }
    return button
end

return { Button = Button }
