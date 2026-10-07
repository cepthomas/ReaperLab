
-- Minimal lua script

-- Scripts go in %APPDATA%\REAPER\Scripts\User

-- function returning a single (scalar) value:
sec = reaper.parse_timestr("1:12")

reaper.ShowConsoleMsg('>>>>>'..sec)



-- I think this is Lokasenna_GUI stuff??
-- local GUI = require("gui.core")

-- local window = GUI.createWindow({
--   name = "My Script",
--   w = 96,
--   h = 48,
-- })

-- local layer = GUI.createLayer({
--   name = "My Layer"
-- })

-- local button = GUI.createElement({
--   name = "My Button",
--   type = "Button",
--   x = 16,
--   y = 16,
--   caption = "Hi!"
-- })

-- button.func = function() reaper.ShowMessageBox("You clicked the button!", "Yay!", 0) end

-- layer:addElements(button)
-- window:addLayers(layer)

-- window:open()
-- GUI.Main()

