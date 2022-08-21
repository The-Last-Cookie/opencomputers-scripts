local event = require("event")
local term = require("term")

local logger = require "Logger"
local screenInfo = require "ScreenInfo"
local screenAPI = require "ScreenAPI"

function init()
    logger.log(logger.LogStatus.INFO, "Starting program")
    print("Loading ...")
    screenAPI.init()
    os.sleep(screenInfo.ScreenRefreshTime)
end

init()

event.listen("touch", screenAPI.handleTouchEvent)

while true do
    term.clear()
    screenAPI.display()
    os.sleep(screenInfo.ScreenRefreshTime)
end

event.ignore("touch", screenAPI.handleTouchEvent)
