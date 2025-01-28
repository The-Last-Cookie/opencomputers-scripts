local component = require("component")

local logger = require "Logger"
local program = require "Program"

local Reactor = {}

local br_reactor = component.br_reactor
local matrix = component.induction_matrix

-- values between 0 and 1
local hysteresis_max = 0.7
local hysteresis_min = 0.3

Reactor.ReactorStatus = {
    NOT_CONNECTED = 0,
    INACTIVE = 1,
    ACTIVE = 2,
    FORCE_INACTIVE = 3,
    FORCE_ACTIVE = 4
}

local state = Reactor.ReactorStatus.NOT_CONNECTED

local previousEnergy = 0

function Reactor.init()
    -- previousEnergy needs to be saved once beforehand, so that
    -- calculateEnergyPerSecond returns the correct value
    previousEnergy = matrix.getEnergy()
end

local function calculateEnergyPerSecond()
    return (matrix.getEnergy() - previousEnergy) / program.ScreenRefreshTime
end

function Reactor.forceActive()
    state = Reactor.ReactorStatus.FORCE_ACTIVE
    br_reactor.setActive(true)
    logger.log(logger.LogStatus.WARNING, "Reactor now in forced active mode. It won't turn off without manual assistance.")
end

function Reactor.forceInactive()
    state = Reactor.ReactorStatus.FORCE_INACTIVE
    br_reactor.setActive(false)
    logger.log(logger.LogStatus.WARNING, "Reactor now in forced inactive mode. It won't turn on without manual assistance.")
end

function Reactor.disableForce()
    if state == Reactor.ReactorStatus.FORCE_ACTIVE then
        state = Reactor.ReactorStatus.ACTIVE
    elseif state == Reactor.ReactorStatus.FORCE_INACTIVE then
        state = Reactor.ReactorStatus.INACTIVE
    end
    logger.log(logger.LogStatus.WARNING, "Forced mode deactivated.")
end

function Reactor.setHysteresisMin(value)
    if value > 1 or value <= 0 or value >= hysteresis_max then
        return
    end

    hysteresis_min = value
end

function Reactor.setHysteresisMax(value)
    if value > 1 or value <= 0 or value <= hysteresis_min then
        return
    end

    hysteresis_max = value
end

function Reactor.getHysteresisMin()
    return hysteresis_min
end

function Reactor.getHysteresisMax()
    return hysteresis_max
end

function Reactor.monitor()
    if not component.isAvailable("br_reactor") or not component.isAvailable("induction_matrix") then
        state = Reactor.ReactorStatus.NOT_CONNECTED
        logger.log(logger.LogStatus.ERROR, "Exiting program with status 1")
        return
    end

    if state == Reactor.ReactorStatus.FORCE_ACTIVE or state == Reactor.ReactorStatus.FORCE_INACTIVE then
        return
    end

    if matrix.getEnergy() / matrix.getMaxEnergy() >= hysteresis_max then
        if br_reactor.getActive() then
            br_reactor.setActive(false)
            logger.log(logger.LogStatus.INFO, "Maximum hysterises value reached. Turning reactor off.")
        end
    end

    if matrix.getEnergy() / matrix.getMaxEnergy() <= hysteresis_min then
        if not br_reactor.getActive() then
            br_reactor.setActive(true)
            logger.log(logger.LogStatus.INFO, "Minimum hysterises value reached. Turning reactor on.")
        end
    end

    if br_reactor.getActive() then
        state = Reactor.ReactorStatus.ACTIVE
    else
        state = Reactor.ReactorStatus.INACTIVE
    end
end

function Reactor.getState()
    return state
end

function Reactor.getStatistics()
    reactorInfo = {
        Energy = matrix.getEnergy(),
        MaxEnergy = matrix.getMaxEnergy(),
        EnergyDelta = calculateEnergyPerSecond(),
        CasingTemperature = br_reactor.getCasingTemperature(),
        FuelAmount = br_reactor.getFuelAmount(),
        FuelTemperature = br_reactor.getFuelTemperature(),
        WasteAmount = br_reactor.getWasteAmount()
    }

    return reactorInfo
end

return Reactor
