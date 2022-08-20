local logger = require "Logger"
local screenInfo = require "ScreenInfo"

function init()
    logger.log(logger.LogStatus.INFO, "Starting program")
    print("Loading ...")
    screenAPI.init()
    os.sleep(screenInfo.ScreenRefreshTime)
end

init()

while true do
    term.clear()
    screenAPI.display()
    os.sleep(screenInfo.ScreenRefreshTime)
end
