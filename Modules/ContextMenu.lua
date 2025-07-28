-- Define constants for menu text, dialog titles, and valid context types.

local menuText = "Copy Full Name"
local dialogTitle = "Copy Full Name"

local validContextTags = {
  MENU_LFG_FRAME_SEARCH_ENTRY = 1,
  MENU_LFG_FRAME_MEMBER_APPLY = 1
}

local validContextTypes = {
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
  OTHER_PLAYER = true
}

-- Extract the name and realm from a full name string.

local function extractNameAndRealm(fullName)
  if not fullName then
    return nil, nil
  end

  local name, realm = string.match(fullName, "^([^-]+)-(.+)$")
  if name and realm then
    return name, realm
  end

  return fullName, GetRealmName()
end

-- Get player information from the LFG context.

local function getLFGPlayerInfo(owner)
  local resultID = owner.resultID
  if resultID then
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
    if searchResultInfo and searchResultInfo.leaderName then
      return extractNameAndRealm(searchResultInfo.leaderName)
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
    return extractNameAndRealm(fullName)
  end

  return nil, nil
end

-- Get player information from a Battle.net account.

local function getBNetPlayerInfo(accountInfo)
  if not accountInfo or not accountInfo.gameAccountInfo then
    return nil, nil
  end

  local gameInfo = accountInfo.gameAccountInfo
  return gameInfo.characterName, gameInfo.realmName
end

-- Get player information from the menu context data.

local function getPlayerInfoFromContext(owner, rootDescription, contextData)
  if not contextData then
    local tagType = validContextTags[rootDescription.tag]
    if tagType == 1 then
      return getLFGPlayerInfo(owner)
    end
    return nil, nil
  end

  if contextData.name and contextData.server then
    return contextData.name, contextData.server
  end

  local unit = contextData.unit
  if unit and UnitExists(unit) then
    local name, realm = extractNameAndRealm(UnitName(unit))
    if contextData.server then
      realm = contextData.server
    end
    return name, realm
  end

  if contextData.accountInfo then
    local name, realm = getBNetPlayerInfo(contextData.accountInfo)
    if name and realm then
      return name, realm
    end
  end

  if contextData.name then
    return extractNameAndRealm(contextData.name)
  end

  if contextData.friendsList then
    local friendInfo = C_FriendList.GetFriendInfoByIndex(contextData.friendsList)
    if friendInfo and friendInfo.name then
      return extractNameAndRealm(friendInfo.name)
    end
  end

  return nil, nil
end

-- Validate the menu context for addon functionality.

local function isValidMenuContext(rootDescription, contextData)
  if not contextData then
    return validContextTags[rootDescription.tag] == 1
  end

  local which = contextData.which
  return which and validContextTypes[which]
end

-- Create a copy dialog with auto-close functionality.

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
  frame.title:SetText(dialogTitle)

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

-- Add a menu option for copying a player's name.

local function addCopyNameOption(owner, rootDescription, contextData)
  if not isValidMenuContext(rootDescription, contextData) then
    return
  end

  local name, realm = getPlayerInfoFromContext(owner, rootDescription, contextData)

  if name and realm then
    rootDescription:CreateDivider()
    rootDescription:CreateButton(menuText, function()
      local copyText = string.format("%s-%s", name, realm)
      createCopyDialog(copyText)
    end)
  end
end

-- Register menu hooks for right-click context menus.

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
  end)

  if not success then
    print("|cffff0000Error registering menu hooks:|r " .. tostring(err))
  end
end

-- Initialize the addon when it loads.

local function initializeAddon()
  registerMenuHooks()
end

-- Register the addon loading event.

local contextMenuEventFrame = CreateFrame("Frame")
contextMenuEventFrame:RegisterEvent("ADDON_LOADED")
contextMenuEventFrame:SetScript("OnEvent", function(_, _, addonName)
  if addonName == "BentoPlus" then
    initializeAddon()
    contextMenuEventFrame:UnregisterEvent("ADDON_LOADED")
  end
end)