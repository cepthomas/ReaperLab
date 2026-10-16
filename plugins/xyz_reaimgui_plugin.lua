-- Derived from X-Raym_Simple ReaImGui.lua

console = true -- Display debug messages in the console
reaimgui_force_version = false -- false or string like "0.8.4"
input_title = "XR - Title"

--------------------------------------------------------------------------------
if not reaper.ImGui_CreateContext then
  reaper.MB("Missing dependency: ReaImGui extension.\nDownload it via Reapack ReaTeam extension repository.", "Error", 0)
  return false
end

if reaimgui_force_version then
  reaimgui_shim_file_path = reaper.GetResourcePath() .. '/Scripts/ReaTeam Extensions/API/imgui.lua'
  if reaper.file_exists( reaimgui_shim_file_path ) then
    dofile( reaimgui_shim_file_path )(reaimgui_force_version)
  end
end

--------------------------------------------------------------------------------
function Msg(value)
  if console then
    reaper.ShowConsoleMsg( tostring( value ) .. "\n" )
  end
end

--------------------------------------------------------------------------------
-- Set ToolBar Button State
function SetButtonState(st)
  local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  reaper.SetToggleCommandState( sec, cmd, st or 0 )
  reaper.RefreshToolbar2( sec, cmd )
end

--------------------------------------------------------------------------------
function Exit()
  SetButtonState()
end

--------------------------------------------------------------------------------
function Run()
  reaper.ImGui_SetNextWindowBgAlpha(ctx, 1)

  reaper.ImGui_PushFont(ctx, font, 14.0)
  reaper.ImGui_SetNextWindowSize(ctx, 400, 400, reaper.ImGui_Cond_Once())
  -- Yes reaper.ImGui_Cond_Always()), ImGui_Cond_Once()
  -- No reaper.ImGui_Cond_FirstUseEver())

  local imgui_visible, imgui_open = reaper.ImGui_Begin(ctx, input_title, true, reaper.ImGui_WindowFlags_NoCollapse())

  if imgui_visible then
    -- Draw ui.
    reaper.ImGui_Text(ctx, 'Hello world!')
    reaper.ImGui_SeparatorText(ctx, 'HORIZON')
    reaper.ImGui_Text(ctx, 'Beauty, eh?')

    reaper.ImGui_End(ctx)
  end

  reaper.ImGui_PopFont(ctx)

  if imgui_open and not reaper.ImGui_IsKeyPressed(ctx, reaper.ImGui_Key_Escape()) and not process then
    reaper.defer(Run)
  end

end

--------------------------------------------------------------------------------
function Init()
  SetButtonState(1)
  reaper.atexit(Exit)

  ctx = reaper.ImGui_CreateContext(input_title)
  font = reaper.ImGui_CreateFont('sans-serif', 16)
  reaper.ImGui_Attach(ctx, font)

  reaper.defer(Run)
end

if not preset_file_init then
  Init()
end
