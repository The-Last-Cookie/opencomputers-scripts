local component = require("component")

local logger = require "Logger"
local program = require "Program"

local reactor = component.br_reactor
local matrix = component.induction_matrix

-- values between 0 and 1
local hysteresis_max = 0.7
local hysteresis_min = 0.3

local ReactorStatus = {
    NOT_CONNECTED = 0,
    INACTIVE = 1,
    ACTIVE = 2,
    FORCE_INACTIVE = 3,
    FORCE_ACTIVE = 4
}

local state = ReactorStatus.NOT_CONNECTED

local previousEnergy = 0

local function init()
    -- previousEnergy needs to be saved once beforehand, so that
    -- calculateEnergyPerSecond returns the correct value
    previousEnergy = matrix.getEnergy()
end

local function calculateEnergyPerSecond()
    return (matrix.getEnergy() - previousEnergy) / program.ScreenRefreshTime
end

local function forceActive()
    state = ReactorStatus.FORCE_ACTIVE
    reactor.setActive(true)
    logger.log(logger.LogStatus.WARNING, "Reactor now in forced active mode. It won't turn off without manual assistance.")
end

local function forceInactive()
    state = ReactorStatus.FORCE_INACTIVE
    reactor.setActive(false)
    logger.log(logger.LogStatus.WARNING, "Reactor now in forced inactive mode. It won't turn on without manual assistance.")
end

local function disableForce()
    if state == ReactorStatus.FORCE_ACTIVE then
        state = ReactorStatus.ACTIVE
    elseif state == ReactorStatus.FORCE_INACTIVE then
        state = ReactorStatus.INACTIVE
    end
    logger.log(logger.LogStatus.WARNING, "Forced mode deactivated.")
end

local function setHysteresisMin(value)
    hysteresis_min = value
end

local function setHysteresisMax(value)
    hysteresis_max = value
end

local function getHysteresisMin()
    return hysteresis_min
end

local function getHysteresisMax()
    return hysteresis_max
end

local function monitorReactor()
    if not component.isAvailable("br_reactor") or not component.isAvailable("induction_matrix") then
        state = ReactorStatus.NOT_CONNECTED
        logger.log(logger.LogStatus.ERROR, "Exiting program with status 1")
        return
    end

    if state == ReactorStatus.FORCE_ACTIVE then
        return
    end

    if state == ReactorStatus.FORCE_INACTIVE then
        return
    end

    if matrix.getEnergy() / matrix.getMaxEnergy() >= hysteresis_max then
        if reactor.getActive() then
            reactor.setActive(false)
            logger.log(logger.LogStatus.INFO, "Maximum hysterises value reached. Turning reactor off.")
        end
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
end

local function getReactorInfo()
    reactorInfo = {
        Energy = matrix.getEnergy(),
        MaxEnergy = matrix.getMaxEnergy(),
        EnergyDelta = calculateEnergyPerSecond(),
        CasingTemperature = reactor.getCasingTemperature(),
        FuelAmount = reactor.getFuelAmount(),
        FuelTemperature = reactor.getFuelTemperature(),
        WasteAmount = reactor.getWasteAmount(),
        HysteresisMin = hysteresis_min,
        HysteresisMax = hysteresis_max
    }

    if state == ReactorStatus.NOT_CONNECTED then
        reactorInfo.Status = ReactorStatus.NOT_CONNECTED
    elseif state == ReactorStatus.FORCE_ACTIVE then
        reactorInfo.Status = ReactorStatus.FORCE_ACTIVE
    elseif state == ReactorStatus.FORCE_INACTIVE then
        reactorInfo.Status = ReactorStatus.FORCE_INACTIVE
    elseif state == ReactorStatus.ACTIVE then
        reactorInfo.Status = ReactorStatus.ACTIVE
    else
        reactorInfo.Status = ReactorStatus.INACTIVE
    end

    return reactorInfo
end

return { init = init, setHysteresisMax = setHysteresisMax, setHysteresisMin = setHysteresisMin, getHysteresisMin = getHysteresisMin,
    getHysteresisMax = getHysteresisMax, monitorReactor = monitorReactor, getReactorInfo = getReactorInfo, ReactorStatus = ReactorStatus }
