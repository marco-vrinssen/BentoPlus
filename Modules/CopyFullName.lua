-- Define menu constants and valid context configurations

local ALLOWED_CONTEXT_MENU_TAGS = {
    MENU_LFG_FRAME_SEARCH_ENTRY = 1,
    MENU_LFG_FRAME_MEMBER_APPLY = 1
}

local ALLOWED_PLAYER_CONTEXT_TYPES = {
    PLAYER = true,
    PARTY = true,
    RAID_PLAYER = true,
    FRIEND = true,
    BN_FRIEND = true,
    SELF = true,
    OTHER_PLAYER = true
}

-- Parse player name and realm from combined string

local function parsePlayerNameAndRealm(fullPlayerName)
    if not fullPlayerName then
        return nil, nil
    end

    local playerName, realmName = string.match(fullPlayerName, "^([^-]+)-(.+)$")
    return playerName or fullPlayerName, realmName or GetRealmName()
end

-- Extract player data from group finder context

local function extractGroupFinderPlayerData(frameOwner)
    if frameOwner.resultID then
        local searchResultInfo = C_LFGList.GetSearchResultInfo(frameOwner.resultID)
        if searchResultInfo and searchResultInfo.leaderName then
            return parsePlayerNameAndRealm(searchResultInfo.leaderName)
        end
    end

    if frameOwner.memberIdx then
        local parentFrame = frameOwner:GetParent()
        if parentFrame and parentFrame.applicantID then
            local applicantFullName = C_LFGList.GetApplicantMemberInfo(parentFrame.applicantID, frameOwner.memberIdx)
            if applicantFullName then
                return parsePlayerNameAndRealm(applicantFullName)
            end
        end
    end

    return nil, nil
end

-- Extract player data from battlenet account

local function extractBattlenetPlayerData(battlenetAccountInfo)
    if battlenetAccountInfo and battlenetAccountInfo.gameAccountInfo then
        local gameAccountInfo = battlenetAccountInfo.gameAccountInfo
        return gameAccountInfo.characterName, gameAccountInfo.realmName
    end
    return nil, nil
end

-- Resolve player data from menu context

local function resolvePlayerFromMenuContext(frameOwner, menuRootDescription, menuContextData)
    if not menuContextData then
        if ALLOWED_CONTEXT_MENU_TAGS[menuRootDescription.tag] == 1 then
            return extractGroupFinderPlayerData(frameOwner)
        end
        return nil, nil
    end

    if menuContextData.name and menuContextData.server then
        return menuContextData.name, menuContextData.server
    end

    if menuContextData.unit and UnitExists(menuContextData.unit) then
        local playerName, realmName = parsePlayerNameAndRealm(UnitName(menuContextData.unit))
        return playerName, menuContextData.server or realmName
    end

    if menuContextData.accountInfo then
        local playerName, realmName = extractBattlenetPlayerData(menuContextData.accountInfo)
        if playerName and realmName then
            return playerName, realmName
        end
    end

    if menuContextData.name then
        return parsePlayerNameAndRealm(menuContextData.name)
    end

    if menuContextData.friendsList then
        local friendInfo = C_FriendList.GetFriendInfoByIndex(menuContextData.friendsList)
        if friendInfo and friendInfo.name then
            return parsePlayerNameAndRealm(friendInfo.name)
        end
    end

    return nil, nil
end

-- Validate menu context for addon usage

local function validatePlayerMenuContext(menuRootDescription, menuContextData)
    if not menuContextData then
        return ALLOWED_CONTEXT_MENU_TAGS[menuRootDescription.tag] ~= nil
    end
    
    if menuContextData.which and ALLOWED_PLAYER_CONTEXT_TYPES[menuContextData.which] then
        return true
    end
    
    return false
end

-- Create modal dialog for text copying

local function createPlayerNameCopyDialog(playerNameText)
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

    local copyInstruction = dialogFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    copyInstruction:SetPoint("BOTTOM", dialogFrame, "BOTTOM", 0, 20)
    copyInstruction:SetText("Press Ctrl+C (Cmd+C on macOS) to copy the name.")

    dialogFrame:Show()
end

-- Add copy name option to context menu

local function addPlayerNameCopyOption(frameOwner, menuRootDescription, menuContextData)
    if InCombatLockdown() then
        return
    end

    if not validatePlayerMenuContext(menuRootDescription, menuContextData) then
        return
    end

    local playerName, realmName = resolvePlayerFromMenuContext(frameOwner, menuRootDescription, menuContextData)
    if playerName and realmName then
        local success = pcall(function()
            menuRootDescription:CreateDivider()
            menuRootDescription:CreateButton("Copy Full Name", function()
                if not InCombatLockdown() then
                    createPlayerNameCopyDialog(string.format("%s-%s", playerName, realmName))
                end
            end)
        end)
        
        if not success then
            return
        end
    end
end

-- Register context menu hooks for all player types

local function registerPlayerMenuHooks()
    if not (Menu and Menu.ModifyMenu) then
        return
    end

    pcall(function()
        Menu.ModifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_PLAYER", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_PARTY", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_FRIEND", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_BN_FRIEND", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_SELF", addPlayerNameCopyOption)
        Menu.ModifyMenu("MENU_UNIT_OTHER_PLAYER", addPlayerNameCopyOption)
    end)
end

-- Handle addon loading events

local socialShortcutEventFrame = CreateFrame("Frame")
socialShortcutEventFrame:RegisterEvent("ADDON_LOADED")
socialShortcutEventFrame:SetScript("OnEvent", function(_, _, loadedAddonName)
    if loadedAddonName == "BentoPlus" then
        registerPlayerMenuHooks()
        socialShortcutEventFrame:UnregisterEvent("ADDON_LOADED")
    end
end)