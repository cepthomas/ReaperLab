
-- Minimal lua script.
-- Looks like only one action per script.

sec = reaper.parse_timestr("1:12")

reaper.ShowConsoleMsg('xyz_plugin >>>>>'..sec..'\n')




-- To run multiple native or extension actions inside a single Lua script in REAPER,
-- use the reaper.Main_OnCommand() function. e.g.
-- -- Unselect all items
-- reaper.Main_OnCommand(40289, 0)
-- -- Select all tracks
-- reaper.Main_OnCommand(40296, 0)
-- -- Run an SWS extension action (e.g., select only tracks with selected items)
-- local sws_action = reaper.NamedCommandLookup("_SWS_SELTRKWITEM")
-- if sws_action ~= 0 then
--     reaper.Main_OnCommand(sws_action, 0)
-- end
