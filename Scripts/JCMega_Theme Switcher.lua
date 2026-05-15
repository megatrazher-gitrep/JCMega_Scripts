--========================================================
-- JCMega_Theme Switcher
-- Requiere ReaImGui + JS_ReaScriptAPI
--Created by **JC / MegaTrazher**
--========================================================

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

  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_Alpha(),                       1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_DisabledAlpha(),               1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowPadding(),               14, 14)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowRounding(),              7)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowBorderSize(),            .1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowMinSize(),               32, 32)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_WindowTitleAlign(),            0, 0.5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ChildRounding(),               5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ChildBorderSize(),             1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_PopupRounding(),               4)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_PopupBorderSize(),             1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FramePadding(),                8, 7)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameRounding(),               4)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_FrameBorderSize(),             0)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ItemSpacing(),                 10, 6)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ItemInnerSpacing(),            4, 0)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_IndentSpacing(),               19)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_CellPadding(),                 18, 5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ScrollbarSize(),               16)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ScrollbarRounding(),           3)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_GrabMinSize(),                 20)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_GrabRounding(),                5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ImageBorderSize(),             0)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TabRounding(),                 3)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TabBorderSize(),               0)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TabBarBorderSize(),            2)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TabBarOverlineSize(),          1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TableAngledHeadersAngle(),     0.0523599)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TableAngledHeadersTextAlign(), 0, 0.5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TreeLinesSize(),               1)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_TreeLinesRounding(),           5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_ButtonTextAlign(),             0.5, 0.5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_SelectableTextAlign(),         0, 0)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_SeparatorTextBorderSize(),     3)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_SeparatorTextAlign(),          0, 0.5)
  reaper.ImGui_PushStyleVar(ctx, reaper.ImGui_StyleVar_SeparatorTextPadding(),        20, 3)

  local n = 0
  local function PC(col_id, key)
    reaper.ImGui_PushStyleColor(ctx, col_id, c[key])
    n = n + 1
  end

  PC(reaper.ImGui_Col_Text(),                      "Text")
  PC(reaper.ImGui_Col_TextDisabled(),              "TextDisabled")
  PC(reaper.ImGui_Col_WindowBg(),                  "WindowBg")
  PC(reaper.ImGui_Col_ChildBg(),                   "ChildBg")
  PC(reaper.ImGui_Col_PopupBg(),                   "PopupBg")
  PC(reaper.ImGui_Col_Border(),                    "Border")
  PC(reaper.ImGui_Col_BorderShadow(),              "BorderShadow")
  PC(reaper.ImGui_Col_FrameBg(),                   "FrameBg")
  PC(reaper.ImGui_Col_FrameBgHovered(),            "FrameBgHovered")
  PC(reaper.ImGui_Col_FrameBgActive(),             "FrameBgActive")
  PC(reaper.ImGui_Col_TitleBg(),                   "TitleBg")
  PC(reaper.ImGui_Col_TitleBgActive(),             "TitleBgActive")
  PC(reaper.ImGui_Col_TitleBgCollapsed(),          "TitleBgCollapsed")
  PC(reaper.ImGui_Col_MenuBarBg(),                 "MenuBarBg")
  PC(reaper.ImGui_Col_ScrollbarBg(),               "ScrollbarBg")
  PC(reaper.ImGui_Col_ScrollbarGrab(),             "ScrollbarGrab")
  PC(reaper.ImGui_Col_ScrollbarGrabHovered(),      "ScrollbarGrabHovered")
  PC(reaper.ImGui_Col_ScrollbarGrabActive(),       "ScrollbarGrabActive")
  PC(reaper.ImGui_Col_CheckMark(),                 "CheckMark")
  PC(reaper.ImGui_Col_SliderGrab(),                "SliderGrab")
  PC(reaper.ImGui_Col_SliderGrabActive(),          "SliderGrabActive")
  PC(reaper.ImGui_Col_Button(),                    "Button")
  PC(reaper.ImGui_Col_ButtonHovered(),             "ButtonHovered")
  PC(reaper.ImGui_Col_ButtonActive(),              "ButtonActive")
  PC(reaper.ImGui_Col_Header(),                    "Header")
  PC(reaper.ImGui_Col_HeaderHovered(),             "HeaderHovered")
  PC(reaper.ImGui_Col_HeaderActive(),              "HeaderActive")
  PC(reaper.ImGui_Col_Separator(),                 "Separator")
  PC(reaper.ImGui_Col_SeparatorHovered(),          "SeparatorHovered")
  PC(reaper.ImGui_Col_SeparatorActive(),           "SeparatorActive")
  PC(reaper.ImGui_Col_ResizeGrip(),                "ResizeGrip")
  PC(reaper.ImGui_Col_ResizeGripHovered(),         "ResizeGripHovered")
  PC(reaper.ImGui_Col_ResizeGripActive(),          "ResizeGripActive")
  PC(reaper.ImGui_Col_InputTextCursor(),           "InputTextCursor")
  PC(reaper.ImGui_Col_TabHovered(),                "TabHovered")
  PC(reaper.ImGui_Col_Tab(),                       "Tab")
  PC(reaper.ImGui_Col_TabSelected(),               "TabSelected")
  PC(reaper.ImGui_Col_TabSelectedOverline(),       "TabSelectedOverline")
  PC(reaper.ImGui_Col_TabDimmed(),                 "TabDimmed")
  PC(reaper.ImGui_Col_TabDimmedSelected(),         "TabDimmedSelected")
  PC(reaper.ImGui_Col_TabDimmedSelectedOverline(), "TabDimmedSelectedOverline")
  PC(reaper.ImGui_Col_DockingPreview(),            "DockingPreview")
  PC(reaper.ImGui_Col_DockingEmptyBg(),            "DockingEmptyBg")
  PC(reaper.ImGui_Col_PlotLines(),                 "PlotLines")
  PC(reaper.ImGui_Col_PlotLinesHovered(),          "PlotLinesHovered")
  PC(reaper.ImGui_Col_PlotHistogram(),             "PlotHistogram")
  PC(reaper.ImGui_Col_PlotHistogramHovered(),      "PlotHistogramHovered")
  PC(reaper.ImGui_Col_TableHeaderBg(),             "TableHeaderBg")
  PC(reaper.ImGui_Col_TableBorderStrong(),         "TableBorderStrong")
  PC(reaper.ImGui_Col_TableBorderLight(),          "TableBorderLight")
  PC(reaper.ImGui_Col_TableRowBg(),                "TableRowBg")
  PC(reaper.ImGui_Col_TableRowBgAlt(),             "TableRowBgAlt")
  PC(reaper.ImGui_Col_TextLink(),                  "TextLink")
  PC(reaper.ImGui_Col_TextSelectedBg(),            "TextSelectedBg")
  PC(reaper.ImGui_Col_TreeLines(),                 "TreeLines")
  PC(reaper.ImGui_Col_DragDropTarget(),            "DragDropTarget")
  PC(reaper.ImGui_Col_NavCursor(),                 "NavCursor")
  PC(reaper.ImGui_Col_NavWindowingHighlight(),     "NavWindowingHighlight")
  PC(reaper.ImGui_Col_NavWindowingDimBg(),         "NavWindowingDimBg")
  PC(reaper.ImGui_Col_ModalWindowDimBg(),          "ModalWindowDimBg")

  COLOR_COUNT = n
end

local function PopMyStyle(ctx)
  reaper.ImGui_PopStyleColor(ctx, COLOR_COUNT)
  reaper.ImGui_PopStyleVar(ctx, 36)
end


local r = reaper
local ctx = r.ImGui_CreateContext('JCMega_Theme Switcher')

-----------------------------------------------------
-- VARIABLES
-----------------------------------------------------
local themes = {}
local current_index = 1

-----------------------------------------------------
-- GET RESOURCE PATH
-----------------------------------------------------
local resource_path = r.GetResourcePath()
local theme_path = resource_path .. "/ColorThemes/"

-----------------------------------------------------
-- LOAD THEMES
-----------------------------------------------------
function LoadThemes()
    themes = {}
    local i = 0
    
    while true do
        local file = r.EnumerateFiles(theme_path, i)
        if not file then break end
        
        if file:match("%.ReaperTheme$") or file:match("%.ReaperThemeZip$") then
            table.insert(themes, file)
        end
        
        i = i + 1
    end
end

-----------------------------------------------------
-- APPLY THEME
-----------------------------------------------------
function ApplyTheme(index)
    if themes[index] then
        local fullpath = theme_path .. themes[index]
        r.OpenColorThemeFile(fullpath)
        current_index = index
    end
end

-----------------------------------------------------
-- FIND CURRENT THEME INDEX
-----------------------------------------------------
function DetectCurrentTheme()
    local _, current_theme = r.GetLastColorThemeFile()
    
    if not current_theme then return end
    
    for i, theme in ipairs(themes) do
        if current_theme:match(theme) then
            current_index = i
            return
        end
    end
end

-----------------------------------------------------
-- NAVIGATION
-----------------------------------------------------
function NextTheme()
    local next_index = current_index + 1
    if next_index > #themes then next_index = 1 end
    ApplyTheme(next_index)
end

function PrevTheme()
    local prev_index = current_index - 1
    if prev_index < 1 then prev_index = #themes end
    ApplyTheme(prev_index)
end

-----------------------------------------------------
-- INIT
-----------------------------------------------------
LoadThemes()
DetectCurrentTheme()

-----------------------------------------------------
-- UI LOOP
-----------------------------------------------------
function loop()
ApplyMyStyle(ctx)
    local visible, open = r.ImGui_Begin(ctx, 'JCMega_Theme Switcher', true)
    
    if visible then
        
        r.ImGui_Text(ctx, "Current Theme:")
        if themes[current_index] then
            r.ImGui_TextColored(ctx, 0x00FFAAFF, themes[current_index])
        else
            r.ImGui_Text(ctx, "No detectado")
        end
        
        r.ImGui_Separator(ctx)
        
        if r.ImGui_Button(ctx, "⏮ Previous", 150, 40) then
            PrevTheme()
        end
        
        r.ImGui_SameLine(ctx)
        
        if r.ImGui_Button(ctx, "Next ⏭", 150, 40) then
            NextTheme()
        end
        
        r.ImGui_Separator(ctx)
        r.ImGui_Text(ctx, "Total themes: " .. tostring(#themes))
        
        r.ImGui_End(ctx)
    end
    
PopMyStyle(ctx)

  if open then    reaper.defer(loop)
end
end

--------------------------------------------------
-- ?
--------------------------------------------------
loop()
