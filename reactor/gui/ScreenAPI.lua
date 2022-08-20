local screen1 = require "Screens/Screen1"

local screenPointer = 0

local screenCount = 1

local function init()
    reactorAPI.init()
end

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
