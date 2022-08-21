local component = require("component")

local logger = require "Logger"
local screenInfo = require "ScreenInfo"

local reactor = component.br_reactor
local matrix = component.induction_matrix

-- values between 0 and 1
local hysteresis_max = 0.7
local hysteresis_min = 0.3

local ReactorStatus = {
    NOT_CONNECTED = 0,
    INACTIVE = 1,
    ACTIVE = 2
}

local state = ReactorStatus.NOT_CONNECTED

local previousEnergy = 0

local function init()
    -- previousEnergy needs to be saved once beforehand, so that
    -- calculateEnergyPerSecond returns the correct value
    previousEnergy = matrix.getEnergy()
end

local function calculateEnergyPerSecond()
    return (matrix.getEnergy() - previousEnergy) / screenInfo.ScreenRefreshTime
end

local function monitorReactor()
    if not component.isAvailable("br_reactor") or not component.isAvailable("induction_matrix") then
        state = ReactorStatus.NOT_CONNECTED
        logger.log(logger.LogStatus.ERROR, "Exiting program with status 1")
        return
    end

    if matrix.getEnergy() / matrix.getMaxEnergy() >= hysteresis_max then
        if reactor.getActive() then
            reactor.setActive(false)
            logger.log(logger.LogStatus.INFO, "Maximum hysterises value reached. Turning reactor off.")
        end

        state = ReactorStatus.INACTIVE
        return
    end

    if matrix.getEnergy() / matrix.getMaxEnergy() <= hysteresis_min then
        if not reactor.getActive() then
            reactor.setActive(true)
            logger.log(logger.LogStatus.INFO, "Minimum hysterises value reached. Turning reactor on.")
        end
    end

    if reactor.getActive() then
        state = ReactorStatus.ACTIVE
    else
        state = ReactorStatus.INACTIVE
end

local function getReactorInfo()
    reactorInfo = {
        Energy = matrix.getEnergy(),
        MaxEnergy = matrix.getMaxEnergy(),
        EnergyDelta = calculateEnergyPerSecond(),
        CasingTemperature = reactor.getCasingTemperature(),
        FuelAmount = reactor.getFuelAmount(),
        FuelTemperature = reactor.getFuelTemperature(),
        WasteAmount = reactor.getWasteAmount()
    }

    if state == ReactorStatus.NOT_CONNECTED then
        reactorInfo.Status = ReactorStatus.NOT_CONNECTED
    elseif state == ReactorStatus.ACTIVE then
        reactorInfo.Status = ReactorStatus.ACTIVE
    else
        reactorInfo.Status = ReactorStatus.INACTIVE
    end

    return reactorInfo
end

return { init = init, monitorReactor = monitorReactor, getReactorInfo = getReactorInfo, ReactorStatus = ReactorStatus }
