local screen1 = require "Screens/Screen1"

local screenPointer = 0

local screenCount = 1

local function init()
    reactorAPI.init()
end

local function handleTouchEvent(name, address, x, y, button, player)
    -- TODO: implement toolbar at the bottom of the screen
    --if screenAPI.buttonIsPressed() == 1 then
    --    switchScreen(-1)
    --elseif screenAPI.buttonIsPressed() == 2 then
    --    switchScreen(1)
    --end

    -- TODO: Move to ScreenManager
    if screenPointer == 0 then
        screen1.handleTouchEvent(name, address, x, y, button, player)
    end
end

--local function buttonIsPressed()
--end

local function switchScreen(direction)
    screenPointer = (screenPointer + direction) % screenCount
end

local function display()
    reactorAPI.monitorReactor()
    reactorInfo = reactorAPI.getReactorInfo()

    if screenPointer == 0 then
        screen1.show(reactorInfo)
    end
end

return { init = init, handleTouchEvent = handleTouchEvent, switchScreen = switchScreen, display = display }
