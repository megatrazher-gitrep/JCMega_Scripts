--========================================================
-- @description JCMega Snapshot Manager
-- @version 1.0.0
-- @author JC MediaFX / MegaTrazher
-- @about
--   Create, store and recall project snapshots.
--   Designed to speed up workflow by saving track,
--   mixer and project states for quick comparison
--   and session management.
-- @changelog
--   Initial release.
--========================================================

local r = reaper
local ctx = r.ImGui_CreateContext("JCMega_Snapshot Manager")
local EXT = "JC_SNAPSHOT_MANAGER"

local C = {
  bg         = 0x0F0F1AFF,
  frame      = 0x1A1A2EFF,
  border     = 0x2A2A48FF,
  btn        = 0x3B2870FF,
  btn_hov    = 0x553D96FF,
  btn_act    = 0x271A50FF,
  title_bg   = 0x1A1A2EFF,
  title_act  = 0x3B2870FF,
  success    = 0x059669FF,
  suc_hov    = 0x10B981FF,
  suc_act    = 0x065F46FF,
  danger     = 0xDC2626FF,
  dan_hov    = 0xEF4444FF,
  dan_act    = 0x991B1BFF,
  warning    = 0xD97706FF,
  war_hov    = 0xF59E0BFF,
  war_act    = 0x92400EFF,
  active     = 0x10B981FF,
  accent     = 0xA78BFAFF,
  text       = 0xF1F5F9FF,
  subtext    = 0x94A3B8FF,
  header     = 0xC4B5FDFF,
  separator  = 0x2A2A48FF,
  combo_bg   = 0x1E1E32FF,
}

------------------------------------------------------------
-- ESTADO
------------------------------------------------------------
local snapshots        = {}
local selected         = 1
local snap_name        = "Mix Snapshot"
local active_snap      = 0
local confirm_delete   = false
local status_msg       = ""
local status_timer     = 0
local status_ok        = true


local STYLE_COLORS = 16
local STYLE_VARS   = 5

local function PushStyle()
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_WindowBg(),           C.bg)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ChildBg(),            C.frame)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_FrameBg(),            C.frame)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_FrameBgHovered(),     C.border)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_FrameBgActive(),      C.border)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(),             C.btn)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(),      C.btn_hov)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(),       C.btn_act)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Header(),             C.btn)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_HeaderHovered(),      C.btn_hov)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_HeaderActive(),       C.btn_act)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(),               C.text)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Separator(),          C.separator)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_PopupBg(),            C.frame)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_TitleBg(),            C.title_bg)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_TitleBgActive(),      C.title_act)

  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowRounding(),  8)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_FrameRounding(),   5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_GrabRounding(),    4)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(),     8, 6)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(),   14, 12)
end

local function PopStyle()
  r.ImGui_PopStyleColor(ctx, STYLE_COLORS)
  r.ImGui_PopStyleVar(ctx,   STYLE_VARS)
end

------------------------------------------------------------
-- STATUS BAR
------------------------------------------------------------
local function SetStatus(msg, is_ok, duration)
  status_msg   = msg
  status_ok    = (is_ok ~= false)
  status_timer = r.time_precise() + (duration or 3.5)
end

------------------------------------------------------------
-- BOTÓN DE COLOR PERSONALIZADO
------------------------------------------------------------
local function CBtn(label, c, ch, ca, w, h)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(),        c)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), ch)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(),  ca)
  local clicked = r.ImGui_Button(ctx, label, w or 0, h or 28)
  r.ImGui_PopStyleColor(ctx, 3)
  return clicked
end

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function TrackName(tr)
  if not tr then return "?" end
  local _, n = r.GetTrackName(tr)
  return (n and n ~= "") and n or "Unnamed Track"
end

local function CaptureSnapshot()
  local data  = {}
  local total = r.CountTracks(0)
  for i = 0, total - 1 do
    local tr  = r.GetTrack(0, i)
    local fxc = r.TrackFX_GetCount(tr)
    local fx  = {}
    for f = 0, fxc - 1 do
      fx[f + 1] = r.TrackFX_GetEnabled(tr, f)
    end
    data[#data + 1] = {
      guid = r.GetTrackGUID(tr),
      name = TrackName(tr),
      vol  = r.GetMediaTrackInfo_Value(tr, "D_VOL"),
      pan  = r.GetMediaTrackInfo_Value(tr, "D_PAN"),
      mute = r.GetMediaTrackInfo_Value(tr, "B_MUTE"),
      solo = r.GetMediaTrackInfo_Value(tr, "I_SOLO"),
      fx   = fx,
    }
  end
  return data
end

local function FindByGUID(guid)
  for i = 0, r.CountTracks(0) - 1 do
    local tr = r.GetTrack(0, i)
    if r.GetTrackGUID(tr) == guid then return tr end
  end
  return nil
end

------------------------------------------------------------
-- PERSISTENCIA
------------------------------------------------------------
local function Save()
  local names = ""
  for i = 1, #snapshots do
    names = names .. snapshots[i].name .. "\n"
  end
  r.SetProjExtState(0, EXT, "names",  names)
  r.SetProjExtState(0, EXT, "active", tostring(active_snap))

  for i = 1, #snapshots do
    local rows = {}
    for _, it in ipairs(snapshots[i].data) do
      local fxs = {}
      for fi, fv in ipairs(it.fx) do
        fxs[fi] = fv and "1" or "0"
      end
      rows[#rows + 1] = table.concat({
        it.guid,
        it.name:gsub("|","_"),
        string.format("%.6f", it.vol),
        string.format("%.6f", it.pan),
        string.format("%.0f", it.mute),
        string.format("%.0f", it.solo),
        table.concat(fxs, ","),
      }, "|")
    end
    r.SetProjExtState(0, EXT, "data_"..i, table.concat(rows, "\n"))
  end

  for i = #snapshots + 1, #snapshots + 20 do
    local ok, _ = r.GetProjExtState(0, EXT, "data_"..i)
    if ok > 0 then r.SetProjExtState(0, EXT, "data_"..i, "")
    else break end
  end
end

local function Load()
  local ok, str = r.GetProjExtState(0, EXT, "names")
  if ok == 0 or str == "" then return end

  local names = {}
  for line in str:gmatch("([^\n]+)") do names[#names + 1] = line end

  for i, nm in ipairs(names) do
    local snap = { name = nm, data = {} }
    local ok2, dstr = r.GetProjExtState(0, EXT, "data_"..i)
    if ok2 > 0 and dstr ~= "" then
      for line in dstr:gmatch("([^\n]+)") do
        local p = {}
        for part in line:gmatch("([^|]+)") do p[#p+1] = part end
        if #p >= 6 then
          local fx = {}
          if p[7] then
            for v in p[7]:gmatch("([^,]+)") do
              fx[#fx+1] = (v == "1")
            end
          end
          snap.data[#snap.data+1] = {
            guid = p[1], name = p[2],
            vol  = tonumber(p[3]) or 1,
            pan  = tonumber(p[4]) or 0,
            mute = tonumber(p[5]) or 0,
            solo = tonumber(p[6]) or 0,
            fx   = fx,
          }
        end
      end
    else
      snap.data = CaptureSnapshot()
    end
    snapshots[#snapshots+1] = snap
  end

  local _, act = r.GetProjExtState(0, EXT, "active")
  active_snap = tonumber(act) or 0
end

------------------------------------------------------------
-- APPLY
------------------------------------------------------------
local function ApplySnapshot(snap)
  if not snap then return end
  r.Undo_BeginBlock()
  for _, it in ipairs(snap.data) do
    local tr = FindByGUID(it.guid)
    if tr then
      r.SetMediaTrackInfo_Value(tr, "D_VOL",  it.vol)
      r.SetMediaTrackInfo_Value(tr, "D_PAN",  it.pan)
      r.SetMediaTrackInfo_Value(tr, "B_MUTE", it.mute)
      r.SetMediaTrackInfo_Value(tr, "I_SOLO", it.solo)
      local fxc = r.TrackFX_GetCount(tr)
      for f = 0, math.min(fxc - 1, #it.fx - 1) do
        r.TrackFX_SetEnabled(tr, f, it.fx[f + 1])
      end
    end
  end
  r.TrackList_AdjustWindows(false)
  r.UpdateArrange()
  r.Undo_EndBlock("JC Snapshot: load '" .. snap.name .. "'", -1)
end

------------------------------------------------------------
-- ACCIONES
------------------------------------------------------------
local function DoSave()
  if snap_name == "" then
    SetStatus("✗ Name cannot be empty", false)
    return
  end
  snapshots[#snapshots+1] = { name = snap_name, data = CaptureSnapshot() }
  selected = #snapshots
  Save()
  SetStatus("✓  Snapshot saved: " .. snap_name, true)
end

local function DoReplace()
  if not snapshots[selected] then return end
  local nm = snapshots[selected].name
  snapshots[selected] = { name = nm, data = CaptureSnapshot() }
  if active_snap == selected then active_snap = 0 end
  Save()
  SetStatus("↺  Snapshot updated: " .. nm, true)
end

local function DoDelete()
  if not snapshots[selected] then return end
  local nm = snapshots[selected].name
  table.remove(snapshots, selected)
  if     active_snap == selected              then active_snap = 0
  elseif active_snap  > selected              then active_snap = active_snap - 1 end
  selected      = math.max(1, math.min(selected, #snapshots))
  confirm_delete = false
  Save()
  SetStatus("✗  Deleted: " .. nm, false)
end

local function DoLoad()
  if not snapshots[selected] then return end
  ApplySnapshot(snapshots[selected])
  active_snap = selected
  Save()
  SetStatus("▶  Loaded: " .. snapshots[selected].name, true)
end

local function MoveSnap(dir)
  local ni = selected + dir
  if ni < 1 or ni > #snapshots then return end
  snapshots[selected], snapshots[ni] = snapshots[ni], snapshots[selected]
  if active_snap == selected then active_snap = ni
  elseif active_snap == ni   then active_snap = selected end
  selected = ni
  Save()
end

------------------------------------------------------------
-- INIT
------------------------------------------------------------
Load()

------------------------------------------------------------
-- LOOP
------------------------------------------------------------
local function loop()
  PushStyle()
  r.ImGui_SetNextWindowSize(ctx, 310, 0, r.ImGui_Cond_FirstUseEver())

  local visible, open = r.ImGui_Begin(
    ctx, "  JCMega_Snapshot Manager", true,
    r.ImGui_WindowFlags_AlwaysAutoResize()
  )

  if visible then

    r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.header)
    r.ImGui_Text(ctx, "JCMega_Snapshot Manager")
    r.ImGui_PopStyleColor(ctx, 1)
    r.ImGui_Separator(ctx)
    r.ImGui_Dummy(ctx, 0, 4)

    r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.subtext)
    r.ImGui_Text(ctx, "Name:")
    r.ImGui_PopStyleColor(ctx, 1)

    r.ImGui_SetNextItemWidth(ctx, 206)
    local _, new_name = r.ImGui_InputText(ctx, "##sname", snap_name)
    snap_name = new_name

    r.ImGui_SameLine(ctx)
    if CBtn("+ New", C.success, C.suc_hov, C.suc_act, 82, 0) then
      DoSave()
    end

    r.ImGui_Dummy(ctx, 0, 6)
    r.ImGui_Separator(ctx)
    r.ImGui_Dummy(ctx, 0, 4)

    r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.subtext)
    r.ImGui_Text(ctx, string.format("Saved snapshots: %d", #snapshots))
    r.ImGui_PopStyleColor(ctx, 1)

    if #snapshots == 0 then
      r.ImGui_Dummy(ctx, 0, 8)
      r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.subtext)
      r.ImGui_Text(ctx, "  No snapshots yet.")
      r.ImGui_PopStyleColor(ctx, 1)
    else
      r.ImGui_Dummy(ctx, 0, 4)

      local preview = snapshots[selected] and snapshots[selected].name or "Select"
      if selected == active_snap then preview = "● " .. preview end

      r.ImGui_SetNextItemWidth(ctx, 290)
      if r.ImGui_BeginCombo(ctx, "##list", preview) then
        for i = 1, #snapshots do
          local lbl = snapshots[i].name
          local is_active = (i == active_snap)
          if is_active then
            r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.active)
            lbl = "● " .. lbl
          end
          local clicked = r.ImGui_Selectable(ctx, lbl .. "##" .. i, i == selected)
          if is_active then r.ImGui_PopStyleColor(ctx, 1) end

          if r.ImGui_IsItemHovered(ctx) then
            r.ImGui_BeginTooltip(ctx)
            r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.subtext)
            r.ImGui_Text(ctx, string.format("Captured tracks: %d", #snapshots[i].data))
            r.ImGui_PopStyleColor(ctx, 1)
            r.ImGui_EndTooltip(ctx)
          end

          if clicked then
            selected  = i
            snap_name = snapshots[i].name
          end
        end
        r.ImGui_EndCombo(ctx)
      end

      r.ImGui_Dummy(ctx, 0, 6)

      if CBtn("▶  Load", C.accent, 0xBDA8FFFF, 0x7C5FCEFF, 143, 30) then
        DoLoad()
      end
      r.ImGui_SameLine(ctx)
      if CBtn("↺  Replace", C.warning, C.war_hov, C.war_act, 143, 30) then
        DoReplace()
      end

      r.ImGui_Dummy(ctx, 0, 2)

      if confirm_delete then
        r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.danger)
        r.ImGui_Text(ctx, "Confirm deletion?")
        r.ImGui_PopStyleColor(ctx, 1)
        if CBtn("Yes, delete", C.danger, C.dan_hov, C.dan_act, 143, 28) then
          DoDelete()
        end
        r.ImGui_SameLine(ctx)
        if r.ImGui_Button(ctx, "Cancel", 143, 28) then
          confirm_delete = false
        end
      else
        if r.ImGui_Button(ctx, "✕  Delete", 143, 28) then
          confirm_delete = true
        end
        r.ImGui_SameLine(ctx)
        if r.ImGui_Button(ctx, " ↑ ", 38, 28) then MoveSnap(-1) end
        r.ImGui_SameLine(ctx)
        if r.ImGui_Button(ctx, " ↓ ", 38, 28) then MoveSnap(1) end
        r.ImGui_SameLine(ctx)
        if r.ImGui_Button(ctx, " ⎘ ", 38, 28) then
          r.ImGui_SetClipboardText(ctx, snapshots[selected].name)
          SetStatus("Name copied to clipboard", true, 2)
        end
        if r.ImGui_IsItemHovered(ctx) then
          r.ImGui_SetTooltip(ctx, "Copy name to clipboard")
        end
      end
    end

    r.ImGui_Dummy(ctx, 0, 6)
    r.ImGui_Separator(ctx)
    r.ImGui_Dummy(ctx, 0, 2)

    if status_msg ~= "" and r.time_precise() < status_timer then
      r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(),
        status_ok and C.active or C.danger)
      r.ImGui_Text(ctx, status_msg)
      r.ImGui_PopStyleColor(ctx, 1)
    else
      r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), C.subtext)
      r.ImGui_Text(ctx, "JCMega_Snapshot Manager")
      r.ImGui_PopStyleColor(ctx, 1)
    end

    r.ImGui_End(ctx)
  end

  PopStyle()

  if open then
    r.defer(loop)
  else

  end
end

loop()
