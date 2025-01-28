local fs = require("filesystem")

-- see http://www.lua.org/pil/22.1.html
local logFormat = "%d.%m.%Y %X"

local logOutput = "/var/reactor/logs/"

local Logger = {}

Logger.LogStatus = {
  INFO = 0,
  WARNING = 1,
  ERROR = 2
}

local function logToFile(message)
  if not fs.exists(logOutput) then
    if fs.makeDirectory(logOutput) == nil then
      io.write("Error: can't open log directory '" .. logOutput .. "'\n")
        .write("Using current working directory '" .. os.getenv("PWD") .. "' as log folder\n")
      logOutput = ""
    end
  end

  local file = io.open(logOutput .. "log_" .. os.date("%d%m%y") .. ".txt", "a")
  file:write(message .. "\n")
  file:close()
end

function Logger.log(logStatus, message)
  assert(type(logStatus) == "number")
  assert(type(message) == "string")

  local logMessage = ""

  if logStatus == Logger.LogStatus.INFO then
    logMessage = "[INFO] " .. os.date(logFormat) .. " " .. message
  end

  if logStatus == Logger.LogStatus.WARNING then
    logMessage = "[WARNING] " .. os.date(logFormat) .. " " .. message
  end

  if logStatus == Logger.LogStatus.ERROR then
    logMessage = "[ERROR] " .. os.date(logFormat) .. " " .. message
  end

  if logMessage then
    logToFile(logMessage)
  end
end

return Logger
