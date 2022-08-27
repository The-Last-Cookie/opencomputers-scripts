local event = require("event")
local term = require("term")

local logger = require "Logger"
local program = require "Program"
local screenAPI = require "ScreenAPI"

function init()
    logger.log(logger.LogStatus.INFO, "Starting program")
    print("Loading ...")
    screenAPI.init()
    os.sleep(program.ScreenRefreshTime)
end

init()

event.listen("touch", screenAPI.handleTouchEvent)

while program.IsRunning do
    term.clear()
    screenAPI.display()
    os.sleep(program.ScreenRefreshTime)
end

event.ignore("touch", screenAPI.handleTouchEvent)
term.clear()

-- this would stay on false due to caching
program.IsRunning = true
