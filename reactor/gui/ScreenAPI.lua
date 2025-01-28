local program = require "Program"
local screenManager = require "Screens/ScreenManager"
local buttonAPI = require "Screens/UI/Button"
local drawAPI = require "Screens/UI/DrawAPI"

-- arrays begin with 1
local screenPointer = 1

local btnSwitchLeft = buttonAPI.Button()
local btnSwitchRight = buttonAPI.Button()
local btnExit = buttonAPI.Button()

local function init()
    reactor.init()
    screenManager.init()

    btnSwitchLeft.x = 2
    btnSwitchLeft.y = 2
    btnSwitchLeft.width = 5
    btnSwitchLeft.height = 3
    btnSwitchLeft.backgroundColor = 0x3C3C3C
    btnSwitchLeft.foregroundColor = 0xFFFFFF
    btnSwitchLeft.text = "<"

    btnSwitchRight.x = 9
    btnSwitchRight.y = 2
    btnSwitchRight.width = 5
    btnSwitchRight.height = 3
    btnSwitchRight.backgroundColor = 0x3C3C3C
    btnSwitchRight.foregroundColor = 0xFFFFFF
    btnSwitchRight.text = ">"

    btnExit.x = 151
    btnExit.y = 2
    btnExit.width = 8
    btnExit.height = 3
    btnExit.backgroundColor = 0x3C3C3C
    btnExit.foregroundColor = 0xFFFFFF
    btnExit.text = "Exit"
end

local function drawToolbar()
    drawAPI.Rectangle(1, 1, 160, 5, 0x696969)
    buttonAPI.draw(btnExit)
    screenManager.drawScreenTitle(screenPointer)

    if screenManager.ScreenCount > 1 then
        buttonAPI.draw(btnSwitchLeft)
        buttonAPI.draw(btnSwitchRight)
    end
end

local function switchScreen(direction)
    -- convert screenPointer to be an element of {0, ..., screenCount - 1}
    screenPointer = screenPointer - 1
    screenPointer = (screenPointer + direction) % screenManager.ScreenCount

    -- convert screenPointer back, since arrays begin at 1
    screenPointer = screenPointer + 1
end

local function handleTouchEvent(name, address, x, y, button, player)
    -- TODO: check if player needs to be registered in pc for touch events
    eventData = { name = name, address = address, x = x, y = y, button = button, player = player }

    if buttonAPI.isClicked(btnSwitchLeft, eventData) then
        switchScreen(-1)
        return
    elseif buttonAPI.isClicked(btnSwitchRight, eventData) then
        switchScreen(1)
        return
    elseif buttonAPI.isClicked(btnExit, eventData) then
        program.IsRunning = false
        return
    end

    screenManager.handleTouchEvent(screenPointer, eventData)
end

local function display()
    drawToolbar()
    screenManager.showScreen(screenPointer)
end

return { init = init, handleTouchEvent = handleTouchEvent, display = display }
