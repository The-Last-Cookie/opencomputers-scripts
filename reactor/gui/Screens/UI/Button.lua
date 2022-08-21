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

local function handleClick(eventData)
    if action == nil then
        return
    end

    if (eventData.x >= x and (eventData.x + width) <= x) and (eventData.y >= y and (eventData.y + height) <= y) then
        if state == ButtonStatus.INACTIVE then
            state = ButtonStatus.ACTIVE
            action()
        else
            state = ButtonStatus.INACTIVE
        end
    end
end

local function draw()
    if not holdOnClick and state == ButtonStatus.ACTIVE then
        state = ButtonStatus.INACTIVE
    end

    if state == ButtonStatus.INACTIVE then
        drawAPI.Rectangle(x, y, width, height, activeBackgroundColor, activeForegroundColor)
        gpu.set((x + (w/2)) - (string.len(text)/2), y + (h/2), text)
        return
    end

    drawAPI.Rectangle(x, y, width, height, inactiveBackgroundColor, inactiveForegroundColor)
    gpu.set((x + (width/2)) - (string.len(text)/2), y + (height/2), text)
end

return { x = x, y = y, width = width, height = height, buttonText = buttonText, holdOnClick = holdOnClick,
    inactiveBackgroundColor = inactiveBackgroundColor, inactiveForegroundColor = inactiveForegroundColor,
    activeBackgroundColor = activeBackgroundColor, activeForegroundColor = activeForegroundColor,
    disable = disable, handleClick = handleClick, action = action, draw = draw }
