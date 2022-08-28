local drawAPI = require "Screens/UI/DrawAPI"
local buttonAPI = require "Screens/UI/Button"

local reactorAPI = require "ReactorAPI"

local Title = "Reactor Information and Control"

local btnReactorOn = buttonAPI.Button()
local btnReactorOff = buttonAPI.Button()
local btnReactorAuto = buttonAPI.Button()

--[[ TODO: add hys value management to ReactorAPI
local btnHysMinIncrease = buttonAPI.Button()
local btnHysMinDecrease = buttonAPI.Button()
local btnHysMaxIncrease = buttonAPI.Button()
local btnHysMaxDecrease = buttonAPI.Button()
]]--

local function init()
    btnReactorOn.x = 4
    btnReactorOn.y = 27
    btnReactorOn.width = 10
    btnReactorOn.height = 3
    btnReactorOn.backgroundColor = 0x00FF00
    btnReactorOn.foregroundColor = 0xFFFFFF
    btnReactorOn.text = "On"

    btnReactorOff.x = 4
    btnReactorOff.y = 31
    btnReactorOff.width = 10
    btnReactorOff.height = 3
    btnReactorOff.backgroundColor = 0xFF0000
    btnReactorOff.foregroundColor = 0xFFFFFF
    btnReactorOff.text = "Off"

    btnReactorAuto.x = 4
    btnReactorAuto.y = 35
    btnReactorAuto.width = 10
    btnReactorAuto.height = 3
    btnReactorAuto.backgroundColor = 0x0000FF
    btnReactorAuto.foregroundColor = 0xFFFFFF
    btnReactorAuto.text = "Auto"
end

local function handleTouchEvent(eventData)
    if buttonAPI.isClicked(btnReactorOn, eventData) then
        reactorAPI.forceActive()
    elseif buttonAPI.isClicked(btnReactorOff, eventData) then
        reactorAPI.forceInactive()
    elseif buttonAPI.isClicked(btnReactorAuto, eventData) then
        reactorAPI.disableForce()
    end
end

local function show(reactorInfo)
    drawAPI.Text(4, 9, "Current energy: " .. reactorInfo.Energy .. " RF", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 11, "Maximum energy: " .. reactorInfo.MaxEnergy .. " RF", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 13, "Energy production: " .. reactorInfo.EnergyDelta .. " RF/s", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 15, "Casing temperature: " .. reactorInfo.CasingTemperature .. " °C", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 17, "Fuel amount: " .. reactorInfo.FuelAmount .. " mB", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 19, "Fuel temperature: " .. reactorInfo.FuelTemperature .. " °C", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 21, "Waste amount: " .. reactorInfo.WasteAmount .. " mB", 0x000000, 0xFFFFFF)

    -- TODO: show status via lamps
    drawAPI.Text(30, 7, "Reactor status: " .. reactorInfo.Status, 0x000000, 0xFFFFFF)

    buttonAPI.draw(btnReactorOn)
    buttonAPI.draw(btnReactorOff)
    buttonAPI.draw(btnReactorAuto)
end

return { Title = Title, init = init, handleTouchEvent = handleTouchEvent, show = show }
