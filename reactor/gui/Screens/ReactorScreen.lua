local ui = require "Screens/UI/UIElements"

local title = "Energy consumption"

local button1 = ui.Button()
local button2 = ui.Button()

local function init()
    button1.x = 2
    button1.y = 2
    button1.width = 5
    button1.height = 5
    button1.text = "B1"
    button1.action = function () print("click1") end

    button2.x = 20
    button2.y = 2
    button2.width = 5
    button2.height = 5
    button2.text = "B2"
    button2.action = function () print("click2") end
end

local function handleTouchEvent(eventData)
    -- TODO: handle clicking buttons
    -- eventData: name, address, x, y, button, player
    button1.handleClick(eventData)
    button2.handleClick(eventData)
end

local function show(reactorInfo)
    -- TODO: add GUI
    button1.draw()
    button2.draw()
end

return { init = init, handleTouchEvent = handleTouchEvent, show = show }
