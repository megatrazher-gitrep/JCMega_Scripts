-- @description JCMega GradienTracks
-- @author JC MediaFX
-- @about
--   Gradients on your tracks
-- @changelog
--   Initial release
--   Native REAPER Lua + gfx track color gradient tool.
--   Colors selected tracks from a start color to an end color and stores presets.
--   No ReaImGui, no external libraries.

local r = reaper

local SCRIPT_NAME = "GradienTracks"
local EXT_SECTION = "GradienTracks"
local LEGACY_EXT_SECTION = "JC_Selected_Track_Color_Gradient_PRO_gfx"
local WIN_W, WIN_H = 980, 640
local PRESET_COUNT = 8

local C = {
  bg = {0.150, 0.150, 0.150},
  top = {0.210, 0.210, 0.210},
  panel = {0.180, 0.180, 0.180},
  panel2 = {0.230, 0.230, 0.230},
  panel3 = {0.270, 0.270, 0.270},
  line = {0.420, 0.420, 0.420},
  text = {0.940, 0.940, 0.940},
  dim = {0.720, 0.720, 0.720},
  muted = {0.560, 0.560, 0.560},
  cyan = {0.300, 0.650, 1.000},
  cyan2 = {0.220, 0.520, 0.900},
  violet = {0.660, 0.520, 0.980},
  magenta = {0.880, 0.420, 0.560},
  amber = {1.000, 0.760, 0.260},
  red = {0.940, 0.340, 0.340},
  green = {0.340, 0.780, 0.340},
  blue = {0.320, 0.560, 0.980},
}

local DEFAULT_PRESETS = {
  {name = "Ocean", start_color = {0.180, 0.760, 0.900}, end_color = {0.250, 0.300, 0.980}},
  {name = "Sunset", start_color = {1.000, 0.360, 0.250}, end_color = {0.980, 0.720, 0.220}},
  {name = "Mint Vox", start_color = {0.220, 0.880, 0.720}, end_color = {0.540, 0.420, 0.960}},
  {name = "Drum Fire", start_color = {0.960, 0.300, 0.240}, end_color = {0.780, 0.180, 0.120}},
  {name = "Bass Lime", start_color = {0.580, 0.920, 0.280}, end_color = {0.940, 0.740, 0.220}},
  {name = "Soft Mix", start_color = {0.460, 0.620, 0.760}, end_color = {0.680, 0.540, 0.780}},
  {name = "Clean FX", start_color = {0.220, 0.700, 1.000}, end_color = {0.200, 0.920, 0.820}},
  {name = "Custom", start_color = {0.220, 0.760, 0.900}, end_color = {0.580, 0.440, 0.980}},
}

local state = {
  start_color = {0.220, 0.760, 0.900},
  end_color = {0.580, 0.440, 0.980},
  selected_preset = 1,
  presets = {},
  status = "Select tracks and click Apply.",
  window_x = 120,
  window_y = 120,
}

local ui = {
  mouse_down = false,
  prev_mouse_down = false,
  drag_slider = nil,
}

local function clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function copy_color(c)
  return {c[1], c[2], c[3]}
end

local function setc(c, alpha)
  gfx.set(c[1], c[2], c[3], 1)
end

local function fill_rect(x, y, w, h, c, alpha)
  setc(c, alpha)
  gfx.rect(x, y, w, h, 1)
end

local function stroke_rect(x, y, w, h, c, alpha)
  setc(c, alpha)
  gfx.rect(x, y, w, h, 0)
end

local function line(x1, y1, x2, y2, c, alpha)
  setc(c, alpha)
  gfx.line(x1, y1, x2, y2)
end

local function fill_round_rect(x, y, w, h, radius, c, alpha)
  fill_rect(x, y, w, h, c, 1)
end

local function stroke_round_rect(x, y, w, h, radius, c, alpha)
  stroke_rect(x, y, w, h, c, 1)
end

local function set_font(size)
  gfx.setfont(1, "Segoe UI", size or 14)
end

local function text(x, y, value, c)
  setc(c or C.text)
  gfx.x, gfx.y = x, y
  gfx.drawstr(tostring(value or ""))
end

local function fitted_text(value, max_w)
  local s = tostring(value or "")
  if gfx.measurestr(s) <= max_w then return s end
  while #s > 3 and gfx.measurestr(s .. "...") > max_w do
    s = s:sub(1, #s - 1)
  end
  return s .. "..."
end

local function inside(x, y, w, h)
  return gfx.mouse_x >= x and gfx.mouse_x <= x + w and gfx.mouse_y >= y and gfx.mouse_y <= y + h
end

local function mouse_left()
  return gfx.mouse_cap % 2 == 1
end

local function clicked(x, y, w, h)
  return inside(x, y, w, h) and ui.mouse_down and not ui.prev_mouse_down
end

local function blend(a, b, t)
  return {
    a[1] + (b[1] - a[1]) * t,
    a[2] + (b[2] - a[2]) * t,
    a[3] + (b[3] - a[3]) * t,
  }
end

local function color_to_csv(c)
  return string.format("%.3f,%.3f,%.3f", c[1], c[2], c[3])
end

local function csv_to_color(value, fallback)
  local r1, g1, b1 = tostring(value or ""):match("([%d%.]+),([%d%.]+),([%d%.]+)")
  if not r1 then return copy_color(fallback) end
  return {
    clamp(tonumber(r1) or fallback[1], 0, 1),
    clamp(tonumber(g1) or fallback[2], 0, 1),
    clamp(tonumber(b1) or fallback[3], 0, 1),
  }
end

local function color_to_native(c)
  return r.ColorToNative(
    math.floor(clamp(c[1], 0, 1) * 255 + 0.5),
    math.floor(clamp(c[2], 0, 1) * 255 + 0.5),
    math.floor(clamp(c[3], 0, 1) * 255 + 0.5)
  ) + 16777216
end

local function track_color_to_rgb(track, fallback)
  local native = r.GetTrackColor(track)
  if not native or native == 0 then return copy_color(fallback) end
  if native >= 16777216 then native = native - 16777216 end
  local rr, gg, bb = r.ColorFromNative(native)
  return {
    clamp((rr or 0) / 255, 0, 1),
    clamp((gg or 0) / 255, 0, 1),
    clamp((bb or 0) / 255, 0, 1),
  }
end

local function preset_to_string(preset)
  return table.concat({
    preset.name or "Preset",
    color_to_csv(preset.start_color),
    color_to_csv(preset.end_color),
  }, "|")
end

local function string_to_preset(value, fallback)
  local name, start_csv, end_csv = tostring(value or ""):match("([^|]*)|([^|]*)|([^|]*)")
  if not name then
    return {
      name = fallback.name,
      start_color = copy_color(fallback.start_color),
      end_color = copy_color(fallback.end_color),
    }
  end
  if name == "" then name = fallback.name end
  return {
    name = name,
    start_color = csv_to_color(start_csv, fallback.start_color),
    end_color = csv_to_color(end_csv, fallback.end_color),
  }
end

local function save_state()
  r.SetExtState(EXT_SECTION, "start_color", color_to_csv(state.start_color), true)
  r.SetExtState(EXT_SECTION, "end_color", color_to_csv(state.end_color), true)
  r.SetExtState(EXT_SECTION, "selected_preset", tostring(state.selected_preset), true)
  r.SetExtState(EXT_SECTION, "window_x", tostring(math.floor(state.window_x or 120)), true)
  r.SetExtState(EXT_SECTION, "window_y", tostring(math.floor(state.window_y or 120)), true)
  for i = 1, PRESET_COUNT do
    r.SetExtState(EXT_SECTION, "preset_" .. i, preset_to_string(state.presets[i]), true)
  end
end

local function get_saved_value(key)
  local value = r.GetExtState(EXT_SECTION, key)
  if value ~= "" then return value end
  return r.GetExtState(LEGACY_EXT_SECTION, key)
end

local function load_state()
  for i = 1, PRESET_COUNT do
    state.presets[i] = {
      name = DEFAULT_PRESETS[i].name,
      start_color = copy_color(DEFAULT_PRESETS[i].start_color),
      end_color = copy_color(DEFAULT_PRESETS[i].end_color),
    }
  end

  local value = get_saved_value("start_color")
  if value ~= "" then state.start_color = csv_to_color(value, state.start_color) end
  value = get_saved_value("end_color")
  if value ~= "" then state.end_color = csv_to_color(value, state.end_color) end
  value = get_saved_value("selected_preset")
  if value ~= "" then state.selected_preset = clamp(math.floor(tonumber(value) or 1), 1, PRESET_COUNT) end
  value = get_saved_value("window_x")
  if value ~= "" then state.window_x = math.floor(tonumber(value) or state.window_x) end
  value = get_saved_value("window_y")
  if value ~= "" then state.window_y = math.floor(tonumber(value) or state.window_y) end
  for i = 1, PRESET_COUNT do
    value = get_saved_value("preset_" .. i)
    if value ~= "" then state.presets[i] = string_to_preset(value, DEFAULT_PRESETS[i]) end
  end
end

local function update_window_position()
  local dock_state, x, y = gfx.dock(-1, 0, 0, 0, 0)
  if dock_state == 0 then
    state.window_x = math.floor(x or state.window_x or 120)
    state.window_y = math.floor(y or state.window_y or 120)
  end
end

local function selected_track_count()
  return r.CountSelectedTracks(0)
end

local function set_status(msg)
  state.status = msg
end

local function apply_gradient_to_selected()
  local count = selected_track_count()
  if count == 0 then
    set_status("Select one or more tracks before applying color.")
    return
  end

  r.Undo_BeginBlock()
  r.PreventUIRefresh(1)
  for i = 0, count - 1 do
    local tr = r.GetSelectedTrack(0, i)
    local t = count <= 1 and 0 or i / (count - 1)
    r.SetTrackColor(tr, color_to_native(blend(state.start_color, state.end_color, t)))
  end
  r.PreventUIRefresh(-1)
  r.TrackList_AdjustWindows(false)
  r.UpdateArrange()
  r.Undo_EndBlock("GradienTracks - apply selected track color gradient", -1)
  save_state()
  set_status("Applied gradient to " .. count .. " selected track(s).")
end

local function load_preset(index)
  local preset = state.presets[index]
  if not preset then return end
  state.selected_preset = index
  state.start_color = copy_color(preset.start_color)
  state.end_color = copy_color(preset.end_color)
  save_state()
  set_status("Preset loaded: " .. preset.name)
end

local function save_preset(index)
  local preset = state.presets[index]
  local name = preset and preset.name or ("Preset " .. index)
  state.presets[index] = {
    name = name,
    start_color = copy_color(state.start_color),
    end_color = copy_color(state.end_color),
  }
  state.selected_preset = index
  save_state()
  set_status("Preset saved: " .. name)
end

local function rename_preset(index)
  local preset = state.presets[index]
  if not preset then return end
  local current_name = preset.name or ("Preset " .. index)
  local ok, name = r.GetUserInputs("Rename preset", 1, "Name", current_name)
  if not ok then return end
  name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then name = "Preset " .. index end
  preset.name = name
  state.selected_preset = index
  save_state()
  set_status("Preset renamed: " .. name)
end

local function reset_current_colors()
  state.start_color = copy_color(DEFAULT_PRESETS[1].start_color)
  state.end_color = copy_color(DEFAULT_PRESETS[1].end_color)
  save_state()
  set_status("Colors reset.")
end

local function reset_presets()
  for i = 1, PRESET_COUNT do
    state.presets[i] = {
      name = DEFAULT_PRESETS[i].name,
      start_color = copy_color(DEFAULT_PRESETS[i].start_color),
      end_color = copy_color(DEFAULT_PRESETS[i].end_color),
    }
  end
  save_state()
  set_status("Presets reset.")
end

local function swap_colors()
  local temp = state.start_color
  state.start_color = state.end_color
  state.end_color = temp
  save_state()
  set_status("Colors swapped.")
end

local function capture_start_from_selection()
  local count = selected_track_count()
  if count == 0 then
    set_status("Select a track to capture the start color.")
    return
  end
  state.start_color = track_color_to_rgb(r.GetSelectedTrack(0, 0), state.start_color)
  save_state()
  set_status("Start color captured from the first selected track.")
end

local function capture_end_from_selection()
  local count = selected_track_count()
  if count == 0 then
    set_status("Select a track to capture the end color.")
    return
  end
  state.end_color = track_color_to_rgb(r.GetSelectedTrack(0, count - 1), state.end_color)
  save_state()
  set_status("End color captured from the last selected track.")
end

local function panel(x, y, w, h, title)
  fill_rect(x, y, w, h, C.panel, 1)
  stroke_rect(x, y, w, h, C.line, 1)
  if title then
    fill_rect(x + 1, y + 1, w - 2, 28, C.panel2, 1)
    line(x, y + 29, x + w, y + 29, C.line, 1)
    text(x + 12, y + 8, title, C.cyan)
  end
end

local function button(x, y, w, h, label, color, strong)
  local hot = inside(x, y, w, h)
  local accent = color or C.line
  fill_rect(x, y, w, h, hot and accent or C.panel3, 1)
  stroke_rect(x, y, w, h, hot and C.text or accent, 1)
  local shown = fitted_text(label, w - 18)
  local tw = gfx.measurestr(shown)
  text(x + math.max(9, (w - tw) * 0.5), y + math.floor((h - 13) * 0.5), shown, (hot or strong) and C.text or accent)
  return clicked(x, y, w, h)
end

local function pill(x, y, w, h, label, value, accent)
  fill_rect(x, y, w, h, C.panel3, 1)
  stroke_rect(x, y, w, h, accent or C.line, 1)
  text(x + 10, y + 9, label, accent or C.dim)
  local s = tostring(value)
  local tw = gfx.measurestr(s)
  text(x + w - tw - 10, y + 9, s, C.text)
end

local function draw_gradient(x, y, w, h, start_color, end_color, steps)
  steps = steps or 80
  for i = 0, steps - 1 do
    local t = steps <= 1 and 0 or i / (steps - 1)
    local c = blend(start_color, end_color, t)
    fill_rect(x + i * (w / steps), y, math.ceil(w / steps), h, c, 1)
  end
  stroke_round_rect(x, y, w, h, 8, C.line, 0.65)
end

local function swatch(x, y, w, h, color, label, accent)
  text(x, y, label, accent or C.text)
  fill_rect(x, y + 20, w, h, color, 1)
  stroke_rect(x, y + 20, w, h, C.text, 1)
end

local function slider(x, y, w, label, color_tbl, idx, scope)
  local id = tostring(scope or "") .. label .. idx
  local channel = idx == 1 and C.red or (idx == 2 and C.green or C.blue)
  text(x, y + 7, label, C.text)
  fill_rect(x + 34, y + 10, w, 10, C.bg, 1)
  stroke_rect(x + 34, y + 10, w, 10, C.line, 1)
  fill_rect(x + 34, y + 10, w * color_tbl[idx], 10, channel, 1)
  local knob_x = x + 34 + w * color_tbl[idx]
  fill_rect(knob_x - 5, y + 2, 10, 26, C.text, 1)
  stroke_rect(knob_x - 5, y + 2, 10, 26, C.bg, 1)
  local value = string.format("%03d", math.floor(color_tbl[idx] * 255 + 0.5))
  text(x + 48 + w, y + 7, value, C.dim)
  if clicked(x + 34, y - 2, w, 34) then ui.drag_slider = id end
  if ui.drag_slider == id and ui.mouse_down then
    color_tbl[idx] = clamp((gfx.mouse_x - (x + 34)) / w, 0, 1)
    save_state()
  end
end

local function draw_header()
  fill_rect(0, 0, gfx.w, 56, C.top)
  line(0, 55, gfx.w, 55, C.line, 1)
  set_font(24)
  text(18, 14, "GradienTracks", C.text)
  set_font(14)
  text(202, 22, "Track Gradient Tool", C.dim)
  pill(gfx.w - 206, 12, 188, 30, "Selected", selected_track_count(), C.cyan)
end

local function draw_presets()
  local x, y, w, h = 16, 72, 260, 492
  panel(x, y, w, h, "Presets")
  text(x + 12, y + 40, "Load, save, rename or reset presets.", C.dim)
  local row_y = y + 66
  for i = 1, PRESET_COUNT do
    local preset = state.presets[i]
    local active = state.selected_preset == i
    local ry = row_y + (i - 1) * 42
    local bg = active and C.cyan2 or C.panel3
    fill_rect(x + 12, ry, w - 24, 32, bg, 1)
    stroke_rect(x + 12, ry, w - 24, 32, active and C.cyan or C.line, 1)
    text(x + 24, ry + 9, string.format("%02d", i), active and C.text or C.dim)
    text(x + 62, ry + 9, fitted_text(preset.name, 168), C.text)
    if clicked(x + 12, ry, w - 24, 32) then
      state.selected_preset = i
      save_state()
      set_status("Active preset: " .. preset.name)
    end
  end
  if button(x + 12, y + 402, 76, 34, "Load", C.blue) then load_preset(state.selected_preset) end
  if button(x + 96, y + 402, 76, 34, "Save", C.cyan2) then save_preset(state.selected_preset) end
  if button(x + 180, y + 402, 68, 34, "Reset", C.magenta) then reset_presets() end
  if button(x + 12, y + 446, 236, 34, "Rename Preset", C.amber) then rename_preset(state.selected_preset) end
end

local function draw_editor()
  local x, y, w, h = 292, 72, 666, 492
  panel(x, y, w, h, "Color Editor")
  text(x + 12, y + 40, "Set start and end colors. Selection order defines the gradient.", C.dim)

  swatch(x + 24, y + 70, 92, 52, state.start_color, "Start Color", C.cyan)
  swatch(x + 370, y + 70, 92, 52, state.end_color, "End Color", C.violet)

  slider(x + 24, y + 166, 248, "R", state.start_color, 1, "start")
  slider(x + 24, y + 206, 248, "G", state.start_color, 2, "start")
  slider(x + 24, y + 246, 248, "B", state.start_color, 3, "start")

  slider(x + 370, y + 166, 248, "R", state.end_color, 1, "end")
  slider(x + 370, y + 206, 248, "G", state.end_color, 2, "end")
  slider(x + 370, y + 246, 248, "B", state.end_color, 3, "end")

  draw_gradient(x + 24, y + 322, w - 48, 36, state.start_color, state.end_color, 120)
  text(x + 24, y + 368, "Current gradient preview", C.dim)

  if button(x + 24, y + 404, 130, 38, "Swap", C.cyan2) then swap_colors() end
  if button(x + 166, y + 404, 150, 38, "Capture Start", C.blue) then capture_start_from_selection() end
  if button(x + 328, y + 404, 150, 38, "Capture End", C.violet) then capture_end_from_selection() end
  if button(x + 490, y + 404, 130, 38, "Reset", C.magenta) then reset_current_colors() end
  if button(x + 24, y + 452, 596, 42, "Apply to Selection", C.green, true) then apply_gradient_to_selected() end
end

local function draw_status()
  local x, y, w, h = 16, 578, 942, 38
  fill_rect(x, y, w, h, C.panel, 1)
  stroke_rect(x, y, w, h, C.line, 1)
  text(x + 12, y + 11, fitted_text(state.status, 820), C.amber)
  text(x + w - 40, y + 11, "Esc", C.muted)
end

local function draw()
  set_font(13)
  fill_rect(0, 0, gfx.w, gfx.h, C.bg)
  draw_header()
  draw_presets()
  draw_editor()
  draw_status()
end

local function main()
  ui.prev_mouse_down = ui.mouse_down
  ui.mouse_down = mouse_left()
  if not ui.mouse_down then ui.drag_slider = nil end
  update_window_position()

  local key = gfx.getchar()
  if key == 27 or key < 0 then
    save_state()
    return
  end

  draw()
  gfx.update()
  r.defer(main)
end

load_state()
gfx.init(SCRIPT_NAME, WIN_W, WIN_H, 0, state.window_x, state.window_y)
main()
