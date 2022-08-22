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
    --if screenAPI.buttonIsPressed() == 1 then
    --    switchScreen(-1)
    --elseif screenAPI.buttonIsPressed() == 2 then
    --    switchScreen(1)
    --end

    screenManager.handleTouchEvent(screenPointer, eventData)
end

--local function buttonIsPressed()
--end

local function switchScreen(direction)
    screenPointer = (screenPointer + direction) % screenManager.ScreenCount
end

local function display()
    reactorAPI.monitorReactor()
    reactorInfo = reactorAPI.getReactorInfo()

    screenManager.showScreen(screenPointer, reactorInfo)
end

return { init = init, handleTouchEvent = handleTouchEvent, switchScreen = switchScreen, display = display }
