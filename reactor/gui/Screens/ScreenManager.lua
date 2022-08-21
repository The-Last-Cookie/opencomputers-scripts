local reactorScreen = require "Screens/ReactorScreen"

local screens = {
    reactorScreen
}

local ScreenCount = #screens

local function handleTouchEvent(screenPointer, eventData)
    if screenPointer <= 0 or screenPointer > ScreenCount then
        return
    end

    screens[screenPointer].handleTouchEvent(eventData)
end

local function showScreen(screenPointer, screenData)
    if screenPointer == 0 or screenPointer >= ScreenCount then
        return
    end

    screens[screenPointer].show(screenData)
end

return { ScreenCount = ScreenCount, handleTouchEvent = handleTouchEvent, showScreen = showScreen }
