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
--------------------------------------------------
-- STYLE BLOQUE 3 FUNCIONES
--------------------------------------------------
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


--------------------------------------------------
-- COPIA Y PEGA EL SCRIPT ORIGINAL HASTA LA LINEA "local function loop()"
--------------------------------------------------

--REEMPLAZA  AQUI HASTA "local function loop()"

--------------------------------------------------
-- STYLE BLOQUE 4 SE AGREGA "ApplyMyStyle(ctx)" JUSTO DESPUES DE "local function loop()"
--------------------------------------------------
--ApplyMyStyle(ctx)
--------------------------------------------------
-- ������ CONTINUAR EL CODIGO DEL SCRIPT DESTINO
--------------------------------------------------

-- @description JC Mega Template Constructor
-- @version 4.0
-- @author JC Megatrazher
-- @requires ReaImGui

local r = reaper

if not r.ImGui_CreateContext then
    r.ShowMessageBox(
        "ReaImGui no instalado.",
        "ERROR",
        0
    )
    return
end

-- ─────────────────────────────────────────────
-- IMGUI
-- ─────────────────────────────────────────────
local ctx = r.ImGui_CreateContext(
    "JC Mega Template Constructor"
)

local WIN_W = 560
local WIN_H = 650

-- ─────────────────────────────────────────────
-- STATE
-- ─────────────────────────────────────────────
local CREATE_VOX   = true
local CREATE_DRUMS = true
local CREATE_BASS  = true
local CREATE_GTR   = true
local CREATE_FX    = true

-- ─────────────────────────────────────────────
-- HELPERS
-- ─────────────────────────────────────────────
local function MakeTrack(name)

    local idx = r.CountTracks(0)

    r.InsertTrackAtIndex(idx, true)

    local tr = r.GetTrack(0, idx)

    r.GetSetMediaTrackInfo_String(
        tr,
        "P_NAME",
        name,
        true
    )

    return tr
end

local function ColorTrack(tr, r1,g1,b1, dim)

    if dim then
        r1 = math.floor(r1 * 0.55)
        g1 = math.floor(g1 * 0.55)
        b1 = math.floor(b1 * 0.55)
    end

    r.SetTrackColor(
        tr,
        r.ColorToNative(r1,g1,b1)|0x1000000
    )
end

local function Folder(parent, children)

    if #children == 0 then
        return
    end

    r.SetMediaTrackInfo_Value(
        parent,
        "I_FOLDERDEPTH",
        1
    )

    for i = 1, #children - 1 do

        r.SetMediaTrackInfo_Value(
            children[i],
            "I_FOLDERDEPTH",
            0
        )
    end

    r.SetMediaTrackInfo_Value(
        children[#children],
        "I_FOLDERDEPTH",
        -1
    )
end

local function Send(src,dst)

    if src and dst then
        r.CreateTrackSend(src,dst)
    end
end

local function SetPan(tr,val)

    r.SetMediaTrackInfo_Value(
        tr,
        "D_PAN",
        val
    )
end

-- ─────────────────────────────────────────────
-- BUILD TEMPLATE
-- ─────────────────────────────────────────────
local function BuildTemplate()

    r.PreventUIRefresh(1)
    r.Undo_BeginBlock()

    -- COLORS
    local PRE  = {80,80,80}

    local VOX  = {220,170,20}
    local DRM  = {40,90,220}
    local BASS = {80,180,70}
    local GTR  = {180,40,20}
    local FXC  = {120,120,120}

    -- =====================================================
    -- PREMIX
    -- =====================================================
    local premix = MakeTrack("PREMIX")

    ColorTrack(
        premix,
        PRE[1],
        PRE[2],
        PRE[3],
        false
    )

    -- =====================================================
    -- INSTRUMENTS
    -- =====================================================
    local instruments = MakeTrack("INSTRUMENTS")

    ColorTrack(
        instruments,
        70,
        70,
        70,
        false
    )

    -- =====================================================
    -- FX ROOT
    -- =====================================================
    local fxRoot = MakeTrack("FX")

    ColorTrack(
        fxRoot,
        FXC[1],
        FXC[2],
        FXC[3],
        false
    )

    -- LISTAS
    local premixChildren = {}
    local instChildren   = {}
    local fxChildren     = {}

    -- =====================================================
    -- VOX
    -- =====================================================
    if CREATE_VOX then

        local vox = MakeTrack("VOX")

        local voxLow  = MakeTrack("VOX LOW")
        local voxGt   = MakeTrack("VOX GTURL")
        local voxCho  = MakeTrack("VOX CHO")
        local voxDark = MakeTrack("VOX DARK")

        ColorTrack(
            vox,
            VOX[1],
            VOX[2],
            VOX[3],
            false
        )

        for _,tr in ipairs({
            voxLow,
            voxGt,
            voxCho,
            voxDark
        }) do

            ColorTrack(
                tr,
                VOX[1],
                VOX[2],
                VOX[3],
                true
            )
        end

        Folder(vox,{
            voxLow,
            voxGt,
            voxCho,
            voxDark
        })

        Send(vox,premix)

        table.insert(
            premixChildren,
            vox
        )
    end

    -- =====================================================
    -- DRUMS
    -- =====================================================
    if CREATE_DRUMS then

        local drmBus = MakeTrack("DRUMS BUS")

        local kick   = MakeTrack("KICK")
        local snare  = MakeTrack("SNARE")
        local toms   = MakeTrack("TOMS")
        local oh     = MakeTrack("OH")
        local rooms  = MakeTrack("ROOMS")
        local sd3    = MakeTrack("SD3")

        ColorTrack(
            drmBus,
            DRM[1],
            DRM[2],
            DRM[3],
            false
        )

        for _,tr in ipairs({
            kick,
            snare,
            toms,
            oh,
            rooms,
            sd3
        }) do

            ColorTrack(
                tr,
                DRM[1],
                DRM[2],
                DRM[3],
                true
            )
        end

        Folder(drmBus,{
            kick,
            snare,
            toms,
            oh,
            rooms,
            sd3
        })

        Send(drmBus,instruments)

        table.insert(
            instChildren,
            drmBus
        )
    end

    -- =====================================================
    -- BASS
    -- =====================================================
    if CREATE_BASS then

        local bassBus = MakeTrack("BASS BUS")

        local clean = MakeTrack("BASS CLEAN")
        local drive = MakeTrack("BASS DRIVE")
        local sub   = MakeTrack("BASS SUB")

        ColorTrack(
            bassBus,
            BASS[1],
            BASS[2],
            BASS[3],
            false
        )

        for _,tr in ipairs({
            clean,
            drive,
            sub
        }) do

            ColorTrack(
                tr,
                BASS[1],
                BASS[2],
                BASS[3],
                true
            )
        end

        Folder(bassBus,{
            clean,
            drive,
            sub
        })

        Send(bassBus,instruments)

        table.insert(
            instChildren,
            bassBus
        )
    end

    -- =====================================================
    -- GUITARS
    -- =====================================================
    if CREATE_GTR then

        local gtrBus = MakeTrack("GUITARS BUS")

        local toneA = MakeTrack("TONE A")
        local gtr1  = MakeTrack("GTR 1 L")
        local gtr2  = MakeTrack("GTR 2 R")

        local toneB = MakeTrack("TONE B")
        local gtr3  = MakeTrack("GTR 3 L")
        local gtr4  = MakeTrack("GTR 4 R")

        ColorTrack(
            gtrBus,
            GTR[1],
            GTR[2],
            GTR[3],
            false
        )

        for _,tr in ipairs({
            toneA,
            gtr1,
            gtr2,
            toneB,
            gtr3,
            gtr4
        }) do

            ColorTrack(
                tr,
                GTR[1],
                GTR[2],
                GTR[3],
                true
            )
        end

        Folder(gtrBus,{
            toneA,
            gtr1,
            gtr2,
            toneB,
            gtr3,
            gtr4
        })

        SetPan(gtr1,-1.0)
        SetPan(gtr2, 1.0)

        SetPan(gtr3,-0.65)
        SetPan(gtr4, 0.65)

        Send(gtrBus,instruments)

        table.insert(
            instChildren,
            gtrBus
        )
    end

   -- REEMPLAZA COMPLETAMENTE ESTA SECCIÓN:
   
   -- =====================================================
   -- FX
   -- =====================================================
   if CREATE_FX then
   
       -- VOX FX
       if CREATE_VOX then
   
           local voxFX   = MakeTrack("VCA VOX FX")
           local voxComp = MakeTrack("VOX COMP")
           local voxVrb  = MakeTrack("VOX VRB")
           local voxDly  = MakeTrack("VOX DLY")
   
           ColorTrack(
               voxFX,
               VOX[1],
               VOX[2],
               VOX[3],
               false
           )
   
           for _,tr in ipairs({
               voxComp,
               voxVrb,
               voxDly
           }) do
   
               ColorTrack(
                   tr,
                   VOX[1],
                   VOX[2],
                   VOX[3],
                   true
               )
           end
   
           Folder(voxFX,{
               voxComp,
               voxVrb,
               voxDly
           })
   
           table.insert(
               fxChildren,
               voxFX
           )
       end
   
       -- GTR FX
       if CREATE_GTR then
   
           local gtrFX  = MakeTrack("VCA GTR FX")
   
           local gtrSat = MakeTrack("GTR SAT")
           local gtrComp= MakeTrack("GTR COMP")
           local gtrVrb = MakeTrack("GTR VRB")
           local gtrDly = MakeTrack("GTR DLY")
           local gtrExc = MakeTrack("GTR EXC")
   
           ColorTrack(
               gtrFX,
               GTR[1],
               GTR[2],
               GTR[3],
               false
           )
   
           for _,tr in ipairs({
               gtrSat,
               gtrComp,
               gtrVrb,
               gtrDly,
               gtrExc
           }) do
   
               ColorTrack(
                   tr,
                   GTR[1],
                   GTR[2],
                   GTR[3],
                   true
               )
           end
   
           Folder(gtrFX,{
               gtrSat,
               gtrComp,
               gtrVrb,
               gtrDly,
               gtrExc
           })
   
           table.insert(
               fxChildren,
               gtrFX
           )
       end
   
       -- BASS FX
       if CREATE_BASS then
   
           local bassFX = MakeTrack("VCA BASS FX")
   
           local bassComp = MakeTrack("BASS COMP")
           local bassSat  = MakeTrack("BASS SAT")
           local bassSub  = MakeTrack("BASS SUB FX")
   
           ColorTrack(
               bassFX,
               BASS[1],
               BASS[2],
               BASS[3],
               false
           )
   
           for _,tr in ipairs({
               bassComp,
               bassSat,
               bassSub
           }) do
   
               ColorTrack(
                   tr,
                   BASS[1],
                   BASS[2],
                   BASS[3],
                   true
               )
           end
   
           Folder(bassFX,{
               bassComp,
               bassSat,
               bassSub
           })
   
           table.insert(
               fxChildren,
               bassFX
           )
       end
   
       -- DRUM FX
       if CREATE_DRUMS then
   
           local drmFX = MakeTrack("VCA DRUMS FX")
   
           local drmComp = MakeTrack("DRM COMP")
           local drmVrb  = MakeTrack("DRM VRB")
           local drmRoom = MakeTrack("DRM ROOM")
           local kikComp = MakeTrack("KICK COMP")
           local kikSat  = MakeTrack("KICK SAT")
   
           ColorTrack(
               drmFX,
               DRM[1],
               DRM[2],
               DRM[3],
               false
           )
   
           for _,tr in ipairs({
               drmComp,
               drmVrb,
               drmRoom,
               kikComp,
               kikSat
           }) do
   
               ColorTrack(
                   tr,
                   DRM[1],
                   DRM[2],
                   DRM[3],
                   true
               )
           end
   
           Folder(drmFX,{
               drmComp,
               drmVrb,
               drmRoom,
               kikComp,
               kikSat
           })
   
           table.insert(
               fxChildren,
               drmFX
           )
       end
   end
    -- =====================================================
    -- FOLDERS ROOT
    -- =====================================================

    if #instChildren > 0 then
        Folder(
            instruments,
            instChildren
        )

        Send(
            instruments,
            premix
        )

        table.insert(
            premixChildren,
            instruments
        )
    end

    if #fxChildren > 0 then

        Folder(
            fxRoot,
            fxChildren
        )

        Send(
            fxRoot,
            premix
        )

        table.insert(
            premixChildren,
            fxRoot
        )
    end

    -- PREMIX CLOSE
    if #premixChildren > 0 then

        Folder(
            premix,
            premixChildren
        )
    end

    r.TrackList_AdjustWindows(false)
    r.UpdateArrange()

    r.Undo_EndBlock(
        "JC Mega MixBus Constructor",
        -1
    )

    r.PreventUIRefresh(-1)
end

-- ─────────────────────────────────────────────
-- UI
-- ─────────────────────────────────────────────
local function Main()

ApplyMyStyle(ctx)

    r.ImGui_SetNextWindowSize(
        ctx,
        WIN_W,
        WIN_H,
        r.ImGui_Cond_FirstUseEver()
    )

    local visible, open = r.ImGui_Begin(
        ctx,
        "JC Mega Template Constructor",
        true,
        r.ImGui_WindowFlags_NoCollapse()
    )

    if visible then

        r.ImGui_PushStyleColor(
            ctx,
            r.ImGui_Col_Text(),
            0xFF5050FF
        )

        r.ImGui_Text(
            ctx,
            "Choose which bus groups you want to create"
        )

        r.ImGui_PopStyleColor(ctx,1)

        r.ImGui_Separator(ctx)

        r.ImGui_Spacing(ctx)

        r.ImGui_TextWrapped(
            ctx,
            "Groups:"
        )

        r.ImGui_Spacing(ctx)

        local rv

        rv, CREATE_VOX =
            r.ImGui_Checkbox(
                ctx,
                "VOX",
                CREATE_VOX
            )

        rv, CREATE_DRUMS =
            r.ImGui_Checkbox(
                ctx,
                "DRUMS",
                CREATE_DRUMS
            )

        rv, CREATE_BASS =
            r.ImGui_Checkbox(
                ctx,
                "BASS",
                CREATE_BASS
            )

        rv, CREATE_GTR =
            r.ImGui_Checkbox(
                ctx,
                "GUITARS",
                CREATE_GTR
            )

        rv, CREATE_FX =
            r.ImGui_Checkbox(
                ctx,
                "FX SECTION",
                CREATE_FX
            )

        r.ImGui_Spacing(ctx)
        r.ImGui_Separator(ctx)
        r.ImGui_Spacing(ctx)

        r.ImGui_PushStyleColor(
            ctx,
            r.ImGui_Col_Button(),
            0xAA2020FF
        )

        r.ImGui_PushStyleColor(
            ctx,
            r.ImGui_Col_ButtonHovered(),
            0xCC3030FF
        )

        r.ImGui_PushStyleColor(
            ctx,
            r.ImGui_Col_ButtonActive(),
            0x881818FF
        )

        if r.ImGui_Button(
            ctx,
            "CREATE TEMPLATE",
            300,
            50
        ) then

            BuildTemplate()
        end

        r.ImGui_PopStyleColor(ctx,3)

        r.ImGui_Spacing(ctx)
        r.ImGui_Separator(ctx)

     r.ImGui_TextWrapped(
         ctx,
         "IMPORTANT: Configure your own input/output routing manually\n" ..
         "Make sure MASTER SEND is enabled on the PREMIX track"
     )

        r.ImGui_End(ctx)
    end
    PopMyStyle(ctx)

    if open then
        r.defer(Main)
    else

    end
end

r.defer(Main)
