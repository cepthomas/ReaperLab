-- >>> From ReaImGui_Demo.lua
-- Lua/ReaImGui port of Dear ImGui's C++ demo code (v1.92.1)

local function _tell(o)
  reaper.ShowConsoleMsg('HEY:'..tostring(o)..'\n')
end

_tell('Well, hello from xyz_ui_plugin.lua!!!')

package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
local ImGui = require 'imgui' '0.10'

-- local ctx, clipper
local FLT_MIN, FLT_MAX = ImGui.NumericLimits_Float()
-- local DBL_MIN, DBL_MAX = ImGui.NumericLimits_Double()
-- local IMGUI_VERSION, IMGUI_VERSION_NUM, REAIMGUI_VERSION = ImGui.GetVersion()


local demo =
{
  open = true,

  menu =
  {
    enabled = true,
    f = 0.5,
    n = 0,
    b = true,
  },

  -- Window flags (accessible from the "Configuration" section)
  no_titlebar       = false,
  no_scrollbar      = false,
  no_menu           = false,
  no_move           = false,
  no_resize         = false,
  no_collapse       = false,
  no_close          = false,
  no_nav            = false,
  no_background     = false,
  -- no_bring_to_front = false,
  unsaved_document  = false,
  no_docking        = false,
}


local window_flags = ImGui.WindowFlags_None
window_flags = window_flags | ImGui.WindowFlags_NoTitleBar
window_flags = window_flags | ImGui.WindowFlags_NoScrollbar
window_flags = window_flags | ImGui.WindowFlags_MenuBar
window_flags = window_flags | ImGui.WindowFlags_NoMove
window_flags = window_flags | ImGui.WindowFlags_NoResize
window_flags = window_flags | ImGui.WindowFlags_NoCollapse
window_flags = window_flags | ImGui.WindowFlags_NoNav
window_flags = window_flags | ImGui.WindowFlags_NoBackground
window_flags = window_flags | ImGui.WindowFlags_NoDocking
window_flags = window_flags | ImGui.WindowFlags_TopMost
window_flags = window_flags | ImGui.WindowFlags_UnsavedDocument

-- if demo.no_close          then open = false end -- disable the close button


local widgets = {}

-- local ctx = ImGui.CreateContext('XYZ-ui-demo')


-- Main body of the Demo window starts here.
-- rv1, open = ImGui.Begin(ctx, 'XYZ=================', true, window_flags)

-- _tell(ctx)
-- _tell(rv1)
-- _tell(open)


-- -- Early out if the window is collapsed
-- if not rv1 then return open end

-- -- clipper = ImGui.CreateListClipper(ctx)
-- -- ImGui.Attach(ctx, clipper)

-- _tell('10')

-- reaper.defer(demo.loop)

-- _tell('90')

-- ImGui.End(ctx)



--[[
This file can be imported in other scripts to help during development:

local demo = require 'ReaImGui_Demo'
local ctx = ImGui.CreateContext('My script')

local function loop()
  demo.PushStyle(ctx)
  demo.ShowDemoWindow(ctx)
  if ImGui.Begin(ctx, 'Dear ImGui Style Editor') then
    demo.ShowStyleEditor(ctx)
    ImGui.End(ctx)
  end
  demo.PopStyle(ctx)
  reaper.defer(loop)
end

reaper.defer(loop)
--]]



-- This file can be imported in other scripts to help during development:

-- local demo = require 'ReaImGui_Demo'
local ctx = ImGui.CreateContext('XYZ-ui-demo')

-- xyz_ui_plugin.lua:120: attempt to call a nil value (field 'PushStyle')

local function loop()
  -- demo.PushStyle(ctx)
  demo.ShowDemoWindow(ctx)
  if ImGui.Begin(ctx, 'XYZ=================', true, window_flags) then
    demo.ShowDemoWindow(ctx)
    ImGui.End(ctx)
  end
  -- demo.PopStyle(ctx)
  reaper.defer(loop)
end

reaper.defer(loop)




-- function demo.loop()

--   _tell('30')
--   demo.DemoWindowWidgetsBasic()
--   _tell('80')

--   -- demo.PushStyle()
--   -- demo.open = demo.ShowDemoWindow(true)
--   -- demo.PopStyle()

--   -- if demo.open then
--   --   _tell('83')
--   --   reaper.defer(demo.loop)
--   --   _tell('84')
--   -- end
-- end



-- if select(2, reaper.get_action_context()) == debug.getinfo(1, 'S').source:sub(2) then
--   -- show global storage in the IDE for convenience
--   _G.demo    = demo
--   _G.widgets = widgets
--   -- _G.layout  = layout
--   -- _G.popups  = popups
--   -- _G.tables  = tables
--   -- _G.misc    = misc
--   -- _G.app     = app
-- end



-- ===================================================================================
-- ===================================================================================
-- ===================================================================================

-- In window "XYZ=================": Missing End()

--   bool my_tool_is_active = false; if (ImGui.Button("Open")) my_tool_is_active = true; [...] if (my_tool_is_active) Begin("My Tool", &my_tool_is_active) { [...] } End();

----------------------------------------------------------------------------------
function demo.DemoWindowWidgetsBasic()
  local rv

  _tell('200')

  if not ImGui.TreeNode(ctx, 'Basic') then return end

  if not widgets.basic then
    widgets.basic =
    {
      clicked = 0,
      check   = true,
      radio   = 0,
      counter = 0,
      curitem = 0,
      str0    = 'Hello, world!',
      str1    = '',
      vec4a   = reaper.new_array({0.10, 0.20, 0.30, 0.44}),
      i0      = 123,
      i1      = 50,
      i2      = 42,
      i3      = 128,
      i4      = 0,
      d0      = 999999.00000001,
      d1      = 1e10,
      d2      = 1.00,
      d3      = 0.0067,
      d4      = 0.123,
      d5      = 0.0,
      angle   = 0.0,
      elem    = 1,
      col1    = 0xff0033,   -- 0xRRGGBB
      col2    = 0x66b2007f, -- 0xRRGGBBAA
      listcur = 0,
    }
  end

  ImGui.SeparatorText(ctx, 'General')

  if ImGui.Button(ctx, 'Button') then
    widgets.basic.clicked = widgets.basic.clicked + 1
  end

  if widgets.basic.clicked & 1 ~= 0 then
    ImGui.SameLine(ctx)
    ImGui.Text(ctx, 'Thanks for clicking me!')
  end

  _tell('250')

  rv,widgets.basic.check = ImGui.Checkbox(ctx, 'checkbox', widgets.basic.check)

  rv,widgets.basic.radio = ImGui.RadioButtonEx(ctx, 'radio a', widgets.basic.radio, 0); ImGui.SameLine(ctx)
  rv,widgets.basic.radio = ImGui.RadioButtonEx(ctx, 'radio b', widgets.basic.radio, 1); ImGui.SameLine(ctx)
  rv,widgets.basic.radio = ImGui.RadioButtonEx(ctx, 'radio c', widgets.basic.radio, 2)

  ImGui.AlignTextToFramePadding(ctx)
  ImGui.TextLinkOpenURL(ctx, 'Hyperlink', 'https://forum.cockos.com/showthread.php?t=250419')

  -- Color buttons, demonstrate using PushID() to add unique identifier in the ID stack, and changing style.
  for i = 0, 6 do
    if i > 0 then
      ImGui.SameLine(ctx)
    end
    ImGui.PushID(ctx, i)
    ImGui.PushStyleColor(ctx, ImGui.Col_Button,        demo.HSV(i / 7.0, 0.6, 0.6, 1.0))
    ImGui.PushStyleColor(ctx, ImGui.Col_ButtonHovered, demo.HSV(i / 7.0, 0.7, 0.7, 1.0))
    ImGui.PushStyleColor(ctx, ImGui.Col_ButtonActive,  demo.HSV(i / 7.0, 0.8, 0.8, 1.0))
    ImGui.Button(ctx, 'Click')
    ImGui.PopStyleColor(ctx, 3)
    ImGui.PopID(ctx)
  end
  _tell('260')

  -- Use AlignTextToFramePadding() to align text baseline to the baseline of framed widgets elements
  -- (otherwise a Text+SameLine+Button sequence will have the text a little too high by default!)
  -- See 'Demo->Layout->Text Baseline Alignment' for details.
  ImGui.AlignTextToFramePadding(ctx)
  ImGui.Text(ctx, 'Hold to repeat:')
  ImGui.SameLine(ctx)

  -- Arrow buttons with Repeater
  local spacing = ImGui.GetStyleVar(ctx, ImGui.StyleVar_ItemInnerSpacing)
  ImGui.PushItemFlag(ctx, ImGui.ItemFlags_ButtonRepeat, true)
  if ImGui.ArrowButton(ctx, '##left', ImGui.Dir_Left) then
    widgets.basic.counter = widgets.basic.counter - 1
  end
  ImGui.SameLine(ctx, 0.0, spacing)
  if ImGui.ArrowButton(ctx, '##right', ImGui.Dir_Right) then
    widgets.basic.counter = widgets.basic.counter + 1
  end
  ImGui.PopItemFlag(ctx)
  ImGui.SameLine(ctx)
  ImGui.Text(ctx, ('%d'):format(widgets.basic.counter))
  _tell('280')

  ImGui.Button(ctx, 'Tooltip')
  ImGui.SetItemTooltip(ctx, 'I am a tooltip')

  ImGui.LabelText(ctx, 'label', 'Value')

  ImGui.SeparatorText(ctx, 'Inputs')

  do
    rv,widgets.basic.str0 = ImGui.InputText(ctx, 'input text', widgets.basic.str0)
    ImGui.SameLine(ctx); demo.HelpMarker(
      'USER:\n\z
       Hold Shift or use mouse to select text.\n\z
       Ctrl+Left/Right to word jump.\n\z
       Ctrl+A or double-click to select all.\n\z
       Ctrl+X,Ctrl+C,Ctrl+V for clipboard.\n\z
       Ctrl+Z to undo, Ctrl+Y/Ctrl+Shift+Z to redo.\n\z
       Escape to revert.')

    rv,widgets.basic.str1 = ImGui.InputTextWithHint(ctx, 'input text (w/ hint)', 'enter text here', widgets.basic.str1)

    rv,widgets.basic.i0 = ImGui.InputInt(ctx, 'input int', widgets.basic.i0)

    rv,widgets.basic.d0 = ImGui.InputDouble(ctx, 'input double', widgets.basic.d0, 0.01, 1.0, '%.8f')
    rv,widgets.basic.d1 = ImGui.InputDouble(ctx, 'input scientific', widgets.basic.d1, 0.0, 0.0, '%e')
    ImGui.SameLine(ctx); demo.HelpMarker(
      'You can input value using the scientific notation,\n\z
       e.g. "1e+8" becomes "100000000".')

    ImGui.InputDoubleN(ctx, 'input reaper.array', widgets.basic.vec4a)
  end
  _tell('290')

  ImGui.SeparatorText(ctx, 'Drags')

  do
    rv,widgets.basic.i1 = ImGui.DragInt(ctx, 'drag int', widgets.basic.i1, 1)
    ImGui.SameLine(ctx); demo.HelpMarker(
      'Click and drag to edit value.\n\z
       Hold Shift/Alt for faster/slower edit.\n\z
       Double-click or Ctrl+click to input value.')

    rv,widgets.basic.i2 = ImGui.DragInt(ctx, 'drag int 0..100', widgets.basic.i2, 1, 0, 100, '%d%%', ImGui.SliderFlags_AlwaysClamp)
    rv,widgets.basic.i3 = ImGui.DragInt(ctx, 'drag int wrap 100..200', widgets.basic.i3, 1, 100, 200, '%d', ImGui.SliderFlags_WrapAround)

    rv,widgets.basic.d2 = ImGui.DragDouble(ctx, 'drag double', widgets.basic.d2, 0.005)
    rv,widgets.basic.d3 = ImGui.DragDouble(ctx, 'drag small double', widgets.basic.d3, 0.0001, 0.0, 0.0, '%.06f ns')
    -- rv,widgets.basic.d4 = ImGui.DragDouble(ctx, 'drag wrap -1..1', widgets.basic.d4, 0.005, -1.0, 1.0, nil, ImGui.SliderFlags_WrapAround)
  end

  ImGui.SeparatorText(ctx, 'Sliders')
  _tell('300')

  do
    rv,widgets.basic.i4 = ImGui.SliderInt(ctx, 'slider int', widgets.basic.i4, -1, 3)
    ImGui.SameLine(ctx); demo.HelpMarker('Ctrl+click to input value.')

    rv,widgets.basic.d4 = ImGui.SliderDouble(ctx, 'slider double', widgets.basic.d4, 0.0, 1.0, 'ratio = %.3f')
    rv,widgets.basic.d5 = ImGui.SliderDouble(ctx, 'slider double (log)', widgets.basic.d5, -10.0, 10.0, '%.4f', ImGui.SliderFlags_Logarithmic)

    rv,widgets.basic.angle = ImGui.SliderAngle(ctx, 'slider angle', widgets.basic.angle)

    -- Using the format string to display a name instead of an integer.
    -- Here we completely omit '%d' from the format string, so it'll only display a name.
    -- This technique can also be used with DragInt().
    local elements = {'Fire', 'Earth', 'Air', 'Water'}
    local current_elem = elements[widgets.basic.elem] or 'Unknown'
    rv,widgets.basic.elem = ImGui.SliderInt(ctx, 'slider enum', widgets.basic.elem, 1, #elements, current_elem) -- Use ImGuiSliderFlags_NoInput flag to disable Ctrl+Click here.
    ImGui.SameLine(ctx)
    demo.HelpMarker(
      'Using the format string parameter to display a name instead \z
       of the underlying integer.')
  end

  ImGui.SeparatorText(ctx, 'Selectors/Pickers')
  _tell('310')

  do
    rv,widgets.basic.col1 = ImGui.ColorEdit3(ctx, 'color 1', widgets.basic.col1)
    ImGui.SameLine(ctx); demo.HelpMarker(
      'Click on the color square to open a color picker.\n\z
       Click and hold to use drag and drop.\n\z
       Right-click on the color square to show options.\n\z
       Ctrl+click on individual component to input value.')

    rv, widgets.basic.col2 = ImGui.ColorEdit4(ctx, 'color 2', widgets.basic.col2)
  end

  do
    -- Using the _simplified_ one-liner Combo() api here
    -- See "Combo" section for examples of how to use the more flexible BeginCombo()/EndCombo() api.
    local items = 'AAAA\0BBBB\0CCCC\0DDDD\0EEEE\0FFFF\0GGGG\0HHHH\0IIIIIII\0JJJJ\0KKKKKKK\0'
    rv,widgets.basic.curitem = ImGui.Combo(ctx, 'combo', widgets.basic.curitem, items)
    ImGui.SameLine(ctx); demo.HelpMarker(
      'Using the simplified one-liner Combo API here.\n\z
       Refer to the "Combo" section below for an explanation of how to use the more flexible and general BeginCombo/EndCombo API.')
  end
  _tell('320')

  do
    -- Using the _simplified_ one-liner ListBox() api here
    -- See "List boxes" section for examples of how to use the more flexible BeginListBox()/EndListBox() api.
    local items = 'Apple\0Banana\0Cherry\0Kiwi\0Mango\0Orange\0Pineapple\0Strawberry\0Watermelon\0'
    rv,widgets.basic.listcur = ImGui.ListBox(ctx, 'listbox\n(single select)', widgets.basic.listcur, items, 4)
    ImGui.SameLine(ctx)
    demo.HelpMarker(
      'Using the simplified one-liner ListBox API here.\n\z
       Refer to the "List boxes" section below for an explanation of how to use\z
       the more flexible and general BeginListBox/EndListBox API.')
  end

  -- Testing ImGuiOnceUponAFrame helper.
  -- static ImGuiOnceUponAFrame once;
  -- for i = 1, 5 do
  --   if (once)
  --     ImGui.Text(ctx, 'This will be displayed only once.')
  -- end

  _tell('340')

  ImGui.TreePop(ctx)
end


----------------------------------------------------------------------------------
function demo.DemoWindowWidgetsProgressBars()
  if not ImGui.TreeNode(ctx, 'Progress Bars') then return end

  if not widgets.progress_bars then
    widgets.progress_bars = {
      progress     = 0.0,
      progress_dir = 1,
    }
  end

  -- Animate a simple progress bar
  widgets.progress_bars.progress = widgets.progress_bars.progress +
    (widgets.progress_bars.progress_dir * 0.4 * ImGui.GetDeltaTime(ctx))
  if widgets.progress_bars.progress >= 1.1 then
    widgets.progress_bars.progress = 1.1
    widgets.progress_bars.progress_dir = widgets.progress_bars.progress_dir * -1
  elseif widgets.progress_bars.progress <= -0.1 then
    widgets.progress_bars.progress = -0.1
    widgets.progress_bars.progress_dir = widgets.progress_bars.progress_dir * -1
  end

  -- Typically we would use (-1.0,0.0) or (-FLT_MIN,0.0) to use all available width,
  -- or (width,0.0) for a specified width. (0.0,0.0) uses ItemWidth.
  ImGui.ProgressBar(ctx, widgets.progress_bars.progress, 0.0, 0.0)
  ImGui.SameLine(ctx, 0.0, (ImGui.GetStyleVar(ctx, ImGui.StyleVar_ItemInnerSpacing)))
  ImGui.Text(ctx, 'Progress Bar')

  local progress_saturated = demo.clamp(widgets.progress_bars.progress, 0.0, 1.0);
  local buf = ('%d/%d'):format(math.floor(progress_saturated * 1753), 1753)
  ImGui.ProgressBar(ctx, widgets.progress_bars.progress, 0.0, 0.0, buf);

  -- Pass an animated negative value, e.g. -1.0f * (float)ImGui::GetTime() is the recommended value.
  -- Adjust the factor if you want to adjust the animation speed.
  ImGui.ProgressBar(ctx, -1.0 * ImGui.GetTime(ctx), 0.0, 0.0, 'Searching...')
  ImGui.SameLine(ctx, 0.0, (ImGui.GetStyleVar(ctx, ImGui.StyleVar_ItemInnerSpacing)))
  ImGui.Text(ctx, 'Indeterminate')

  ImGui.TreePop(ctx)
end

function demo.round(n)
  return math.floor(n + .5)
end

function demo.clamp(v, mn, mx)
  if v < mn then return mn end
  if v > mx then return mx end
  return v
end

function demo.HSV(h, s, v, a)
  local r, g, b = ImGui.ColorConvertHSVtoRGB(h, s, v)
  return ImGui.ColorConvertDouble4ToU32(r, g, b, a or 1.0)
end

-- Helper to display a little (?) mark which shows a tooltip when hovered.
-- In your own code you may want to display an actual icon if you are using a merged icon fonts (see docs/FONTS.md)
function demo.HelpMarker(desc)
  ImGui.TextDisabled(ctx, '(?)')
  if ImGui.BeginItemTooltip(ctx) then
    ImGui.PushTextWrapPos(ctx, ImGui.GetFontSize(ctx) * 35.0)
    ImGui.Text(ctx, desc)
    ImGui.PopTextWrapPos(ctx)
    ImGui.EndTooltip(ctx)
  end
end



-------------------------------------------------------------------------------
function demo.DemoWindowInputs() -- TODO
  -- local rv

  if not ImGui.CollapsingHeader(ctx, 'Inputs & Focus') then return end

  -- Display inputs
  ImGui.SetNextItemOpen(ctx, true, ImGui.Cond_Once)
  local inputs_opened = ImGui.TreeNode(ctx, 'Inputs')
  ImGui.SameLine(ctx)
  demo.HelpMarker("xxxxxxxxxxxxxxxxx")

  if inputs_opened then
    if ImGui.IsMousePosValid(ctx) then
      ImGui.Text(ctx, ('Mouse pos: (%g, %g)'):format(ImGui.GetMousePos(ctx)))
    else
      ImGui.Text(ctx, 'Mouse pos: <INVALID>')
    end
    ImGui.Text(ctx, ('Mouse delta: (%g, %g)'):format(ImGui.GetMouseDelta(ctx)))

    local buttons = 4
    ImGui.Text(ctx, 'Mouse down:')
    for button = 0, buttons do
      if ImGui.IsMouseDown(ctx, button) then
        local duration = ImGui.GetMouseDownDuration(ctx, button)
        ImGui.SameLine(ctx)
        ImGui.Text(ctx, ('b%d (%.02f secs)'):format(button, duration))
      end
    end

    ImGui.Text(ctx, ('Mouse wheel: %.1f %.1f'):format(ImGui.GetMouseWheel(ctx)))

    ImGui.Text(ctx, 'Mouse clicked count:')
    for button = 0, buttons do
      if ImGui.IsMouseDown(ctx, button) then
        local count = ImGui.GetMouseClickedCount(ctx, button)
        if count > 0 then
          ImGui.SameLine(ctx)
          ImGui.Text(ctx, ('b%d: %d'):format(button, count))
        end
      end
    end

    ImGui.Text(ctx, 'Keys down:')
    for key, name in demo.EachEnum('Key') do
      if ImGui.IsKeyDown(ctx, key) then
        local duration = ImGui.GetKeyDownDuration(ctx, key)
        ImGui.SameLine(ctx)
        ImGui.Text(ctx, ('"%s" %d (%.02f secs)'):format(name, key, duration))
      end
    end
    ImGui.Text(ctx, ('Keys mods: %s%s%s%s'):format(
      ImGui.IsKeyDown(ctx, ImGui.Mod_Ctrl)  and 'Ctrl '   or '',
      ImGui.IsKeyDown(ctx, ImGui.Mod_Shift) and 'Shift '  or '',
      ImGui.IsKeyDown(ctx, ImGui.Mod_Alt)   and 'Alt '    or '',
      ImGui.IsKeyDown(ctx, ImGui.Mod_Super) and 'Super '  or ''))

    ImGui.Text(ctx, 'Chars queue:')
    for next_id = 0, math.huge do
      local rv, c = ImGui.GetInputQueueCharacter(ctx, next_id)
      if not rv then break end
      ImGui.SameLine(ctx)
      ImGui.Text(ctx, ("'%s' (0x%04X)"):format(utf8.char(c), c))
    end

    ImGui.TreePop(ctx)
  end

  -- Display ImGuiIO output flags
  -- ImGui.SetNextItemOpen(ctx, true, ImGui.Cond_Once)
  -- local outputs_opened = ImGui.TreeNode(ctx, 'Outputs')
  -- demo.HelpMarker(
  --  'The value of io.WantCaptureMouse and io.WantCaptureKeyboard are normally set by Dear ImGui \z
  --   to instruct your application of how to route inputs. Typically, when a value is true, it means \z
  --   Dear ImGui wants the corresponding inputs and we expect the underlying application to ignore them.\n\n\z
  --   The most typical case is: when hovering a window, Dear ImGui set io.WantCaptureMouse to true, \z
  --   and underlying application should ignore mouse inputs (in practice there are many and more subtle \z
  --   rules leading to how those flags are set).');
  -- if outputs_opened then
  --   ImGui.Text('io.WantCaptureMouse: %d', io.WantCaptureMouse);
  --   ImGui.Text('io.WantCaptureMouseUnlessPopupClose: %d', io.WantCaptureMouseUnlessPopupClose);
  --   ImGui.Text('io.WantCaptureKeyboard: %d', io.WantCaptureKeyboard);
  --   ImGui.Text('io.WantTextInput: %d', io.WantTextInput);
  --   ImGui.Text('io.WantSetMousePos: %d', io.WantSetMousePos);
  --   ImGui.Text('io.NavActive: %d, io.NavVisible: %d', io.NavActive, io.NavVisible);

    if ImGui.TreeNode(ctx, 'WantCapture override') then
      if not misc.capture_override then
        misc.capture_override = {mouse = -1, keyboard = -1}
      end

      demo.HelpMarker(
        -- "Hovering the colored canvas will override io.WantCaptureXXX fields.\n\z
        --  Notice how normally (when set to none), the value of io.WantCaptureKeyboard would be false when hovering \n
        --  and true when clicking."
        "SetNextFrameWantCaptureXXX instructs ReaImGui how to route inputs.\n\n\z
        Capturing the keyboard allows receiving input from REAPER's global scope.\n\n\z
        Hovering the colored canvas will call SetNextFrameWantCaptureXXX.")

      local capture_override_desc = {'None', 'Set to false', 'Set to true'}
      -- ImGui.SetNextItemWidth(ctx, ImGui.GetFontSize(ctx) * 15)
      -- rv,misc.capture_override.mouse = ImGui.SliderInt(ctx, 'SetNextFrameWantCaptureMouse() on hover', misc.capture_override.mouse, -1, 1, capture_override_desc[misc.capture_override.mouse + 2], ImGui.SliderFlags_AlwaysClamp)
      ImGui.SetNextItemWidth(ctx, ImGui.GetFontSize(ctx) * 15)
      rv,misc.capture_override.keyboard = ImGui.SliderInt(ctx, 'SetNextFrameWantCaptureKeyboard() on hover', misc.capture_override.keyboard, -1, 1, capture_override_desc[misc.capture_override.keyboard + 2], ImGui.SliderFlags_AlwaysClamp)

      ImGui.ColorButton(ctx, '##panel', 0xb219b2ff, ImGui.ColorEditFlags_NoTooltip | ImGui.ColorEditFlags_NoDragDrop, 128, 96) -- Dummy item
      -- if ImGui.IsItemHovered(ctx) and misc.capture_override.mouse ~= -1 then
      --   ImGui.SetNextFrameWantCaptureMouse(ctx, misc.capture_override.mouse == 1)
      -- end
      if ImGui.IsItemHovered(ctx) and misc.capture_override.keyboard ~= -1 then
        ImGui.SetNextFrameWantCaptureKeyboard(ctx, misc.capture_override.keyboard == 1)
      end

      ImGui.TreePop(ctx)
    end

  --   ImGui.TreePop(ctx)
  -- end

  -- Demonstrate using Shortcut() and Routing Policies.
  -- The general flow is:
  -- - Code interested in a chord (e.g. "Ctrl+A") declares their intent.
  -- - Multiple locations may be interested in same chord! Routing helps find a winner.
  -- - Every frame, we resolve all claims and assign one owner if the modifiers are matching.
  -- - The lower-level function is 'bool SetShortcutRouting()', returns true when caller got the route.
  -- - Most of the times, SetShortcutRouting() is not called directly. User mostly calls Shortcut() with routing flags.
  -- - If you call Shortcut() WITHOUT any routing option, it uses InputFlags_RouteFocused.
  -- TL;DR: Most uses will simply be:
  -- - Shortcut(Mod_Ctrl | Key_A); // Use InputFlags_RouteFocused policy.
  if ImGui.TreeNode(ctx, 'Shortcuts') then
    if not misc.shortcuts then
      misc.shortcuts = {
        route_options = ImGui.InputFlags_Repeat,
        route_type    = ImGui.InputFlags_RouteFocused,
        factor = 0.5,
      }
    end

    rv, misc.shortcuts.route_options = ImGui.CheckboxFlags(ctx, 'InputFlags_Repeat', misc.shortcuts.route_options, ImGui.InputFlags_Repeat)
    rv, misc.shortcuts.route_type = ImGui.RadioButtonEx(ctx, 'InputFlags_RouteActive', misc.shortcuts.route_type, ImGui.InputFlags_RouteActive)
    rv, misc.shortcuts.route_type = ImGui.RadioButtonEx(ctx, 'InputFlags_RouteFocused (default)', misc.shortcuts.route_type, ImGui.InputFlags_RouteFocused)
    rv, misc.shortcuts.route_type = ImGui.RadioButtonEx(ctx, 'InputFlags_RouteGlobal', misc.shortcuts.route_type, ImGui.InputFlags_RouteGlobal)
    ImGui.Indent(ctx)
    ImGui.BeginDisabled(ctx, misc.shortcuts.route_type ~= ImGui.InputFlags_RouteGlobal)
    rv, misc.shortcuts.route_options = ImGui.CheckboxFlags(ctx, 'InputFlags_RouteOverFocused',     misc.shortcuts.route_options, ImGui.InputFlags_RouteOverFocused)
    rv, misc.shortcuts.route_options = ImGui.CheckboxFlags(ctx, 'InputFlags_RouteOverActive',      misc.shortcuts.route_options, ImGui.InputFlags_RouteOverActive)
    rv, misc.shortcuts.route_options = ImGui.CheckboxFlags(ctx, 'InputFlags_RouteUnlessBgFocused', misc.shortcuts.route_options, ImGui.InputFlags_RouteUnlessBgFocused)
    ImGui.EndDisabled(ctx)
    ImGui.Unindent(ctx)
    rv, misc.shortcuts.route_type = ImGui.RadioButtonEx(ctx, 'InputFlags_RouteAlways', misc.shortcuts.route_type, ImGui.InputFlags_RouteAlways)
    local flags = misc.shortcuts.route_type | misc.shortcuts.route_options -- Merged flags
    if misc.shortcuts.route_type ~= ImGui.InputFlags_RouteGlobal then
      flags = flags & ~(ImGui.InputFlags_RouteOverFocused | ImGui.InputFlags_RouteOverActive | ImGui.InputFlags_RouteUnlessBgFocused)
    end

    ImGui.SeparatorText(ctx, 'Using SetNextItemShortcut()')
    ImGui.Text(ctx, 'Ctrl+S')
    ImGui.SetNextItemShortcut(ctx, ImGui.Mod_Ctrl | ImGui.Key_S, flags | ImGui.InputFlags_Tooltip)
    ImGui.Button(ctx, 'Save')
    ImGui.Text(ctx, 'Alt+F')
    ImGui.SetNextItemShortcut(ctx, ImGui.Mod_Alt | ImGui.Key_F, flags | ImGui.InputFlags_Tooltip)
    rv, misc.shortcuts.factor = ImGui.SliderDouble(ctx, 'Factor', misc.shortcuts.factor, 0.0, 1.0)

    ImGui.SeparatorText(ctx, 'Using Shortcut()')
    local line_height = ImGui.GetTextLineHeightWithSpacing(ctx)
    local key_chord = ImGui.Mod_Ctrl | ImGui.Key_A

    ImGui.Text(ctx, 'Ctrl+A')
    ImGui.Text(ctx, ('IsWindowFocused: %s, Shortcut: %s'):format(ImGui.IsWindowFocused(ctx), ImGui.Shortcut(ctx, key_chord, flags) and 'PRESSED' or '...'))

    ImGui.PushStyleColor(ctx, ImGui.Col_ChildBg, 0xff00ff20)

    if ImGui.BeginChild(ctx, 'WindowA', -FLT_MIN, line_height * 14, ImGui.ChildFlags_Borders) then
      ImGui.Text(ctx, 'Press Ctrl+A and see who receives it!')
      ImGui.Separator(ctx)

      -- 1: Window polling for Ctrl+A
      ImGui.Text(ctx, '(in WindowA)')
      ImGui.Text(ctx, ('IsWindowFocused: %s, Shortcut: %s'):format(ImGui.IsWindowFocused(ctx), ImGui.Shortcut(ctx, key_chord, flags) and 'PRESSED' or '...'))

      -- 2: InputText also polling for Ctrl+A: it always uses _RouteFocused internally (gets priority when active)
      -- (Commented because the owner-aware version of Shortcut() is still in imgui_internal.h)
      --local str = 'Press Ctrl+A'
      --ImGui.Spacing(ctx)
      --ImGui.InputText(ctx, 'InputTextB', str, ImGui.InputTextFlags_ReadOnly)
      --local item_id = ImGui.GetItemID(ctx)
      --ImGui.SameLine(ctx); demo.HelpMarker('Internal widgets always use _RouteFocused')
      --ImGui.Text(ctx, ('IsWindowFocused: %s, Shortcut: %s'):format(ImGui.IsWindowFocused(ctx), ImGui.Shortcut(ctx, key_chord, flags, item_id) and 'PRESSED' or '...'))

      -- 3: Dummy child is not claiming the route: focusing them shouldn't steal route away from WindowA
      if ImGui.BeginChild(ctx, 'ChildD', -FLT_MIN, line_height * 4, ImGui.ChildFlags_Borders) then
        ImGui.Text(ctx, '(in ChildD: not using same Shortcut)')
        ImGui.Text(ctx, ('IsWindowFocused: %s'):format(ImGui.IsWindowFocused(ctx)))
        ImGui.EndChild(ctx)
      end

      -- 4: Child window polling for Ctrl+A. It is deeper than WindowA and gets priority when focused.
      if ImGui.BeginChild(ctx, 'ChildE', -FLT_MIN, line_height * 4, ImGui.ChildFlags_Borders) then
        ImGui.Text(ctx, '(in ChildE: using same Shortcut)')
        ImGui.Text(ctx, ('IsWindowFocused: %s, Shortcut: %s'):format(ImGui.IsWindowFocused(ctx), ImGui.Shortcut(ctx, key_chord, flags) and 'PRESSED' or '...'))
        ImGui.EndChild(ctx)
      end

      -- 5: In a popup
      if ImGui.Button(ctx, 'Open Popup') then
        ImGui.OpenPopup(ctx, 'PopupF')
      end
      if ImGui.BeginPopup(ctx, 'PopupF') then
        ImGui.Text(ctx, '(in PopupF)')
        ImGui.Text(ctx, ('IsWindowFocused: %s, Shortcut: %s'):format(ImGui.IsWindowFocused(ctx), ImGui.Shortcut(ctx, key_chord, flags) and 'PRESSED' or '...'))
        -- (Commented because the owner-aware version of Shortcut() is still in imgui_internal.h)
        --ImGui.InputText(ctx, 'InputTextG', str, ImGui.InputTextFlags_ReadOnly)
        --ImGui.Text(ctx, ('IsWindowFocused: %s, Shortcut: %s'):format(ImGui.IsWindowFocused(ctx), ImGui.Shortcut(ctx, key_chord, flags, ImGui.GetItemID(ctx)) and 'PRESSED' or '...'))
        ImGui.EndPopup(ctx)
      end

      ImGui.EndChild(ctx)
    end

    ImGui.PopStyleColor(ctx)
    ImGui.TreePop(ctx)
  end

  -- Display mouse cursors
  if ImGui.TreeNode(ctx, 'Mouse Cursors') then
    local current = ImGui.GetMouseCursor(ctx)
    local current_name = 'N/A'
    for cursor, name in demo.EachEnum('MouseCursor') do
      if cursor == current then
        current_name = name
        break
      end
    end
    ImGui.Text(ctx, ('Current mouse cursor = %d: %s'):format(current, current_name))
    ImGui.Text(ctx, 'Hover to see mouse cursors:')
    -- ImGui.SameLine(ctx); demo.HelpMarker(
    --   'Your application can render a different mouse cursor based on what ImGui.GetMouseCursor() returns. \z
    --    If software cursor rendering (io.MouseDrawCursor) is set ImGui will draw the right cursor for you, \z
    --    otherwise your backend needs to handle it.')
    for i, name in demo.EachEnum('MouseCursor') do
      local label = ('Mouse cursor %d: %s'):format(i, name)
      ImGui.Bullet(ctx); ImGui.Selectable(ctx, label, false)
      if ImGui.IsItemHovered(ctx) then
        ImGui.SetMouseCursor(ctx, i)
      end
    end
    ImGui.TreePop(ctx)
  end

  if ImGui.TreeNode(ctx, 'Tabbing') then
    if not misc.tabbing then
      misc.tabbing = {
        buf = 'hello',
      }
    end

    ImGui.Text(ctx, 'Use TAB/Shift+TAB to cycle through keyboard editable fields.')
    rv,misc.tabbing.buf = ImGui.InputText(ctx, '1', misc.tabbing.buf)
    rv,misc.tabbing.buf = ImGui.InputText(ctx, '2', misc.tabbing.buf)
    rv,misc.tabbing.buf = ImGui.InputText(ctx, '3', misc.tabbing.buf)
    ImGui.PushItemFlag(ctx, ImGui.ItemFlags_NoTabStop, true)
    rv,misc.tabbing.buf = ImGui.InputText(ctx, '4 (tab skip)', misc.tabbing.buf)
    ImGui.SameLine(ctx); demo.HelpMarker("Item won't be cycled through when using TAB or Shift+Tab.")
    ImGui.PopItemFlag(ctx)
    rv,misc.tabbing.buf = ImGui.InputText(ctx, '5', misc.tabbing.buf)
    ImGui.TreePop(ctx)
  end

  if ImGui.TreeNode(ctx, 'Focus from code') then
    if not misc.focus then
      misc.focus = {
        buf = 'click on a button to set focus',
        d3  = {0.0, 0.0, 0.0}
      }
    end

    local focus_1 = ImGui.Button(ctx, 'Focus on 1'); ImGui.SameLine(ctx)
    local focus_2 = ImGui.Button(ctx, 'Focus on 2'); ImGui.SameLine(ctx)
    local focus_3 = ImGui.Button(ctx, 'Focus on 3')
    local has_focus = 0

    if focus_1 then ImGui.SetKeyboardFocusHere(ctx) end
    rv,misc.focus.buf = ImGui.InputText(ctx, '1', misc.focus.buf)
    if ImGui.IsItemActive(ctx) then has_focus = 1 end

    if focus_2 then ImGui.SetKeyboardFocusHere(ctx) end
    rv,misc.focus.buf = ImGui.InputText(ctx, '2', misc.focus.buf)
    if ImGui.IsItemActive(ctx) then has_focus = 2 end

    ImGui.PushItemFlag(ctx, ImGui.ItemFlags_NoTabStop, true)
    if focus_3 then ImGui.SetKeyboardFocusHere(ctx) end
    rv,misc.focus.buf = ImGui.InputText(ctx, '3 (tab skip)', misc.focus.buf)
    if ImGui.IsItemActive(ctx) then has_focus = 3 end
    ImGui.SameLine(ctx); demo.HelpMarker("Item won't be cycled through when using TAB or Shift+Tab.")
    ImGui.PopItemFlag(ctx)

    if has_focus > 0 then
      ImGui.Text(ctx, ('Item with focus: %d'):format(has_focus))
    else
      ImGui.Text(ctx, 'Item with focus: <none>')
    end

    -- Use >= 0 parameter to SetKeyboardFocusHere() to focus an upcoming item
    local focus_ahead = -1
    if ImGui.Button(ctx, 'Focus on X') then focus_ahead = 0 end ImGui.SameLine(ctx)
    if ImGui.Button(ctx, 'Focus on Y') then focus_ahead = 1 end ImGui.SameLine(ctx)
    if ImGui.Button(ctx, 'Focus on Z') then focus_ahead = 2 end
    if focus_ahead ~= -1 then ImGui.SetKeyboardFocusHere(ctx, focus_ahead) end
    rv,misc.focus.d3[1],misc.focus.d3[2],misc.focus.d3[3] =
      ImGui.SliderDouble3(ctx, 'Double3', misc.focus.d3[1], misc.focus.d3[2], misc.focus.d3[3], 0.0, 1.0)

    ImGui.TextWrapped(ctx, 'NB: Cursor & selection are preserved when refocusing last used item in code.')
    ImGui.TreePop(ctx)
  end

  if ImGui.TreeNode(ctx, 'Dragging') then
    ImGui.TextWrapped(ctx, 'You can use GetMouseDragDelta(0) to query for the dragged amount on any widget.')
    for button = 0, 2 do
      ImGui.Text(ctx, ('IsMouseDragging(%d):'):format(button))
      ImGui.Text(ctx, ('  w/ default threshold: %s,'):format(ImGui.IsMouseDragging(ctx, button)))
      ImGui.Text(ctx, ('  w/ zero threshold: %s,'):format(ImGui.IsMouseDragging(ctx, button, 0.0)))
      ImGui.Text(ctx, ('  w/ large threshold: %s,'):format(ImGui.IsMouseDragging(ctx, button, 20.0)))
    end

    ImGui.Button(ctx, 'Drag Me')
    if ImGui.IsItemActive(ctx) then
      -- Draw a line between the button and the mouse cursor
      local draw_list = ImGui.GetForegroundDrawList(ctx)
      local mouse_pos_x, mouse_pos_y = ImGui.GetMousePos(ctx)
      local click_pos_x, click_pos_y = ImGui.GetMouseClickedPos(ctx, 0)
      local color = ImGui.GetColor(ctx, ImGui.Col_Button)
      ImGui.DrawList_AddLine(draw_list, click_pos_x, click_pos_y, mouse_pos_x, mouse_pos_y, color, 4.0)
    end

    -- Drag operations gets "unlocked" when the mouse has moved past a certain threshold
    -- (the default threshold is stored in io.MouseDragThreshold). You can request a lower or higher
    -- threshold using the second parameter of IsMouseDragging() and GetMouseDragDelta().
    local value_raw_x, value_raw_y = ImGui.GetMouseDragDelta(ctx, nil, nil, ImGui.MouseButton_Left, 0.0)
    local value_with_lock_threshold_x, value_with_lock_threshold_y = ImGui.GetMouseDragDelta(ctx, nil, nil, ImGui.MouseButton_Left)
    local mouse_delta_x, mouse_delta_y = ImGui.GetMouseDelta(ctx)
    ImGui.Text(ctx, 'GetMouseDragDelta(0):')
    ImGui.Text(ctx, ('  w/ default threshold: (%.1f, %.1f)'):format(value_with_lock_threshold_x, value_with_lock_threshold_y))
    ImGui.Text(ctx, ('  w/ zero threshold: (%.1f, %.1f)'):format(value_raw_x, value_raw_y))
    ImGui.Text(ctx, ('GetMouseDelta() (%.1f, %.1f)'):format(mouse_delta_x, mouse_delta_y))
    ImGui.TreePop(ctx)
  end
end

