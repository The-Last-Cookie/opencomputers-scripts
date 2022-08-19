local component = require("component")
local term = require("term")
local logger = require "logger"

local reactor = component.br_reactor
local matrix = component.induction_matrix

-- screen refresh time in seconds
local refresh_time = 2

-- values between 0 and 1
local hysteresis_max = 0.7
local hysteresis_min = 0.3

local ReactorStatus = {
  NOT_CONNECTED = 0,
  INACTIVE = 1,
  ACTIVE = 2
}

local previousEnergy = nil

function init()
  logger.log(LogStatus.INFO, "Starting program")
  print("Loading ...")

  -- previousEnergy needs to be saved once beforehand, so that
  -- calculateEnergyPerSecond returns the correct value
  previousEnergy = matrix.getEnergy()
  os.sleep(refresh_time)
end

function calculateEnergyPerSecond()
  return (matrix.getEnergy() - previousEnergy) / refresh_time
end

function printMatrixInfo()
  print("Stored energy in matrix: " .. matrix.getEnergy() .. " RF")
  print("Produced energy per second: " .. calculateEnergyPerSecond() .. " RF/s")
end

function printReactorInfo(reactorStatus)
  if reactorStatus == ReactorStatus.NOT_CONNECTED then
    print("Reactor status: not connected safely")
    print("Please check both the reactor and the induction matrix.")
    return
  elseif reactorStatus == ReactorStatus.INACTIVE then
    print("Reactor status: inactive")

    if matrix.getEnergy() / matrix.getMaxEnergy() >= hysteresis_max then
      print("Maximum hysteresis value is exceeded by " .. matrix.getEnergy() - (hysteresis_max * matrix.getMaxEnergy()) .. " RF")
    else
      print("Current hysteresis value is " .. matrix.getEnergy() - (hysteresis_min * matrix.getMaxEnergy()) .. " RF above the minimum")
    end
  elseif reactorStatus == ReactorStatus.ACTIVE then
    print("Reactor status: active")
  end
  
  printMatrixInfo()
  print("Casing temperature: " .. reactor.getCasingTemperature() .. " °C")
  print("Fuel amount: " .. reactor.getFuelAmount() .. " mB")
  print("Fuel temperature: " .. reactor.getFuelTemperature() .. " °C")
  print("Waste amount: " .. reactor.getWasteAmount() .. " mB")
end

function monitorReactor()
  if not component.isAvailable("br_reactor") or not component.isAvailable("induction_matrix") then
    logger.log(LogStatus.ERROR, "Exiting program with status 1")
    printReactorInfo(ReactorStatus.NOT_CONNECTED)
    return
  end

  if matrix.getEnergy() / matrix.getMaxEnergy() >= hysteresis_max then
    if reactor.getActive() then
      reactor.setActive(false)
      logger.log(LogStatus.INFO, "Maximum hysterises value reached. Turning reactor off.")
    end

    printReactorInfo(ReactorStatus.INACTIVE)
    return
  end

  if matrix.getEnergy() / matrix.getMaxEnergy() <= hysteresis_min then
    if not reactor.getActive() then
      reactor.setActive(true)
      logger.log(LogStatus.INFO, "Minimum hysterises value reached. Turning reactor on.")
    end
  end

  if reactor.getActive() then
    printReactorInfo(ReactorStatus.ACTIVE)
  else
    printReactorInfo(ReactorStatus.INACTIVE)
  end
end

init()

while true do
  term.clear()
  monitorReactor()
  previousEnergy = matrix.getEnergy()
  os.sleep(refresh_time)
end

logger.log(LogStatus.INFO, "Exiting program with status 0")
