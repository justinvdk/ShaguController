local _G = _G or getfenv(0)

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
for id, frame in pairs(resizes) do frame:SetWidth(488) end

  -- hide reduced frames
for id, frame in pairs(frames) do hide(frame) end

-- clear reduced textures
for id, frame in pairs(textures) do hide(frame, 1) end

-- clear some button textures
for id, frame in pairs(normtextures) do hide(frame, 2) end

local ui = CreateFrame("Frame", "ShaguControllerUI", UIParent)
ui:RegisterEvent("PLAYER_ENTERING_WORLD")
ui:SetScript("OnEvent", function()
  -- update ui when frame positions get managed
  ui.manage_positions_hook = UIParent_ManageFramePositions
  UIParent_ManageFramePositions = ui.manage_positions
  -- ui:UnregisterAllEvents()
end)

ui.manage_button = function(self, frame, pos, x, y, image)
  -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: manage_button.")
  if frame and tonumber(frame) then
    self:manage_button(_G["ActionButton" .. frame], pos, x, y, image)
    self:manage_button(_G["BonusActionButton" .. frame], pos, x, y, image)
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
    frame.keybind_icon.tex:SetPoint("TOPRIGHT", frame.keybind_icon, "TOPRIGHT", 0, 0)
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

local buttonmap = {
   -- dummy jump button

   -- right controls (a,b,x,y)
   { 1, "BOTTOMRIGHT", -220,  45, "Interface\\AddOns\\ShaguController\\img\\a" },
   { 2, "BOTTOMRIGHT", -175,  90, "Interface\\AddOns\\ShaguController\\img\\b" },
   { 3, "BOTTOMRIGHT", -265,  90, "Interface\\AddOns\\ShaguController\\img\\x" },
   { 4, "BOTTOMRIGHT", -220, 135, "Interface\\AddOns\\ShaguController\\img\\y" },
   -- right controls (r1,r2)
   { 5, "BOTTOMRIGHT", -265, 150, "Interface\\AddOns\\ShaguController\\img\\up" },
   { 6, "BOTTOMRIGHT", -270, 190, "Interface\\AddOns\\ShaguController\\img\\up" },

   -- left controls (l1,l2)
   { 7, "BOTTOMLEFT",  265,  150, "Interface\\AddOns\\ShaguController\\img\\up" },
   { 8, "BOTTOMLEFT",  270,  190, "Interface\\AddOns\\ShaguController\\img\\up" },

   { 9,  "BOTTOMLEFT", 265, 90, "Interface\\AddOns\\ShaguController\\img\\right" },
   { 10, "BOTTOMLEFT", 220, 45, "Interface\\AddOns\\ShaguController\\img\\down" },
   { 11, "BOTTOMLEFT", 175, 90, "Interface\\AddOns\\ShaguController\\img\\left" },
   { 12, "BOTTOMLEFT", 220, 135, "Interface\\AddOns\\ShaguController\\img\\up" },
}

ui.manage_positions = function(a1, a2, a3)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: manage_positions.")

  -- bla = QuestLogMicroButton:GetParent()

  -- bla:ClearAllPoints()
  -- bla:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
  -- bla:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)

  -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: "..bla:GetName())

  -- jk
  -- MainMenuBarArtFrame:ClearAllPoints()
  -- MainMenuBarArtFrame:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
  -- -- MainMenuBarArtFrame:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)
  -- MainMenuBarArtFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)



  -- MainMenuBarLeftEndCap:Hide();
  -- MainMenuBarRightEndCap:Hide();

  -- MainMenuBarArtFrame

  DEFAULT_CHAT_FRAME:AddMessage("--------------------: "..MainMenuBarLeftEndCap:GetNumPoints());
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
      DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: Showing chat on top part of srceen.")

      ChatFrame1:SetScale(2)
      ChatFrame1:ClearAllPoints()
      ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
      ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "RIGHT", 0, -14)

      FCF_SetWindowColor(ChatFrame1, 0, 0, 0)
      FCF_SetWindowAlpha(ChatFrame1, .5)

      this.state = 1
    elseif not ChatFrameEditBox:IsVisible() and this.state ~= 0 then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: Reverting chat to bottom part of srceen.")

      local anchor = MainMenuBarArtFrame
      anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
      anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
      anchor = ShapeshiftBarFrame:IsVisible() and ShapeshiftBarFrame or anchor
      anchor = PetActionBarFrame:IsVisible() and PetActionBarFrame or anchor

      ChatFrame1:SetScale(1)
      ChatFrame1:ClearAllPoints()
      ChatFrame1:SetPoint("LEFT", MultiBarBottomLeft, "LEFT", 17, 0)
      ChatFrame1:SetPoint("RIGHT", MultiBarBottomLeft, "RIGHT", -17, 0)
      -- ChatFrame1:SetPoint("BOTTOM", anchor, "TOP", 0, 13)
      ChatFrame1:SetPoint("BOTTOM", anchor, "TOP", 0, 13)
      ChatFrame1:SetPoint("TOP", anchor, "TOP", 0, 200)

      FCF_SetWindowColor(ChatFrame1, 0, 0, 0)
      FCF_SetWindowAlpha(ChatFrame1, 0)

      this.state = 0
    else
      -- DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Shagu|cffffffffController: No doing anything.")
      ChatFrame1:ClearAllPoints()
      ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
      ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "RIGHT", 0, -14)

    end
  end)

  -- move and hide some chat buttons
  ChatFrameMenuButton:Hide()
  ChatFrameMenuButton.Show = function() return end

  for i=1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i.."BottomButton"]:ClearAllPoints()
    _G["ChatFrame"..i.."BottomButton"]:SetPoint("BOTTOMRIGHT", _G["ChatFrame"..i], "BOTTOMRIGHT", 0, -5)


    _G["ChatFrame"..i.."DownButton"]:ClearAllPoints()
    _G["ChatFrame"..i.."DownButton"]:SetPoint("RIGHT", _G["ChatFrame"..i.."BottomButton"], "LEFT", 0, 0)

    _G["ChatFrame"..i.."UpButton"]:ClearAllPoints()
    _G["ChatFrame"..i.."UpButton"]:SetPoint("RIGHT", _G["ChatFrame"..i.."DownButton"], "LEFT", 0, 0)

  end

  -- move pet action bar
  local anchor = MainMenuBarArtFrame
  anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
  anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
  anchor = ShapeshiftBarFrame:IsVisible() and ShapeshiftBarFrame or anchor
  PetActionBarFrame:ClearAllPoints()
  PetActionBarFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 3)

  -- move shapeshift bar
  local anchor = MainMenuBarArtFrame
  anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
  anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
  ShapeshiftBarFrame:ClearAllPoints()
  ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 15, -5)

  -- move normal action bars
  MultiBarBottomLeft:ClearAllPoints()
  MultiBarBottomLeft:SetPoint("LEFT", UIParent, "LEFT", 5, 0)
  MultiBarBottomLeft:SetPoint("BOTTOM", HelpMicroButton, "TOP", 0, 20)

  MultiBarBottomRight:ClearAllPoints()
  MultiBarBottomRight:SetPoint("RIGHT", UIParent, "RIGHT", 5, 0)
  MultiBarBottomRight:SetPoint("BOTTOM", HelpMicroButton, "TOP", 0, 20)

  -- experience bar
  MainMenuXPBarTexture0:SetPoint("LEFT", MainMenuExpBar, "LEFT")
  MainMenuXPBarTexture1:SetPoint("RIGHT", MainMenuExpBar, "RIGHT")

  -- reputation bar
  ReputationWatchBar:SetPoint("BOTTOM", MainMenuExpBar, "TOP", 0, 0)
  ReputationWatchBarTexture0:SetPoint("LEFT", ReputationWatchBar, "LEFT")
  ReputationWatchBarTexture1:SetPoint("RIGHT", ReputationWatchBar, "RIGHT")

  -- move elements for reduced actionbar size
  MainMenuMaxLevelBar0:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT")
  MainMenuBarTexture2:Hide();
  MainMenuBarTexture3:Hide();
  MainMenuBarTexture2:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT")
  MainMenuBarTexture3:SetPoint("RIGHT", MainMenuBarArtFrame, "RIGHT")

  ActionBarDownButton:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "BOTTOMLEFT", -5, -5)
  ActionBarUpButton:SetPoint("TOPLEFT", MainMenuBarArtFrame, "TOPLEFT", -5, -5)
  MainMenuBarPageNumber:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT", 25, -5)
  CharacterMicroButton:SetPoint("LEFT", UIParent, "LEFT", 0, 0)

  -- latency thingy
  MainMenuBarPerformanceBarFrame:SetPoint("RIGHT", KeyRingButton, "LEFT", 0, 0)

  -- bags
  MainMenuBarBackpackButton:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)

  -- griphons
  MainMenuBarLeftEndCap:SetPoint("RIGHT", MainMenuBarPerformanceBarFrame, "LEFT", 25, 0)
  MainMenuBarRightEndCap:SetPoint("LEFT", HelpMicroButton, "RIGHT", -25, 0)

  -- move pfQuest arrow if existing
  if pfQuest and pfQuest.route and pfQuest.route.arrow then
    pfQuest.route.arrow:SetPoint("CENTER", 0, -120)
  end
end

-- save to main frame
ShaguController.ui = ui
