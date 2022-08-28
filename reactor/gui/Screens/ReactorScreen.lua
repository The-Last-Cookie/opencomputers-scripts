local drawAPI = require "Screens/UI/DrawAPI"
local buttonAPI = require "Screens/UI/Button"

local reactorAPI = require "ReactorAPI"

local Title = "Reactor Information and Control"

local btnReactorOn = buttonAPI.Button()
local btnReactorOff = buttonAPI.Button()
local btnReactorAuto = buttonAPI.Button()

local btnHysMinIncrease = buttonAPI.Button()
local btnHysMinDecrease = buttonAPI.Button()
local btnHysMaxIncrease = buttonAPI.Button()
local btnHysMaxDecrease = buttonAPI.Button()

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

    btnHysMinIncrease.x = 21
    btnHysMinIncrease.y = 29
    btnHysMinIncrease.width = 10
    btnHysMinIncrease.height = 3
    btnHysMinIncrease.backgroundColor = 0x0000FF
    btnHysMinIncrease.foregroundColor = 0xFFFFFF
    btnHysMinIncrease.text = "Min + 10"

    btnHysMinDecrease.x = 21
    btnHysMinDecrease.y = 33
    btnHysMinDecrease.width = 10
    btnHysMinDecrease.height = 3
    btnHysMinDecrease.backgroundColor = 0x0000FF
    btnHysMinDecrease.foregroundColor = 0xFFFFFF
    btnHysMinDecrease.text = "Min - 10"

    btnHysMaxIncrease.x = 32
    btnHysMaxIncrease.y = 29
    btnHysMaxIncrease.width = 10
    btnHysMaxIncrease.height = 3
    btnHysMaxIncrease.backgroundColor = 0x0000FF
    btnHysMaxIncrease.foregroundColor = 0xFFFFFF
    btnHysMaxIncrease.text = "Max + 10"

    btnHysMaxDecrease.x = 32
    btnHysMaxDecrease.y = 33
    btnHysMaxDecrease.width = 10
    btnHysMaxDecrease.height = 3
    btnHysMaxDecrease.backgroundColor = 0x0000FF
    btnHysMaxDecrease.foregroundColor = 0xFFFFFF
    btnHysMaxDecrease.text = "Max - 10"
end

local function handleTouchEvent(eventData)
    if buttonAPI.isClicked(btnReactorOn, eventData) then
        reactorAPI.forceActive()
    elseif buttonAPI.isClicked(btnReactorOff, eventData) then
        reactorAPI.forceInactive()
    elseif buttonAPI.isClicked(btnReactorAuto, eventData) then
        reactorAPI.disableForce()
    elseif buttonAPI.isClicked(btnHysMinIncrease, eventData) then
        reactorAPI.setHysteresisMin(reactorAPI.getHysteresisMin() + 0.1)
    elseif buttonAPI.isClicked(btnHysMinDecrease, eventData) then
        reactorAPI.setHysteresisMin(reactorAPI.getHysteresisMin() - 0.1)
    elseif buttonAPI.isClicked(btnHysMaxIncrease, eventData) then
        reactorAPI.setHysteresisMax(reactorAPI.getHysteresisMax() + 0.1)
    elseif buttonAPI.isClicked(btnHysMaxDecrease, eventData) then
        reactorAPI.setHysteresisMax(reactorAPI.getHysteresisMax() - 0.1)
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

    local strHys = "Hysterises values : " .. reactorAPI.getHysteresisMin() * 100 .. " % - " .. reactorAPI.getHysteresisMax() * 100 .. " %"
    drawAPI.Text(21, 27, strHys, 0x000000, 0xFFFFFF)

    -- TODO: show status via lamps
    drawAPI.Text(30, 7, "Reactor status: " .. reactorInfo.Status, 0x000000, 0xFFFFFF)

    buttonAPI.draw(btnReactorOn)
    buttonAPI.draw(btnReactorOff)
    buttonAPI.draw(btnReactorAuto)
    buttonAPI.draw(btnHysMinIncrease)
    buttonAPI.draw(btnHysMinDecrease)
    buttonAPI.draw(btnHysMaxIncrease)
    buttonAPI.draw(btnHysMaxDecrease)
end

return { Title = Title, init = init, handleTouchEvent = handleTouchEvent, show = show }
