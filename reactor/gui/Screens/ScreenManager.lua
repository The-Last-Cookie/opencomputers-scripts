local drawAPI = require "Screens/UI/DrawAPI"

-- import screens
local reactorScreen = require "Screens/ReactorScreen"

local screens = {
    reactorScreen
}

local ScreenCount = #screens

local function init()
    for i = 1, ScreenCount, -1 do
        screens[i].init()
    end
end

local function drawScreenTitle(screenPointer)
    drawAPI.Text(20, 3, screens[screenPointer].Title, 0x696969, 0xFFFFFF)
end

local function handleTouchEvent(screenPointer, eventData)
    if screenPointer <= 0 or screenPointer > ScreenCount then
        return
    end

    screens[screenPointer].handleTouchEvent(eventData)
end

local function showScreen(screenPointer)
    if screenPointer <= 0 or screenPointer > ScreenCount then
        return
    end

    screens[screenPointer].show()
end

return { init = init, drawScreenTitle = drawScreenTitle, ScreenCount = ScreenCount, handleTouchEvent = handleTouchEvent, showScreen = showScreen }
