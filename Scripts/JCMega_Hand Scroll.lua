--========================================================
-- @description JCMega Hand Scroll
-- @version 1.0.0
-- @author JC MediaFX / MegaTrazher
-- @about
--   Interactive hand-scroll pad for REAPER.
--   Allows horizontal and vertical navigation by dragging
--   inside a dedicated control surface with configurable
--   mouse button assignments and wheel zoom support.
-- @changelog
--   Initial release.
--========================================================

local r = reaper

local c = {
  ModalWindowDimBg = 0xCCCCCC59,
  TabDimmedSelectedOverline = 0x80808000,
  HeaderActive = 0x636E88CC,
  NavWindowingDimBg = 0xCCCCCC33,
  NavCursor = 0x4296FAFF,
  DockingPreview = 0x4296FAB3,
  Header = 0x2F4769FF,
  CheckMark = 0x55A092FF,
  TableBorderStrong = 0x4F4F59FF,
  ScrollbarGrabHovered = 0x3B3B45FF,
  PopupBg = 0x151619FF,
  Tab = 0x1F221EDC,
  ButtonHovered = 0x03B287DA,
  TabSelected = 0x236941FF,
  HeaderHovered = 0x2F4769A9,
  ScrollbarGrabActive = 0x2F4769FF,
  TableHeaderBg = 0x303033FF,
  TableRowBg = 0x00000000,
  InputTextCursor = 0xFFFFFFFF,
  MenuBarBg = 0x2F2F2FFF,
  ResizeGripActive = 0x4296FAF2,
  TextSelectedBg = 0x4296FA59,
  ResizeGripHovered = 0xA5DBE6AB,
  TitleBgActive = 0x3B2870FF,
  TableRowBgAlt = 0xFFFFFF0F,
  SeparatorActive = 0x1A66BFFF,
  ScrollbarBg = 0x0E0E0DFF,
  Text = 0xFFFFFFFF,
  SliderGrabActive = 0x789FFF1E,
  ButtonActive = 0x2A6556BE,
  TitleBg = 0x3B2870FF,
  DockingEmptyBg = 0x333333FF,
  Button = 0x03B287BE,
  ScrollbarGrab = 0x2C2C2DFF,
  NavWindowingHighlight = 0xFFFFFFB3,
  Separator = 0x5E739E39,
  SliderGrab = 0x789FFF1E,
  TabHovered = 0x4296FACC,
  DragDropTarget = 0xFFBF78FF,
  ResizeGrip = 0xB7CCE4F2,
  TabDimmedSelected = 0x23436CFF,
  WindowBg = 0x0F0F1AFF,
  PlotLines = 0x9C9C9CFF,
  ChildBg = 0x0E13191D,
  BorderShadow = 0xFFBF78FF,
  FrameBgHovered = 0x11151DA8,
  PlotLinesHovered = 0xFF6E59FF,
  Border = 0x2A2A48FF,
  TreeLines = 0x6E6E8080,
  TabDimmed = 0x111A26F8,
  FrameBg = 0x96828A09,
  TitleBgCollapsed = 0x0D1015A8,
  FrameBgActive = 0x0D1015A8,
  SeparatorHovered = 0x1A66BFC7,
  TextLink = 0x4296FAFF,
  PlotHistogramHovered = 0x7AABB4FF,
  TableBorderLight = 0x3B3B40FF,
  TabSelectedOverline = 0x236941FF,
  PlotHistogram = 0xBEDCE2FF,
  TextDisabled = 0x808080FF,
}

local COLOR_COUNT = 0

local function ApplyMyStyle(ctx)

  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_Alpha(), 1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_DisabledAlpha(), 1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(), 14, 14)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowRounding(), 7)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(), .1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowMinSize(), 32, 32)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowTitleAlign(), 0, 0.5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ChildRounding(), 5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ChildBorderSize(), 1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_PopupRounding(), 4)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_PopupBorderSize(), 1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_FramePadding(), 8, 7)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_FrameRounding(), 4)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_FrameBorderSize(), 0)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), 10, 6)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemInnerSpacing(), 4, 0)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_IndentSpacing(), 19)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_CellPadding(), 18, 5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ScrollbarSize(), 16)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ScrollbarRounding(), 3)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_GrabMinSize(), 20)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_GrabRounding(), 5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ImageBorderSize(), 0)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TabRounding(), 3)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TabBorderSize(), 0)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TabBarBorderSize(), 2)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TabBarOverlineSize(), 1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TableAngledHeadersAngle(), 0.0523599)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TableAngledHeadersTextAlign(), 0, 0.5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TreeLinesSize(), 1)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_TreeLinesRounding(), 5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ButtonTextAlign(), 0.5, 0.5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_SelectableTextAlign(), 0, 0)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_SeparatorTextBorderSize(), 3)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_SeparatorTextAlign(), 0, 0.5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_SeparatorTextPadding(), 20, 3)

  local n = 0

  local function PC(col_id, key)
    r.ImGui_PushStyleColor(ctx, col_id, c[key])
    n = n + 1
  end

  PC(r.ImGui_Col_Text(), "Text")
  PC(r.ImGui_Col_TextDisabled(), "TextDisabled")
  PC(r.ImGui_Col_WindowBg(), "WindowBg")
  PC(r.ImGui_Col_ChildBg(), "ChildBg")
  PC(r.ImGui_Col_PopupBg(), "PopupBg")
  PC(r.ImGui_Col_Border(), "Border")
  PC(r.ImGui_Col_BorderShadow(), "BorderShadow")
  PC(r.ImGui_Col_FrameBg(), "FrameBg")
  PC(r.ImGui_Col_FrameBgHovered(), "FrameBgHovered")
  PC(r.ImGui_Col_FrameBgActive(), "FrameBgActive")
  PC(r.ImGui_Col_TitleBg(), "TitleBg")
  PC(r.ImGui_Col_TitleBgActive(), "TitleBgActive")
  PC(r.ImGui_Col_TitleBgCollapsed(), "TitleBgCollapsed")
  PC(r.ImGui_Col_MenuBarBg(), "MenuBarBg")
  PC(r.ImGui_Col_ScrollbarBg(), "ScrollbarBg")
  PC(r.ImGui_Col_ScrollbarGrab(), "ScrollbarGrab")
  PC(r.ImGui_Col_ScrollbarGrabHovered(), "ScrollbarGrabHovered")
  PC(r.ImGui_Col_ScrollbarGrabActive(), "ScrollbarGrabActive")
  PC(r.ImGui_Col_CheckMark(), "CheckMark")
  PC(r.ImGui_Col_SliderGrab(), "SliderGrab")
  PC(r.ImGui_Col_SliderGrabActive(), "SliderGrabActive")
  PC(r.ImGui_Col_Button(), "Button")
  PC(r.ImGui_Col_ButtonHovered(), "ButtonHovered")
  PC(r.ImGui_Col_ButtonActive(), "ButtonActive")
  PC(r.ImGui_Col_Header(), "Header")
  PC(r.ImGui_Col_HeaderHovered(), "HeaderHovered")
  PC(r.ImGui_Col_HeaderActive(), "HeaderActive")
  PC(r.ImGui_Col_Separator(), "Separator")
  PC(r.ImGui_Col_SeparatorHovered(), "SeparatorHovered")
  PC(r.ImGui_Col_SeparatorActive(), "SeparatorActive")
  PC(r.ImGui_Col_ResizeGrip(), "ResizeGrip")
  PC(r.ImGui_Col_ResizeGripHovered(), "ResizeGripHovered")
  PC(r.ImGui_Col_ResizeGripActive(), "ResizeGripActive")
  PC(r.ImGui_Col_InputTextCursor(), "InputTextCursor")
  PC(r.ImGui_Col_TabHovered(), "TabHovered")
  PC(r.ImGui_Col_Tab(), "Tab")
  PC(r.ImGui_Col_TabSelected(), "TabSelected")
  PC(r.ImGui_Col_TabSelectedOverline(), "TabSelectedOverline")
  PC(r.ImGui_Col_TabDimmed(), "TabDimmed")
  PC(r.ImGui_Col_TabDimmedSelected(), "TabDimmedSelected")
  PC(r.ImGui_Col_TabDimmedSelectedOverline(), "TabDimmedSelectedOverline")
  PC(r.ImGui_Col_DockingPreview(), "DockingPreview")
  PC(r.ImGui_Col_DockingEmptyBg(), "DockingEmptyBg")
  PC(r.ImGui_Col_PlotLines(), "PlotLines")
  PC(r.ImGui_Col_PlotLinesHovered(), "PlotLinesHovered")
  PC(r.ImGui_Col_PlotHistogram(), "PlotHistogram")
  PC(r.ImGui_Col_PlotHistogramHovered(), "PlotHistogramHovered")
  PC(r.ImGui_Col_TableHeaderBg(), "TableHeaderBg")
  PC(r.ImGui_Col_TableBorderStrong(), "TableBorderStrong")
  PC(r.ImGui_Col_TableBorderLight(), "TableBorderLight")
  PC(r.ImGui_Col_TableRowBg(), "TableRowBg")
  PC(r.ImGui_Col_TableRowBgAlt(), "TableRowBgAlt")
  PC(r.ImGui_Col_TextLink(), "TextLink")
  PC(r.ImGui_Col_TextSelectedBg(), "TextSelectedBg")
  PC(r.ImGui_Col_TreeLines(), "TreeLines")
  PC(r.ImGui_Col_DragDropTarget(), "DragDropTarget")
  PC(r.ImGui_Col_NavCursor(), "NavCursor")
  PC(r.ImGui_Col_NavWindowingHighlight(), "NavWindowingHighlight")
  PC(r.ImGui_Col_NavWindowingDimBg(), "NavWindowingDimBg")
  PC(r.ImGui_Col_ModalWindowDimBg(), "ModalWindowDimBg")

  COLOR_COUNT = n
end

local function PopMyStyle(ctx)
  r.ImGui_PopStyleColor(ctx, COLOR_COUNT)
  r.ImGui_PopStyleVar(ctx, 36)
end

--------------------------------------------------------
-- CONTEXT
--------------------------------------------------------
local ctx = r.ImGui_CreateContext('JCMega Hand Scroll Pad')

--------------------------------------------------------
-- CONFIG
--------------------------------------------------------
local PAD_W = 500
local PAD_H = 300

local SPEED_X = 1.0
local SPEED_Y = 0.2

--------------------------------------------------------
-- ESTADO
--------------------------------------------------------
local activeButton = 0
local dragging = false
local last_x = 0
local last_y = 0

--------------------------------------------------------
-- COLORES
--------------------------------------------------------
local GREEN       = 0x33CC55FF
local GREEN_HOVER = 0x55EE77FF
local GREEN_ACT   = 0x22AA44FF

--------------------------------------------------------
-- HAND SCROLL
--------------------------------------------------------
local function DoHandScroll(dx, dy)

  ----------------------------------------------------
  -- HORIZONTAL
  ----------------------------------------------------
  local h_amount = dx * SPEED_X

  if h_amount ~= 0 then
    r.CSurf_OnScroll(-h_amount, 0)
  end

  ----------------------------------------------------
  -- VERTICAL
  ----------------------------------------------------
  local v_amount = dy * SPEED_Y

  if math.abs(v_amount) >= 1 then

    local steps = math.floor(math.abs(v_amount))

    if v_amount > 0 then
      for i = 1, steps do
        r.Main_OnCommand(40139, 0)
      end
    else
      for i = 1, steps do
        r.Main_OnCommand(40138, 0)
      end
    end
  end
end

--------------------------------------------------------
-- ZOOM
--------------------------------------------------------
local function DoZoom(wheel)

  if wheel > 0 then
    r.Main_OnCommand(1012, 0)
  elseif wheel < 0 then
    r.Main_OnCommand(1011, 0)
  end
end

--------------------------------------------------------
-- BOTONES
--------------------------------------------------------
local function DrawModeButton(label, id)

  local active = (activeButton == id)

  if active then
    r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), GREEN)
    r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), GREEN_HOVER)
    r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), GREEN_ACT)
  end

  if r.ImGui_Button(ctx, label, 110, 30) then
    activeButton = id
  end

  if active then
    r.ImGui_PopStyleColor(ctx, 3)
  end
end

--------------------------------------------------------
-- PAD
--------------------------------------------------------
local function DrawPad()

  local draw_list = r.ImGui_GetWindowDrawList(ctx)

  local x, y = r.ImGui_GetCursorScreenPos(ctx)

  r.ImGui_InvisibleButton(ctx, "##pad", PAD_W, PAD_H)

  local hovered = r.ImGui_IsItemHovered(ctx)
  local pressed = r.ImGui_IsMouseDown(ctx, activeButton)

  ----------------------------------------------------
  -- SCROLL WHEEL ZOOM
  ----------------------------------------------------
  if hovered then

    local wheel = r.ImGui_GetMouseWheel(ctx)

    if wheel ~= 0 then
      DoZoom(wheel)
    end
  end

  ----------------------------------------------------
  -- FONDO
  ----------------------------------------------------
  local bg = hovered and 0x333333FF or 0x222222FF

  r.ImGui_DrawList_AddRectFilled(
    draw_list,
    x,
    y,
    x + PAD_W,
    y + PAD_H,
    bg,
    12
  )

  ----------------------------------------------------
  -- BORDE
  ----------------------------------------------------
  r.ImGui_DrawList_AddRect(
    draw_list,
    x,
    y,
    x + PAD_W,
    y + PAD_H,
    0x666666FF,
    12,
    0,
    2
  )

  ----------------------------------------------------
  -- GUIAS
  ----------------------------------------------------
  r.ImGui_DrawList_AddLine(
    draw_list,
    x + PAD_W * 0.5,
    y,
    x + PAD_W * 0.5,
    y + PAD_H,
    0x444444FF,
    1
  )

  r.ImGui_DrawList_AddLine(
    draw_list,
    x,
    y + PAD_H * 0.5,
    x + PAD_W,
    y + PAD_H * 0.5,
    0x444444FF,
    1
  )

  ----------------------------------------------------
  -- TEXTO
  ----------------------------------------------------
  r.ImGui_DrawList_AddText(
    draw_list,
    x + 15,
    y + 15,
    0xFFFFFFFF,
    "HAND SCROLL PAD"
  )

  r.ImGui_DrawList_AddText(
    draw_list,
    x + 15,
    y + 40,
    0xAAAAAAFF,
    "Drag = Scroll | Wheel = Zoom"
  )

  ----------------------------------------------------
  -- START DRAG
  ----------------------------------------------------
  if hovered and pressed and not dragging then
    dragging = true
    last_x, last_y = r.GetMousePosition()
  end

  ----------------------------------------------------
  -- STOP DRAG
  ----------------------------------------------------
  if not pressed then
    dragging = false
  end

  ----------------------------------------------------
  -- DRAGGING
  ----------------------------------------------------
  if dragging then

    local mx, my = r.GetMousePosition()

    local dx = mx - last_x
    local dy = my - last_y

    last_x = mx
    last_y = my

    DoHandScroll(dx, dy)

    ------------------------------------------------
    -- CURSOR DOT
    ------------------------------------------------
    local local_mx = mx - x
    local local_my = my - y

    r.ImGui_DrawList_AddCircleFilled(
      draw_list,
      x + local_mx,
      y + local_my,
      8,
      0x33CC55FF
    )
  end
end

--------------------------------------------------------
-- MAIN
--------------------------------------------------------
local function Main()

  ApplyMyStyle(ctx)

  r.ImGui_SetNextWindowSize(
    ctx,
    560,
    420,
    r.ImGui_Cond_FirstUseEver()
  )

  local visible, open = r.ImGui_Begin(
    ctx,
    'JCMega Hand Scroll Pad',
    true
  )

  if visible then

    r.ImGui_Text(
      ctx,
      "Select Hand Scroll Button"
    )

    ------------------------------------------------
    -- BOTONES
    ------------------------------------------------
    DrawModeButton("Left Click", 0)

    r.ImGui_SameLine(ctx)

    DrawModeButton("Right Click", 1)

    r.ImGui_SameLine(ctx)

    DrawModeButton("Mouse Wheel", 2)

    r.ImGui_SameLine(ctx)

    if r.ImGui_Button(ctx, "Reset", 90, 30) then
      activeButton = 0
    end

    r.ImGui_Separator(ctx)

    ------------------------------------------------
    -- PAD
    ------------------------------------------------
    DrawPad()

    r.ImGui_End(ctx)
  end

  PopMyStyle(ctx)

  if open then
    r.defer(Main)
  end
end

--------------------------------------------------------
-- START
--------------------------------------------------------
Main()
