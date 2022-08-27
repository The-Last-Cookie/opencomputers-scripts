local screenManager = require "Screens/ScreenManager"
local reactorAPI = require "ReactorAPI"

-- arrays begin with 1
local screenPointer = 1

local function init()
    reactorAPI.init()
    screenManager.init()
end

local function handleTouchEvent(name, address, x, y, button, player)
    -- TODO: check if player needs to be registered in pc for touch events
    eventData = { name = name, address = address, x = x, y = y, button = button, player = player }

    -- TODO: implement toolbar at the bottom of the screen

    screenManager.handleTouchEvent(screenPointer, eventData)
end

local function switchScreen(direction)
    -- convert screenPointer to be an element of {0, ..., screenCount - 1}
    screenPointer = screenPointer - 1
    screenPointer = (screenPointer + direction) % screenManager.ScreenCount

    -- convert screenPointer back, since arrays begin at 1
    screenPointer = screenPointer + 1
end

local function display()
    reactorAPI.monitorReactor()
    reactorInfo = reactorAPI.getReactorInfo()

    screenManager.showScreen(screenPointer, reactorInfo)
end

return { init = init, handleTouchEvent = handleTouchEvent, switchScreen = switchScreen, display = display }
