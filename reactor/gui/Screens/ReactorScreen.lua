local interface = require "interface"
local reactor = require "Reactor"

local ReactorScreen = {}

function adjustToMaxWidth(maxTextWidth, baseText, statusText)
	local spaces = maxTextWidth - string.len(baseText) - string.len(statusText)
	local variableSpace = string.rep(" ", spaces)
	return baseText .. variableSpace .. statusText
end

function turnReactorOn()
	reactor.forceActive()
	interface.setLampColor("lpOn", 0x00FF00)
	interface.setLampColor("lpOff", 0xFF0000)
	interface.setLampColor("lpAuto", 0xFF0000)
end

function turnReactorOff()
	reactor.forceInactive()
    interface.setLampColor("lpOn", 0xFF0000)
	interface.setLampColor("lpOff", 0x00FF00)
	interface.setLampColor("lpAuto", 0xFF0000)
end

function turnReactorAuto()
	reactor.disableForce()
	interface.setLampColor("lpOn", 0xFF0000)
	interface.setLampColor("lpOff", 0xFF0000)
	interface.setLampColor("lpAuto", 0x00FF00)
end

function ReactorScreen.init()
	interface.newLabel("title", "Reactor Information and Control", 20, 3, 0xFFFFFF)

	interface.newBorderBox("infoBox", 2, 7, 44, 18, 0x5A5A5A, 0x000000, "Information", 0xFFFFFF)
	interface.newBorderBox("controlBox", 2, 27, 58, 15, 0x5A5A5A, 0x000000, "Controls", 0xFFFFFF)

    interface.newLine("lineControl", 19, 29, 11, "vertical", 0x5A5A5A)

	interface.newButton("btnReactorOn", "On", 0xFFFFFF, 0x00FF00, 4, 29, 10, 3, turnReactorOn, nil)
	interface.newButton("btnReactorOff", "Off", 0xFFFFFF, 0xFF0000, 4, 33, 10, 3, turnReactorOff, nil)
	interface.newButton("btnReactorAuto", "Auto", 0xFFFFFF, 0x0000FF, 4, 37, 10, 3, turnReactorAuto, nil)

	interface.newLamp("lpOn", 15, 29, 3, 3, 0x5A5A5A, 0xFF0000)
	interface.newLamp("lpOff", 15, 33, 3, 3, 0x5A5A5A, 0xFF0000)
	interface.newLamp("lpAuto", 15, 37, 3, 3, 0x5A5A5A, 0xFF0000)

	interface.newButton("btnHysMinIncrease", "Min + 10", 0xFFFFFF, 0x0000FF, 21, 31, 10, 3, reactor.setHysteresisMin, reactor.getHysteresisMin() + 0.1)
	interface.newButton("btnHysMinDecrease", "Min - 10", 0xFFFFFF, 0x0000FF, 21, 35, 10, 3, reactor.setHysteresisMin, reactor.getHysteresisMin() - 0.1)
	interface.newButton("btnHysMaxIncrease", "Max + 10", 0xFFFFFF, 0x0000FF, 32, 31, 10, 3, reactor.setHysteresisMax, reactor.getHysteresisMax() + 0.1)
	interface.newButton("btnHysMaxDecrease", "Max - 10", 0xFFFFFF, 0x0000FF, 32, 35, 10, 3, reactor.setHysteresisMax, reactor.getHysteresisMax() - 0.1)

	interface.newLabel("reactorStatus", "Reactor status: Initializing", 4, 9, 0xFFFFFF)
	interface.newLabel("currEnergy", "Current energy: ", 4, 11, 0xFFFFFF)
	interface.newLabel("maxEnergy", "Maximum energy: ", 4, 13, 0xFFFFFF)
	interface.newLabel("energyProd", "Energy production: ", 4, 15, 0xFFFFFF)
	interface.newLabel("caseTemp", "Casing temperature: ", 4, 17, 0xFFFFFF)
	interface.newLabel("fuelAmount", "Fuel amount: ", 4, 19, 0xFFFFFF)
	interface.newLabel("fuelTemp", "Fuel temperature: ", 4, 21, 0xFFFFFF)
	interface.newLabel("wasteAmount", "Waste amount: ", 4, 23, 0xFFFFFF)
	interface.newLabel("hysValues", "Hysterises values: ", 21, 29, 0xFFFFFF)
end

function ReactorScreen.update()
	local reactorInfo = reactor.getStatistics()
	local reactorState = reactor.getState()

	local baseText = "Reactor status: "

	-- information box width is 44 - 4 (border line + extra padding from the border)
	local maxTextWidth = 40

	if reactorState == reactor.ReactorStatus.NOT_CONNECTED then
		local statusText = "Not connected"
		local labelText = adjustToMaxWidth(maxTextWidth, baseText, statusText)
		interface.setLabelText("reactorStatus", labelText)
    elseif reactorState == reactor.ReactorStatus.FORCE_ACTIVE then
		local statusText = "Active (force)"
		local labelText = adjustToMaxWidth(maxTextWidth, baseText, statusText)
		interface.setLabelText("reactorStatus", labelText)
    elseif reactorState == reactor.ReactorStatus.FORCE_INACTIVE then
		local statusText = "Inactive (force)"
		local labelText = adjustToMaxWidth(maxTextWidth, baseText, statusText)
		interface.setLabelText("reactorStatus", labelText)
    elseif reactorState == reactor.ReactorStatus.ACTIVE then
		local statusText = "Active"
		local labelText = adjustToMaxWidth(maxTextWidth, baseText, statusText)
		interface.setLabelText("reactorStatus", labelText)
    else
		local statusText = "Inactive"
		local labelText = adjustToMaxWidth(maxTextWidth, baseText, statusText)
		interface.setLabelText("reactorStatus", labelText)
    end

	-- control box width is 58 - 4 (border line + extra padding from the border)
	local maxTextWidth = 58

	-- TODO: DataTable class for getting strings?
	interface.setLabelText("currEnergy", adjustToMaxWidth(maxTextWidth, "Current energy: ", reactorInfo.Energy .. " RF"))
	interface.setLabelText("maxEnergy", adjustToMaxWidth(maxTextWidth, "Maximum energy: ", reactorInfo.MaxEnergy .. " RF"))
	interface.setLabelText("energyProd", adjustToMaxWidth(maxTextWidth, "Energy production: ", reactorInfo.EnergyDelta .. " RF/s"))
	interface.setLabelText("caseTemp", adjustToMaxWidth(maxTextWidth, "Casing temperature: ", reactorInfo.CasingTemperature .. " °C"))
	interface.setLabelText("fuelAmount", adjustToMaxWidth(maxTextWidth, "Fuel amount: ", reactorInfo.FuelAmount .. " mB"))
	interface.setLabelText("fuelTemp", adjustToMaxWidth(maxTextWidth, "Fuel temperature: ", reactorInfo.FuelTemperature .. " °C"))
	interface.setLabelText("wasteAmount", adjustToMaxWidth(maxTextWidth, "Waste amount: ", reactorInfo.WasteAmount .. " mB"))

	local strHys = reactor.getHysteresisMin() * 100 .. " % - " .. reactor.getHysteresisMax() * 100 .. " %"
	interface.setLabelText("hysValues", adjustToMaxWidth(maxTextWidth, "Hysterises values: ", strHys))
end

return ReactorScreen
