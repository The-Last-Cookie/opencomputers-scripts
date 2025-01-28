local drawAPI = require "Screens/UI/DrawAPI"
local buttonAPI = require "Screens/UI/Button"
local lampAPI = require "Screens/UI/Lamp"

local reactor = require "Reactor"

local Title = "Reactor Information and Control"

local btnReactorOn = buttonAPI.Button()
local btnReactorOff = buttonAPI.Button()
local btnReactorAuto = buttonAPI.Button()

local btnHysMinIncrease = buttonAPI.Button()
local btnHysMinDecrease = buttonAPI.Button()
local btnHysMaxIncrease = buttonAPI.Button()
local btnHysMaxDecrease = buttonAPI.Button()

local lpOn = lampAPI.Lamp()
local lpOff = lampAPI.Lamp()
local lpAuto = lampAPI.Lamp()

local function init()
    btnReactorOn.x = 4
    btnReactorOn.y = 29
    btnReactorOn.width = 10
    btnReactorOn.height = 3
    btnReactorOn.backgroundColor = 0x00FF00
    btnReactorOn.foregroundColor = 0xFFFFFF
    btnReactorOn.text = "On"

    btnReactorOff.x = 4
    btnReactorOff.y = 33
    btnReactorOff.width = 10
    btnReactorOff.height = 3
    btnReactorOff.backgroundColor = 0xFF0000
    btnReactorOff.foregroundColor = 0xFFFFFF
    btnReactorOff.text = "Off"

    btnReactorAuto.x = 4
    btnReactorAuto.y = 37
    btnReactorAuto.width = 10
    btnReactorAuto.height = 3
    btnReactorAuto.backgroundColor = 0x0000FF
    btnReactorAuto.foregroundColor = 0xFFFFFF
    btnReactorAuto.text = "Auto"

    btnHysMinIncrease.x = 21
    btnHysMinIncrease.y = 31
    btnHysMinIncrease.width = 10
    btnHysMinIncrease.height = 3
    btnHysMinIncrease.backgroundColor = 0x0000FF
    btnHysMinIncrease.foregroundColor = 0xFFFFFF
    btnHysMinIncrease.text = "Min + 10"

    btnHysMinDecrease.x = 21
    btnHysMinDecrease.y = 35
    btnHysMinDecrease.width = 10
    btnHysMinDecrease.height = 3
    btnHysMinDecrease.backgroundColor = 0x0000FF
    btnHysMinDecrease.foregroundColor = 0xFFFFFF
    btnHysMinDecrease.text = "Min - 10"

    btnHysMaxIncrease.x = 32
    btnHysMaxIncrease.y = 31
    btnHysMaxIncrease.width = 10
    btnHysMaxIncrease.height = 3
    btnHysMaxIncrease.backgroundColor = 0x0000FF
    btnHysMaxIncrease.foregroundColor = 0xFFFFFF
    btnHysMaxIncrease.text = "Max + 10"

    btnHysMaxDecrease.x = 32
    btnHysMaxDecrease.y = 35
    btnHysMaxDecrease.width = 10
    btnHysMaxDecrease.height = 3
    btnHysMaxDecrease.backgroundColor = 0x0000FF
    btnHysMaxDecrease.foregroundColor = 0xFFFFFF
    btnHysMaxDecrease.text = "Max - 10"

    lpOn.x = 15
    lpOn.y = 29
    lpOn.width = 3
    lpOn.height = 3
    lpOn.lightColor = 0xFF0000

    lpOff.x = 15
    lpOff.y = 33
    lpOff.width = 3
    lpOff.height = 3
    lpOff.lightColor = 0xFF0000

    lpAuto.x = 15
    lpAuto.y = 37
    lpAuto.width = 3
    lpAuto.height = 3
    lpAuto.lightColor = 0xFF0000
end

local function handleTouchEvent(eventData)
    if buttonAPI.isClicked(btnReactorOn, eventData) then
        reactor.forceActive()
        lpOn.lightColor = 0x00FF00
        lpOff.lightColor = 0xFF0000
        lpAuto.lightColor = 0xFF0000
    elseif buttonAPI.isClicked(btnReactorOff, eventData) then
        reactor.forceInactive()
        lpOff.lightColor = 0x00FF00
        lpOn.lightColor = 0xFF0000
        lpAuto.lightColor = 0xFF0000
    elseif buttonAPI.isClicked(btnReactorAuto, eventData) then
        reactor.disableForce()
        lpAuto.lightColor = 0x00FF00
        lpOn.lightColor = 0xFF0000
        lpOff.lightColor = 0xFF0000
    elseif buttonAPI.isClicked(btnHysMinIncrease, eventData) then
        reactor.setHysteresisMin(reactor.getHysteresisMin() + 0.1)
    elseif buttonAPI.isClicked(btnHysMinDecrease, eventData) then
        reactor.setHysteresisMin(reactor.getHysteresisMin() - 0.1)
    elseif buttonAPI.isClicked(btnHysMaxIncrease, eventData) then
        reactor.setHysteresisMax(reactor.getHysteresisMax() + 0.1)
    elseif buttonAPI.isClicked(btnHysMaxDecrease, eventData) then
        reactor.setHysteresisMax(reactor.getHysteresisMax() - 0.1)
    end
end

local function show()
    reactor.monitor() -- move to update function or in main loop (after framework rewriting)
    reactorInfo = reactor.getStatistics()

    drawAPI.BorderBox(2, 7, 44, 18, "Information", 0x5A5A5A)

    if reactorInfo.Status == reactor.ReactorStatus.NOT_CONNECTED then
        drawAPI.Text(4, 9, "Reactor status: Not connected", 0x000000, 0xFFFFFF)
    elseif reactorInfo.Status == reactor.ReactorStatus.FORCE_ACTIVE then
        drawAPI.Text(4, 9, "Reactor status: Active (force)", 0x000000, 0xFFFFFF)
    elseif reactorInfo.Status == reactor.ReactorStatus.FORCE_INACTIVE then
        drawAPI.Text(4, 9, "Reactor status: Inactive (force)", 0x000000, 0xFFFFFF)
    elseif reactorInfo.Status == reactor.ReactorStatus.ACTIVE then
        drawAPI.Text(4, 9, "Reactor status: Active", 0x000000, 0xFFFFFF)
    else
        drawAPI.Text(4, 9, "Reactor status: Inactive", 0x000000, 0xFFFFFF)
    end

    drawAPI.Text(4, 11, "Current energy: " .. reactorInfo.Energy .. " RF", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 13, "Maximum energy: " .. reactorInfo.MaxEnergy .. " RF", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 15, "Energy production: " .. reactorInfo.EnergyDelta .. " RF/s", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 17, "Casing temperature: " .. reactorInfo.CasingTemperature .. " °C", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 19, "Fuel amount: " .. reactorInfo.FuelAmount .. " mB", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 21, "Fuel temperature: " .. reactorInfo.FuelTemperature .. " °C", 0x000000, 0xFFFFFF)
    drawAPI.Text(4, 23, "Waste amount: " .. reactorInfo.WasteAmount .. " mB", 0x000000, 0xFFFFFF)

    drawAPI.BorderBox(2, 27, 58, 15, "Controls", 0x5A5A5A)

    buttonAPI.draw(btnReactorOn)
    buttonAPI.draw(btnReactorOff)
    buttonAPI.draw(btnReactorAuto)

    lampAPI.draw(lpOn)
    lampAPI.draw(lpOff)
    lampAPI.draw(lpAuto)

    drawAPI.VerticalLine(19, 29, 11, 0x5A5A5A)
    local strHys = "Hysterises values : " .. reactor.getHysteresisMin() * 100 .. " % - " .. reactor.getHysteresisMax() * 100 .. " %"
    drawAPI.Text(21, 29, strHys, 0x000000, 0xFFFFFF)

    buttonAPI.draw(btnHysMinIncrease)
    buttonAPI.draw(btnHysMinDecrease)
    buttonAPI.draw(btnHysMaxIncrease)
    buttonAPI.draw(btnHysMaxDecrease)
end

return { Title = Title, init = init, handleTouchEvent = handleTouchEvent, show = show }
