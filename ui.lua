local _G = _G or getfenv(0)

local logger = {}
function logger.trace(message) 
  DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController [T] " .. message)
end
function logger.debug(message) 
  -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController [D] " .. message)
end
function logger.info(message) 
  DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController [I] " .. message)
end
function logger.warn(message) 
  DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController [W] " .. message)
end
function logger.error(message) 
  DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController [E] " .. message)
end
function print(message)
  logger.info(message)
end

local resizes = {
  MainMenuBar, MainMenuExpBar, MainMenuBarMaxLevelBar,
  ReputationWatchBar, ReputationWatchStatusBar,
}

local frames = {
  BonusActionBarTexture0, BonusActionBarTexture1,
  ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
  MainMenuMaxLevelBar2, MainMenuMaxLevelBar3,
}

local textures = {
  MainMenuBarTexture0, MainMenuBarTexture1,
  MainMenuXPBarTexture2, MainMenuXPBarTexture3,
  ReputationWatchBarTexture2, ReputationWatchBarTexture3,
  ReputationXPBarTexture2, ReputationXPBarTexture3,
  SlidingActionBarTexture0, SlidingActionBarTexture1,
}

local normtextures = {
  ShapeshiftButton1, ShapeshiftButton2,
  ShapeshiftButton3, ShapeshiftButton4,
  ShapeshiftButton5, ShapeshiftButton6,
}

-- general function to hide textures and frames
local function hide(frame, texture)
  if not frame then return end

  if texture and texture == 1 and frame.SetTexture then
    frame:SetTexture("")
  elseif texture and texture == 2 and frame.SetNormalTexture then
    frame:SetNormalTexture("")
  else
    frame:ClearAllPoints()
    frame.Show = function() return end
    frame:Hide()
  end
end

-- reduce actionbar size
for id, frame in pairs(resizes) do frame:SetWidth(770) end

  -- hide reduced frames
for id, frame in pairs(frames) do hide(frame) end

-- clear reduced textures
for id, frame in pairs(textures) do hide(frame, 1) end

-- clear some button textures
for id, frame in pairs(normtextures) do hide(frame, 2) end

local ui_playerframe = CreateFrame("Frame")
ui_playerframe:RegisterEvent("PLAYER_LOGIN")
ui_playerframe:RegisterEvent("PLAYER_ENTERING_WORLD")
ui_playerframe:SetScript("OnEvent", function()
  -- Check if the PlayerFrame is available
  if PlayerFrame then
    -- Unregister any events that might move the PlayerFrame back
    PlayerFrame:UnregisterAllEvents()
    
    -- Set new position
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT", MultiBarLeft, "TOPRIGHT", -19, 0)
  else
    logger.debug("PlayerFrame is not available yet.")
  end
end)

local point, relativeTo, relativePoint, offsetX, offsetY = QuestFrame:GetPoint(1)
relativeTo = MultiBarLeft
QuestFrame:SetPoint(point, UIParent, relativeTo, offsetX, offsetY)


local ui_targetframe = CreateFrame("Frame")
ui_targetframe:RegisterEvent("PLAYER_LOGIN")
ui_targetframe:RegisterEvent("PLAYER_ENTERING_WORLD")
ui_targetframe:SetScript("OnEvent", function()
  -- Check if the PlayerFrame is available
  if TargetFrame then
    -- Unregister any events that might move the TargetFrame back
    -- TargetFrame:UnregisterAllEvents()
    
    -- Set new position
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", 20, 0)
  else
    logger.debug("PlayerFrame is not available yet.")
  end
end)

-- SetCVar("uiScale", 1)
-- SetCVar("showFPS", "1")

local ui = CreateFrame("Frame", "ShaguControllerUI", UIParent)
ui:RegisterEvent("PLAYER_LOGIN")
ui:RegisterEvent("PLAYER_ENTERING_WORLD")
ui:SetScript("OnEvent", function()
  logger.debug("OnEvent called")
  -- update ui when frame positions get managed
  ui.manage_positions_hook = UIParent_ManageFramePositions
  UIParent_ManageFramePositions = ui.manage_positions

  ui:UnregisterAllEvents()
end)

ui.manage_button = function(self, frame, pos, x, y, image, image_pos)
  logger.debug("manage_button called")

  -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: manage_button.")
  if frame and tonumber(frame) then
    self:manage_button(_G["ActionButton" .. frame], pos, x, y, image, image_pos)
    self:manage_button(_G["BonusActionButton" .. frame], pos, x, y, image, image_pos)
    return
  end

  if pos == "DISABLED" then
    frame.Show = function() return end
    frame:ClearAllPoints()
    frame:Hide()
    return
  end

  -- set button scale and set position
  local scale = image == "" and 1 or 1.2
  local revscale = scale == 1 and 1.2 or 1
  frame:SetScale(scale)
  frame:ClearAllPoints()
  frame:SetPoint("CENTER", UIParent, pos, x*revscale, y*revscale)

  -- hide keybind text
  _G[frame:GetName().."HotKey"]:Hide()

  -- add keybind icon
  if not frame.keybind_icon then
    frame.keybind_icon = CreateFrame("Frame", nil, frame)
    frame.keybind_icon:SetFrameLevel(255)
    frame.keybind_icon:SetAllPoints(frame)

    frame.keybind_icon.tex = frame.keybind_icon:CreateTexture(nil, "OVERLAY")
    frame.keybind_icon.tex:SetTexture(image)
    frame.keybind_icon.tex:SetPoint(image_pos, frame.keybind_icon, image_pos, 0, 0)
    frame.keybind_icon.tex:SetWidth(16)
    frame.keybind_icon.tex:SetHeight(16)

    -- handle out of range as desaturation of keybind and icon
    _G[frame:GetName().."HotKey"].SetVertexColor = function(self, r, g, b, a)
      if r == 1.0 and g == 0.1 and b == 0.1 then
        _G[frame:GetName().."Icon"]:SetDesaturated(true)
        frame.keybind_icon.tex:SetDesaturated(true)
      else
        _G[frame:GetName().."Icon"]:SetDesaturated(false)
        frame.keybind_icon.tex:SetDesaturated(false)
      end
    end
  end
end

local a_x, a_y   = -220,  50
local b_x, b_y   = -180,  90
local x_x, x_y   = -260,  90
local y_x, y_y   = -220, 130
local r1_x, r1_y = -300, 150
local r2_x, r2_y = -260, 150

local local_offset = -175
a_x = a_x + local_offset
b_x = b_x + local_offset
x_x = x_x + local_offset
y_x = y_x + local_offset
r1_x = r1_x + local_offset
r2_x = r2_x + local_offset

local global_offset_x = 80
local global_offset_y = 0


local buttonmap = {
   -- right controls (a,b,x,y)
   { 1, "BOTTOMRIGHT", global_offset_x + a_x, global_offset_y + a_y, "Interface\\AddOns\\ShaguController\\img\\a", "BOTTOMRIGHT" },
   { 2, "BOTTOMRIGHT", global_offset_x + b_x, global_offset_y + b_y, "Interface\\AddOns\\ShaguController\\img\\b", "BOTTOMRIGHT" },
   { 3, "BOTTOMRIGHT", global_offset_x + x_x, global_offset_y + x_y, "Interface\\AddOns\\ShaguController\\img\\x", "BOTTOMRIGHT" },
   { 4, "BOTTOMRIGHT", global_offset_x + y_x, global_offset_y + y_y, "Interface\\AddOns\\ShaguController\\img\\y", "BOTTOMRIGHT" },
   -- right controls (r1,r2)
   { 5, "BOTTOMRIGHT", global_offset_x + r1_x, global_offset_y + r1_y, "Interface\\AddOns\\ShaguController\\img\\r1", "BOTTOMRIGHT" },
   { 6, "BOTTOMRIGHT", global_offset_x + r2_x, global_offset_y + r2_y, "Interface\\AddOns\\ShaguController\\img\\r2", "BOTTOMLEFT" },

   -- left controls (l1,l2)
   { 7, "BOTTOMLEFT",  global_offset_x - r1_x, global_offset_y + r1_y, "Interface\\AddOns\\ShaguController\\img\\l1", "BOTTOMLEFT" },
   { 8, "BOTTOMLEFT",  global_offset_x - r2_x, global_offset_y + r2_y, "Interface\\AddOns\\ShaguController\\img\\l2", "BOTTOMRIGHT" },

   { 9,  "BOTTOMLEFT", global_offset_x - x_x, global_offset_y + x_y, "Interface\\AddOns\\ShaguController\\img\\right", "BOTTOMLEFT" },
   { 10, "BOTTOMLEFT", global_offset_x - a_x, global_offset_y + a_y, "Interface\\AddOns\\ShaguController\\img\\down", "BOTTOMLEFT" },
   { 11, "BOTTOMLEFT", global_offset_x - b_x, global_offset_y + b_y, "Interface\\AddOns\\ShaguController\\img\\left", "BOTTOMLEFT" },
   { 12, "BOTTOMLEFT", global_offset_x - y_x, global_offset_y + y_y, "Interface\\AddOns\\ShaguController\\img\\up", "BOTTOMLEFT" },
}

ui.manage_positions = function(a1, a2, a3)
  logger.debug("manage_positions called.")

  -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: manage_positions.")

  -- bla = QuestLogMicroButton:GetParent()

  -- bla:ClearAllPoints()
  -- bla:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
  -- bla:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)

  -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: "..bla:GetName())

  -- MainMenuBarArtFrame:Hide()
  -- MainMenuBarArtFrame:ClearAllPoints()
  -- MainMenuBarArtFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  -- MainMenuBarArtFrame:SetFrameStrata("BACKGROUND")
  -- MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
  -- MainMenuBarArtFrame:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
  -- -- MainMenuBarArtFrame:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)
  -- MainMenuBarArtFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)



  -- MainMenuBarLeftEndCap:Hide();
  -- MainMenuBarRightEndCap:Hide();

  -- MainMenuBarArtFrame

  -- DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..MainMenuBarLeftEndCap:GetNumPoints());
  -- local a,b,c,d,e = MainMenuBarLeftEndCap:GetPoint(1);
  -- DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..a);
  -- DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..b:GetName());
  -- DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..c);
  -- DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..d);
  -- DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..e);

  -- if MainMenuBarLeftEndCap:GetNumPoints() == 2 then
  --   local a,b,c,d,e = MainMenuBarLeftEndCap:GetPoint(2);
  --   DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..a);
  --   DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..b:GetName());
  --   DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..c);
  --   DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..d);
  --   DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..e);
  -- end
  -- MainMenuBarLeftEndCap:ClearAllPoints();
  -- MainMenuBarLeftEndCap:SetPoint("RIGHT", MainMenuBarPerformanceBarFrame, "LEFT", 30, 30);
  -- MainMenuBarLeftEndCap:SetPoint("BOTTOM", MainMenuBarPerformanceBarFrame, "BOTTOM", 0, 0);
  -- MainMenuBarLeftEndCap:ClearAllPoints();
  -- MainMenuBarLeftEndCap:SetPoint("CENTER", UIParent, "CENTER", 30, 30);

  -- MainMenuExpBar:ClearAllPoints();
  -- MainMenuExpBar:SetPoint("TOP", UIParent, "BOTTOM", 0, 10);
  -- MainMenuExpBar:SetPoint("BOTTOM", UIParent, "BOTTOM");
  -- MainMenuExpBar:SetPoint("LEFT", MainMenuBar, "RIGHT");
  -- MainMenuExpBar:SetPoint("RIGHT", MainMenuBarPerformanceBarFrame, "LEFT");

  -- MainMenuBarLeftEndCap:SetPoint("RIGHT", UIParent, "CENTER", 0, 0)
  -- MainMenuBarLeftEndCap:SetPoint("BOTTOM", UIParent, "RIGHT", 0, -14)

  -- run original function first
  ui.manage_positions_hook(a1, a2, a3)

  -- move and skin all buttons
  for id, button in pairs(buttonmap) do
    ui:manage_button(unpack(button))
  end
  
  for i = 1, 12 do
    _G["ActionButton" .. i]:SetParent(UIParent)
  end

  -- move and resize chat
  ChatFrameEditBox:ClearAllPoints()
  ChatFrameEditBox:SetPoint("TOP", UIParent, "TOP", 0, -10)
  ChatFrameEditBox:SetWidth(300)
  ChatFrameEditBox:SetScale(2)

  -- on-screen keyboard helper
  ChatFrame1.oskHelper = ChatFrame1.oskHelper or CreateFrame("Button", nil, UIParent)
  ChatFrame1.oskHelper:SetFrameStrata("BACKGROUND")
  ChatFrame1.oskHelper:SetAllPoints(ChatFrame1)
  ChatFrame1.oskHelper:SetScript("OnClick", function()
    if not ChatFrameEditBox:IsVisible() then
      ChatFrameEditBox:Show()
      ChatFrameEditBox:Raise()
    else
      ChatFrameEditBox:Hide()
    end
  end)

  ChatFrame1.oskHelper:SetScript("OnUpdate", function()
    if ChatFrameEditBox:IsVisible() and this.state ~= 1 then
      -- put chat on top part of screen
      -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: Showing chat on top part of srceen.")

      ChatFrame1:SetScale(2)
      ChatFrame1:ClearAllPoints()
      ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
      ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "RIGHT", 0, -14)

      FCF_SetWindowColor(ChatFrame1, 0, 0, 0)
      FCF_SetWindowAlpha(ChatFrame1, .5)

      ChatFrame1.oskHelper:EnableMouse(true)

      this.state = 1
    elseif not ChatFrameEditBox:IsVisible() and this.state ~= 0 then
      -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: Reverting chat to bottom part of srceen.")
      -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: Anchoring to: "..anchor:GetName())
      ChatFrame1:SetScale(1)
      ChatFrame1:ClearAllPoints()
      ChatFrame1:SetPoint("BOTTOMLEFT", MainMenuExpBar, "TOPLEFT", 0, 0)
      ChatFrame1:SetPoint("TOP", MultiBarLeftButton7, "BOTTOM", 0, -15)

      function manageChatFrameTabs() 
        ChatFrame1Tab:SetPoint("BOTTOMLEFT", ChatFrame1Background, "TOPLEFT", 2, 0)
        ChatFrame1Tab:SetPoint("LEFT", MultiBarLeftButton7, "RIGHT", 10, 0)
        ChatFrame2Tab:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "BOTTOMRIGHT", 0, 0)

        ChatFrame2Tab:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "BOTTOMRIGHT", 0, 0)

        FCF_SetWindowColor(ChatFrame1, 0, 0, 0)
        FCF_SetWindowAlpha(ChatFrame1, 0.2)
      end
      manageChatFrameTabs()
      local chatFrame1TabOnClick = ChatFrame1Tab:GetScript("OnClick")
      ChatFrame1Tab:SetScript("OnClick", function()
        chatFrame1TabOnClick()
        manageChatFrameTabs()
      end)
      local chatFrame2TabOnClick = ChatFrame2Tab:GetScript("OnClick")
      ChatFrame2Tab:SetScript("OnClick", function()
        chatFrame2TabOnClick()
        manageChatFrameTabs()
      end)

      -- TODO: Consider setting to true and seeing if steam input supports:
      -- mouse area (x/y width/height) to click somewhere. This would make opening keyboard + opening chat 1 operation.
      ChatFrame1.oskHelper:EnableMouse(false)

      this.state = 0
    else
      -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: No doing anything.")
      -- ChatFrame1:ClearAllPoints()
      -- ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
      -- ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "RIGHT", 0, -14)
    end
  end)

  -- move and hide some chat buttons
  ChatFrameMenuButton:Hide()
  ChatFrameMenuButton.Show = function() return end

  for i=1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i.."BottomButton"]:ClearAllPoints()
    _G["ChatFrame"..i.."BottomButton"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..i], "BOTTOMRIGHT", 0, -5)

    _G["ChatFrame"..i.."DownButton"]:ClearAllPoints()
    _G["ChatFrame"..i.."DownButton"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..i.."BottomButton"], "TOPLEFT", 0, -7)

    _G["ChatFrame"..i.."UpButton"]:ClearAllPoints()
    _G["ChatFrame"..i.."UpButton"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..i.."DownButton"], "TOPLEFT", 0, -7)
  end

  -- Remove stuff from mainmenubar
  for _, child in ipairs({ MainMenuBar:GetChildren() }) do
    child:SetParent(UIParent)
  end
  MainMenuBar:Hide()

  -- BonusActionBarButtons are inside a parent that. Outright hiding this frame causes
  -- keybinds not to work for classes that use it. Disabling mouse works just fine.
  BonusActionBarFrame:EnableMouse(false)
  -- BonusActionBarFrame:SetBackdrop({
  --   bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  --   edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  --   edgeSize = 16,
  --   insets = { left = 4, right = 4, top = 4, bottom = 4 },
  -- })
  -- BonusActionBarFrame:SetBackdropColor(0, 0, 1, .5)

  -- Move cast bar
  CastingBarFrame:ClearAllPoints()
  CastingBarFrame:SetPoint("TOP", ActionButton6, "BOTTOM", 0, -10)
  CastingBarFrame:SetPoint("RIGHT", ActionButton4, "LEFT", 0, 0)
  -- CastingBarFrame:SetPoint("LEFT", ActionButton8, "BOTTOM", 0, -10)
  -- CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", -50, 0)

  -- move pet action bar
  local anchor = UIParent
  anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
  anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
  anchor = ShapeshiftBarFrame:IsVisible() and ShapeshiftBarFrame or anchor
  PetActionBarFrame:ClearAllPoints()
  PetActionBarFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 3)

  -- move shapeshift bar
  local anchor = UIParent
  anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
  anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
  ShapeshiftBarFrame:ClearAllPoints()
  ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 15, -5)

  -- move normal action bars
  MultiBarBottomRight:ClearAllPoints()
  MultiBarBottomRight:SetPoint("RIGHT", UIParent, "RIGHT", 75, 0)
  MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 151)
  
  local multiBarBottomScale = 0.65
  MultiBarBottomRight:SetScale(multiBarBottomScale)
  
  MultiBarBottomRightButton7:ClearAllPoints()
  MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 0)
  MultiBarBottomLeftButton7:ClearAllPoints()
  MultiBarBottomLeftButton7:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 0)

  MultiBarBottomLeft:ClearAllPoints()
  -- MultiBarBottomLeft:SetPoint("RIGHT", UIParent, "RIGHT", -5, 0)
  -- MultiBarBottomLeft:SetPoint("BOTTOM", MultiBarBottomRight, "BOTTOM", 0, 51)
  MultiBarBottomLeft:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", 0, 35)
  MultiBarBottomLeft:SetPoint("BOTTOMRIGHT", MultiBarBottomRight, "TOPRIGHT", 0, 5)
  MultiBarBottomLeft:SetScale(multiBarBottomScale)

  MultiBarLeft:ClearAllPoints()
  MultiBarLeft:SetFrameStrata("MEDIUM")
  MultiBarLeft:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 5, -5)
  -- MultiBarLeft:SetPoint("TOP", UIParent, "TOP", 0, -5)
  MultiBarLeft:SetScale(1.6)

  local leftbarbuttonthatisright = MultiBarLeftButton8

  leftbarbuttonthatisright:ClearAllPoints()
  leftbarbuttonthatisright:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -5, -125)
  -- for i = 8, 12 do
  --   _G["MultiBarLeftButton"..i]:ClearAllPoints()
  -- end

  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT", leftbarbuttonthatisright, "LEFT", -8, 0)
  MultiBarRight:SetPoint("BOTTOM", MainMenuBarBackpackButton, "TOP", 0, 0)
  -- MultiBarRight:SetScale(2)
  -- ActionBar4:ClearAllPoints()
  -- ActionBar4:SetScale(2)
  -- ActionBar5:ClearAllPoints()
  -- ActionBar5:SetScale(3)
  
  -- experience bar
  MainMenuExpBar:ClearAllPoints()
  MainMenuExpBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
  -- MainMenuExpBar:SetPoint("BOTTOM", UIParent, "BOTTOM")
  -- MainMenuExpBar:SetPoint("TOP", UIParent, "BOTTOM", 0, 10)
  MainMenuXPBarTexture0:SetPoint("LEFT", MainMenuExpBar, "LEFT")
  MainMenuXPBarTexture0:SetPoint("RIGHT", MainMenuExpBar, "CENTER")
  MainMenuXPBarTexture1:SetPoint("RIGHT", MainMenuExpBar, "RIGHT")
  MainMenuXPBarTexture1:SetPoint("LEFT", MainMenuExpBar, "CENTER")

  -- reputation bar
  -- Its being problematic somehow.
  ReputationWatchBar:Hide()
  ReputationWatchBar:ClearAllPoints()
  ReputationWatchBar:SetPoint("BOTTOMLEFT", MainMenuXPBarTexture0, "TOPLEFT", 0, 0)
  ReputationWatchBar:SetPoint("BOTTOMRIGHT", MainMenuXPBarTexture0, "TOPRIGHT", 0, 0)
  ReputationWatchBarTexture0:SetPoint("LEFT", ReputationWatchBar, "LEFT")
  ReputationWatchBarTexture0:SetPoint("RIGHT", ReputationWatchBar, "CENTER")
  ReputationWatchBarTexture1:SetPoint("RIGHT", ReputationWatchBar, "RIGHT")
  ReputationWatchBarTexture1:SetPoint("LEFT", ReputationWatchBar, "CENTER")

  -- move elements for reduced actionbar size
  MainMenuMaxLevelBar0:SetPoint("LEFT", UIParent, "LEFT")
  -- MainMenuBarTexture2:Hide();
  -- MainMenuBarTexture2:SetPoint("LEFT", UIParent, "LEFT")
  -- MainMenuBarTexture3:SetPoint("RIGHT", UIParent, "RIGHT")
  MainMenuBarTexture2:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")

  -- MainMenuBarArtFrame:Hide()
  -- ActionBarDownButton:Hide()
  -- ActionBarUpButton:Hide()
  -- ActionBarDownButton:SetParent(UIParent)
  -- ActionBarUpButton:SetParent(UIParent)
  -- ActionBarDownButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -7, -5)
  -- ActionBarUpButton:SetPoint("BOTTOMLEFT", ActionBarDownButton, "TOPLEFT", 0, -13)
  -- MainMenuBarArtFrame:ClearAllPoints()
  -- MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

  -- MainMenuBarPageNumber:ClearAllPoints()
  -- MainMenuBarPageNumber:SetPoint("BOTTOMLEFT", ActionBarDownButton, "TOPRIGHT", 0, -10)
  -- CharacterMicroButton:ClearAllPoints()
  -- CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
  -- CharacterMicroButton:SetPoint("BOTTOM", UIParent, "LEFT", 35, 0)

  -- latency thingy
  MainMenuBarPerformanceBarFrame:SetPoint("RIGHT", KeyRingButton, "LEFT", 0, 0)

  -- REGION START - MICROBUTTONS
  local microButtonAnchor = UIParent
  local gap = 0
  local microButtonRelativeTo = "BOTTOMRIGHT"
  
  for _, microButton in ipairs({
    HelpMicroButton,
    MainMenuMicroButton,
    WorldMapMicroButton,
    SocialsMicroButton,
    TalentMicroButton,
    QuestLogMicroButton,
    SpellbookMicroButton,
    CharacterMicroButton,
  }) do
    microButton:ClearAllPoints()
    microButton:SetParent(UIParent)
    microButton:SetPoint("BOTTOMRIGHT", microButtonAnchor, microButtonRelativeTo, gap, 0)
    microButtonAnchor = microButton
    microButtonRelativeTo = "BOTTOMLEFT"
    gap = 3
  end
  -- REGION END - MICROBUTTONS

  -- REGION START - Bags
  local bagAnchor = HelpMicroButton
  for i = 0, 3 do
    _G["CharacterBag" .. i .. "Slot"]:SetParent(UIParent)
  end
  MainMenuBarBackpackButton:ClearAllPoints()
  MainMenuBarBackpackButton:SetParent(UIParent)
  MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", bagAnchor, "TOPRIGHT", 0, -20)
  KeyRingButton:SetParent(UIParent)
  -- REGION END - Bags

  -- REGION START - griphons
  MainMenuBarLeftEndCap:Hide()
  MainMenuBarRightEndCap:Hide()
  -- REGION END - griphons

  MainMenuBarArtFrame:Hide()

  -- move pfQuest arrow if existing
  if pfQuest and pfQuest.route and pfQuest.route.arrow then
    pfQuest.route.arrow:SetPoint("CENTER", 0, -120)
  end
end

-- save to main frame
ShaguController.ui = ui

logger.info("ui loaded.")-- Function to show all action bars
local function ShowAllActionBars()
    -- Enable bottom left action bar, bottom right action bar, right action bar, and right action bar 2
    SetActionBarToggles(1, 1, 1, 1)
end

-- Call the function when the player logs in or reloads the UI
local showAllActionBarsFrame = CreateFrame("Frame")
showAllActionBarsFrame:RegisterEvent("PLAYER_LOGIN")
showAllActionBarsFrame:SetScript("OnEvent", ShowAllActionBars)

