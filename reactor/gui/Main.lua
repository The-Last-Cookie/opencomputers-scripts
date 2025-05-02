local event = require("event")
local term = require("term")

local logger = require "Logger"
local program = require "Program"
local interface = require "interface"
local reactor = require "Reactor"
local reactorScreen = require "Screens/ReactorScreen"


logger.log(logger.LogStatus.INFO, "Starting program")
print("Loading ...")

reactor.init()
interface.clearAllObjects()
interface.clearScreen()
reactorScreen.init()
interface.updateAll()

while program.IsRunning do
    local name, address, x, y, button, player = event.pull(program.ScreenRefreshTime, "touch")

    if x and y then
        interface.processClick(x,y)
    end

    reactor.monitor()
    reactorScreen.update()
end

term.clear()

-- this would stay on false due to caching
program.IsRunning = true
