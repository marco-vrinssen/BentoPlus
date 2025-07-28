-- Define menu constants and valid context configurations

local copyMenuText = "Copy Full Name"
local copyDialogTitle = "Copy Full Name"

local allowedContextTags = {
  MENU_LFG_FRAME_SEARCH_ENTRY = 1,
  MENU_LFG_FRAME_MEMBER_APPLY = 1
}

local allowedContextTypes = {
  PLAYER = true,
  PARTY = true,
  RAID_PLAYER = true,
  FRIEND = true,
  GUILD = true,
  COMMUNITIES_GUILD_MEMBER = true,
  COMMUNITIES_WOW_MEMBER = true,
  BN_FRIEND = true,
  SELF = true,
  ENEMY_PLAYER = true,
  OTHER_PLAYER = true,
  ARENA_ENEMY = true,
  BATTLEGROUND_ENEMY = true
}

-- Parse player name and realm from combined string

local function parsePlayerName(fullName)
  if not fullName then
    return nil, nil
  end

  local name, realm = string.match(fullName, "^([^-]+)-(.+)$")
  if name and realm then
    return name, realm
  end

  return fullName, GetRealmName()
end

-- Extract player data from group finder context

local function getGroupFinderPlayer(owner)
  local resultID = owner.resultID
  if resultID then
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
    if searchResultInfo and searchResultInfo.leaderName then
      return parsePlayerName(searchResultInfo.leaderName)
    end
  end

  local memberIdx = owner.memberIdx
  if not memberIdx then
    return nil, nil
  end

  local parent = owner:GetParent()
  if not parent then
    return nil, nil
  end

  local applicantID = parent.applicantID
  if not applicantID then
    return nil, nil
  end

  local fullName = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
  if fullName then
    return parsePlayerName(fullName)
  end

  return nil, nil
end

-- Extract player data from battlenet account

local function getBattlenetPlayer(accountInfo)
  if not accountInfo or not accountInfo.gameAccountInfo then
    return nil, nil
  end

  local gameInfo = accountInfo.gameAccountInfo
  return gameInfo.characterName, gameInfo.realmName
end

-- Resolve player data from menu context

local function resolveContextPlayer(owner, rootDescription, contextData)
  if not contextData then
    local tagType = allowedContextTags[rootDescription.tag]
    if tagType == 1 then
      return getGroupFinderPlayer(owner)
    end
    return nil, nil
  end

  if contextData.name and contextData.server then
    return contextData.name, contextData.server
  end

  local unit = contextData.unit
  if unit and UnitExists(unit) then
    local name, realm = parsePlayerName(UnitName(unit))
    if contextData.server then
      realm = contextData.server
    end
    return name, realm
  end

  if contextData.accountInfo then
    local name, realm = getBattlenetPlayer(contextData.accountInfo)
    if name and realm then
      return name, realm
    end
  end

  if contextData.name then
    return parsePlayerName(contextData.name)
  end

  if contextData.friendsList then
    local friendInfo = C_FriendList.GetFriendInfoByIndex(contextData.friendsList)
    if friendInfo and friendInfo.name then
      return parsePlayerName(friendInfo.name)
    end
  end

  return nil, nil
end

-- Validate menu context for addon usage

local function validateMenuContext(rootDescription, contextData)
  if not contextData then
    return allowedContextTags[rootDescription.tag] == 1
  end

  local which = contextData.which
  return which and allowedContextTypes[which]
end

-- Create modal dialog for text copying

local function createCopyDialog(text)
  if not text then
    return
  end

  local frame = CreateFrame("Frame", "CopyFullNameFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(500, 150)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame:SetFrameStrata("DIALOG")
  frame:SetFrameLevel(100)

  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.title:SetPoint("TOP", frame.TitleBg, "TOP", 0, -5)
  frame.title:SetText(copyDialogTitle)

  local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
  editBox:SetSize(460, 30)
  editBox:SetPoint("CENTER", frame, "CENTER", 0, 10)
  editBox:SetText(text)
  editBox:SetAutoFocus(true)
  editBox:HighlightText()
  editBox:SetScript("OnEscapePressed", function()
    frame:Hide()
  end)
  editBox:SetScript("OnEnterPressed", function()
    frame:Hide()
  end)

  local function handleCopyKey(_, key)
    local isCtrlOrCmd = IsControlKeyDown() or IsMetaKeyDown()
    if key == "C" and isCtrlOrCmd then
      editBox:HighlightText()
      editBox:SetFocus()

      C_Timer.After(0.1, function()
        if frame:IsShown() then
          frame:Hide()
        end
      end)
    end
  end

  editBox:SetScript("OnKeyDown", handleCopyKey)
  editBox:EnableKeyboard(true)
  editBox:SetScript("OnShow", function(self)
    self:SetFocus()
  end)

  local instruction = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  instruction:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
  instruction:SetText("Press Ctrl+C (Cmd+C on Mac) to copy")

  frame:Show()
end

-- Add copy name option to context menu

local function addCopyNameOption(owner, rootDescription, contextData)
  if not validateMenuContext(rootDescription, contextData) then
    return
  end

  local name, realm = resolveContextPlayer(owner, rootDescription, contextData)

  if name and realm then
    rootDescription:CreateDivider()
    rootDescription:CreateButton(copyMenuText, function()
      local copyText = string.format("%s-%s", name, realm)
      createCopyDialog(copyText)
    end)
  end
end

-- Register context menu hooks for all player types

local function registerMenuHooks()
  if not (Menu and Menu.ModifyMenu) then
    return
  end

  local success, err = pcall(function()
    local modifyMenu = Menu.ModifyMenu

    modifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", addCopyNameOption)
    modifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", addCopyNameOption)
    modifyMenu("MENU_UNIT_PLAYER", addCopyNameOption)
    modifyMenu("MENU_UNIT_PARTY", addCopyNameOption)
    modifyMenu("MENU_UNIT_RAID_PLAYER", addCopyNameOption)
    modifyMenu("MENU_UNIT_FRIEND", addCopyNameOption)
    modifyMenu("MENU_UNIT_GUILD", addCopyNameOption)
    modifyMenu("MENU_UNIT_COMMUNITIES_GUILD_MEMBER", addCopyNameOption)
    modifyMenu("MENU_UNIT_COMMUNITIES_WOW_MEMBER", addCopyNameOption)
    modifyMenu("MENU_UNIT_BN_FRIEND", addCopyNameOption)
    modifyMenu("MENU_UNIT_SELF", addCopyNameOption)
    modifyMenu("MENU_UNIT_ENEMY_PLAYER", addCopyNameOption)
    modifyMenu("MENU_UNIT_OTHER_PLAYER", addCopyNameOption)
    modifyMenu("MENU_UNIT_ARENA_ENEMY", addCopyNameOption)
    modifyMenu("MENU_UNIT_BATTLEGROUND_ENEMY", addCopyNameOption)
  end)

  if not success then
    print("|cffff0000Error registering menu hooks:|r " .. tostring(err))
  end
end

-- Initialize addon functionality

local function initializeAddon()
  registerMenuHooks()
end

-- Handle addon loading events

local contextMenuEventFrame = CreateFrame("Frame")
contextMenuEventFrame:RegisterEvent("ADDON_LOADED")
contextMenuEventFrame:SetScript("OnEvent", function(_, _, addonName)
  if addonName == "BentoPlus" then
    initializeAddon()
    contextMenuEventFrame:UnregisterEvent("ADDON_LOADED")
  end
end)