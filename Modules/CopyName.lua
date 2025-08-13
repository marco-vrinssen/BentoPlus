-- Update menu constants and valid contexts so that we scope copy action

local allowedMenuTags = {
    MENU_LFG_FRAME_SEARCH_ENTRY = 1,
    MENU_LFG_FRAME_MEMBER_APPLY = 1
}

local allowedPlayerTypes = {
    PLAYER = true,
    PARTY = true,
    RAID_PLAYER = true,
    FRIEND = true,
    BN_FRIEND = true,
    SELF = true,
    OTHER_PLAYER = true,
    ENEMY_PLAYER = true,
    TARGET = true,
    FOCUS = true
}

-- Parse player name and realm from full name string

local function parseNameRealm(fullName)
    if not fullName then
        return nil, nil
    end

    local playerName, realmName = string.match(fullName, "^([^-]+)-(.+)$")
    return playerName or fullName, realmName or GetRealmName()
end

-- Extract player from group finder context frames

local function extractFinderPlayer(frameOwner)
    if frameOwner.resultID then
        local searchResultInfo = C_LFGList.GetSearchResultInfo(frameOwner.resultID)
        if searchResultInfo and searchResultInfo.leaderName then
            return parseNameRealm(searchResultInfo.leaderName)
        end
    end

    if frameOwner.memberIdx then
        local parentFrame = frameOwner:GetParent()
        if parentFrame and parentFrame.applicantID then
            local applicantFullName = C_LFGList.GetApplicantMemberInfo(parentFrame.applicantID, frameOwner.memberIdx)
            if applicantFullName then
                return parseNameRealm(applicantFullName)
            end
        end
    end

    return nil, nil
end

-- Extract player from battlenet account info

local function extractBattlenetPlayer(battlenetInfo)
    if battlenetInfo and battlenetInfo.gameAccountInfo then
        local gameAccountInfo = battlenetInfo.gameAccountInfo
        return gameAccountInfo.characterName, gameAccountInfo.realmName
    end
    return nil, nil
end

-- Resolve player name and realm from menu context

local function resolveMenuPlayer(frameOwner, menuRootDescription, menuContext)
    if not menuContext then
        if allowedMenuTags[menuRootDescription.tag] == 1 then
            return extractFinderPlayer(frameOwner)
        end
        return nil, nil
    end

    if menuContext.name and menuContext.server then
        return menuContext.name, menuContext.server
    end

    if menuContext.unit and UnitExists(menuContext.unit) then
        local unitFullName = UnitName(menuContext.unit)
        if unitFullName then
            local playerName, realmName = parseNameRealm(unitFullName)
            return playerName, menuContext.server or realmName
        end
    end

    if menuContext.accountInfo then
        local playerName, realmName = extractBattlenetPlayer(menuContext.accountInfo)
        if playerName and realmName then
            return playerName, realmName
        end
    end

    if menuContext.name then
        return parseNameRealm(menuContext.name)
    end

    if menuContext.friendsList then
        local friendInfo = C_FriendList.GetFriendInfoByIndex(menuContext.friendsList)
        if friendInfo and friendInfo.name then
            return parseNameRealm(friendInfo.name)
        end
    end

    if menuContext.chatTarget then
        return parseNameRealm(menuContext.chatTarget)
    end

    if menuContext.lineID and menuContext.chatFrame then
        local messageInfo = menuContext.chatFrame:GetMessageInfo(menuContext.lineID)
        if messageInfo and messageInfo.sender then
            return parseNameRealm(messageInfo.sender)
        end
    end

    return nil, nil
end

-- Validate that menu context is allowed for copy option

local function validateMenuPlayer(menuRootDescription, menuContext)
    if not menuContext then
        return allowedMenuTags[menuRootDescription.tag] ~= nil
    end
    
    if menuContext.which and allowedPlayerTypes[menuContext.which] then
        return true
    end
    
    return false
end

-- Create dialog showing copyable full player name

local function createCopyDialog(playerNameText)
    local dialogFrame = CreateFrame("Frame", "CopyFullNameFrame", UIParent, "BasicFrameTemplateWithInset")
    dialogFrame:SetSize(500, 150)
    dialogFrame:SetPoint("CENTER")
    dialogFrame:SetMovable(true)
    dialogFrame:EnableMouse(true)
    dialogFrame:RegisterForDrag("LeftButton")
    dialogFrame:SetScript("OnDragStart", dialogFrame.StartMoving)
    dialogFrame:SetScript("OnDragStop", dialogFrame.StopMovingOrSizing)
    dialogFrame:SetFrameStrata("DIALOG")
    dialogFrame:SetFrameLevel(100)

    dialogFrame.title = dialogFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    dialogFrame.title:SetPoint("TOP", dialogFrame.TitleBg, "TOP", 0, -5)
    dialogFrame.title:SetText("Copy Full Name")

    local playerNameEditBox = CreateFrame("EditBox", nil, dialogFrame, "InputBoxTemplate")
    playerNameEditBox:SetSize(460, 30)
    playerNameEditBox:SetPoint("CENTER", dialogFrame, "CENTER", 0, 10)
    playerNameEditBox:SetText(playerNameText)
    playerNameEditBox:SetAutoFocus(true)
    playerNameEditBox:HighlightText()
    playerNameEditBox:SetScript("OnEscapePressed", function() dialogFrame:Hide() end)
    playerNameEditBox:SetScript("OnEnterPressed", function() dialogFrame:Hide() end)
    playerNameEditBox:SetScript("OnKeyDown", function(_, pressedKey)
        if pressedKey == "C" and (IsControlKeyDown() or IsMetaKeyDown()) then
            playerNameEditBox:HighlightText()
            playerNameEditBox:SetFocus()
            C_Timer.After(0, function()
                if dialogFrame:IsShown() then
                    dialogFrame:Hide()
                end
            end)
        end
    end)
    playerNameEditBox:EnableKeyboard(true)
    playerNameEditBox:SetScript("OnShow", function(self) self:SetFocus() end)

    local copyHelp = dialogFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    copyHelp:SetPoint("BOTTOM", dialogFrame, "BOTTOM", 0, 20)
    copyHelp:SetText("Press Ctrl+C (Cmd+C on macOS) to copy the name.")

    dialogFrame:Show()
end

-- Add menu button to copy full player name

local function addCopyMenu(frameOwner, menuRootDescription, menuContext)
    if InCombatLockdown() then
        return
    end

    if not validateMenuPlayer(menuRootDescription, menuContext) then
        return
    end

    local playerName, realmName = resolveMenuPlayer(frameOwner, menuRootDescription, menuContext)
    if playerName and realmName then
        local success = pcall(function()
            menuRootDescription:CreateDivider()
            menuRootDescription:CreateButton("Copy Full Name", function()
                if not InCombatLockdown() then
                    createCopyDialog(string.format("%s-%s", playerName, realmName))
                end
            end)
        end)
        
        if not success then
            return
        end
    end
end

-- Register modification hooks for relevant player menus

local function registerMenuHooks()
    if not (Menu and Menu.ModifyMenu) then
        return
    end

    pcall(function()
        Menu.ModifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", addCopyMenu)
        Menu.ModifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_PLAYER", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_PARTY", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_FRIEND", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_BN_FRIEND", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_SELF", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_OTHER_PLAYER", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_ENEMY_PLAYER", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_TARGET", addCopyMenu)
        Menu.ModifyMenu("MENU_UNIT_FOCUS", addCopyMenu)
        Menu.ModifyMenu("MENU_CHAT_LOG_LINK", addCopyMenu)
        Menu.ModifyMenu("MENU_CHAT_LOG_FRAME", addCopyMenu)
    end)
end

-- Register menu hooks on load then unregister event

local menuEventFrame = CreateFrame("Frame")
menuEventFrame:RegisterEvent("ADDON_LOADED")
menuEventFrame:SetScript("OnEvent", function(_, _, loadedAddonName)
    if loadedAddonName == "BentoPlus" then
        registerMenuHooks()
        menuEventFrame:UnregisterEvent("ADDON_LOADED")
    end
end)