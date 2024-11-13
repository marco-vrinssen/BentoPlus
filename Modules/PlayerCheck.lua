local function GenerateCheckPvPLink(name, realm, baseUrl)
    if name then
        if not realm or realm == "" then
            realm = GetRealmName()
        end

        realm = realm:gsub("(%l)(%u)", "%1 %2")

        local region = GetCVar("portal"):lower()
        if region == "public-test" then
            region = "eu"
        end

        local link = string.format("%s/%s/%s/%s", baseUrl, region, realm, name)
        return link
    else
        print("Information currently not available for this target.")
        return nil
    end
end

local function ShowCopyDialog(link)
    if not link then
        return
    end

    if not CopyDialog then
        CopyDialog = CreateFrame("Frame", "CopyDialog", UIParent, "BasicFrameTemplateWithInset")
        CopyDialog:SetSize(320, 80)
        CopyDialog:SetPoint("CENTER")
        CopyDialog:SetFrameStrata("TOOLTIP")
        CopyDialog:EnableKeyboard(true)

        CopyDialog.title = CopyDialog:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        CopyDialog.title:SetPoint("CENTER", CopyDialog.TitleBg, "CENTER", 0, 0)
        CopyDialog.title:SetText("CheckPvP Link")

        CopyDialog.EditBox = CreateFrame("EditBox", nil, CopyDialog, "InputBoxTemplate")
        CopyDialog.EditBox:SetSize(280, 40)
        CopyDialog.EditBox:SetPoint("CENTER")
        CopyDialog.EditBox:SetAutoFocus(true)
        CopyDialog.EditBox:SetScript("OnEscapePressed", function(self)
            CopyDialog:Hide()
        end)
        CopyDialog.EditBox:SetScript("OnKeyDown", function(self, key)
            local isMac = IsMacClient()
            if key == "ESCAPE" then
                CopyDialog:Hide()
            elseif (isMac and IsMetaKeyDown() or IsControlKeyDown()) and key == "C" then
                C_Timer.After(0, function() CopyDialog:Hide() end)
            end
        end)
    end

    CopyDialog:SetFrameStrata("TOOLTIP")
    CopyDialog.EditBox:SetText(link)
    CopyDialog.EditBox:HighlightText() -- Highlight the text for easy copying
    CopyDialog.EditBox:SetFocus() -- Ensure the EditBox is focused
    CopyDialog:Show()
end

local function AddPvPCheckMenu(name, realm, infotext, checkPvPLink)
    local info = UIDropDownMenu_CreateInfo()
    info.text = infotext
    info.notCheckable = true
    info.func = function()
        local link = GenerateCheckPvPLink(name, realm, checkPvPLink)
        ShowCopyDialog(link)
    end
    if UIDROPDOWNMENU_MENU_LEVEL == 1 then
        UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL)
    end
end

local function AddTitle(pvpCheckText)
    if UIDROPDOWNMENU_MENU_LEVEL == 1 then
        local separator = UIDropDownMenu_CreateInfo()
        separator.text = ""
        separator.notCheckable = true
        separator.isTitle = true
        UIDropDownMenu_AddButton(separator, UIDROPDOWNMENU_MENU_LEVEL)

        local title = UIDropDownMenu_CreateInfo()
        local titleText = "|cffffd100" .. pvpCheckText .. "|r"
        title.text = titleText
        title.notCheckable = true
        title.isTitle = true
        UIDropDownMenu_AddButton(title, UIDROPDOWNMENU_MENU_LEVEL)
    end
end

Menu.ModifyMenu("MENU_UNIT_SELF", function(ownerRegion, rootDescription, contextData)
    local characterName = contextData.accountInfo.gameAccountInfo.characterName
    local realmName = contextData.accountInfo.gameAccountInfo.realmName

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("CheckPvP Link")
    rootDescription:CreateButton("Check PvP", function()
        ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
    end)
end)

Menu.ModifyMenu("MENU_UNIT_PLAYER", function(ownerRegion, rootDescription, contextData)
    local characterName = contextData.name
    local realmName = contextData.server

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("CheckPvP Link")
    rootDescription:CreateButton("Check PvP", function()
        ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
    end)
end)

Menu.ModifyMenu("MENU_UNIT_PARTY", function(ownerRegion, rootDescription, contextData)
    local characterName = contextData.name
    local realmName = contextData.server

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("CheckPvP Link")
    rootDescription:CreateButton("Check PvP", function()
        ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
    end)
end)

Menu.ModifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", function(contextData, rootDescription)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(contextData.resultID)

    local characterName, realmName = strsplit("-", searchResultInfo.leaderName)

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("CheckPvP Link")
    rootDescription:CreateButton("Check PvP", function()
        ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
    end)
end)

Menu.ModifyMenu("MENU_UNIT_BN_FRIEND", function(ownerRegion, rootDescription, contextData)
    local characterName = contextData.accountInfo.gameAccountInfo.characterName
    local realmName = contextData.accountInfo.gameAccountInfo.realmName

    if not characterName and not realmName then
        return
    end

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("CheckPvP Link")
    rootDescription:CreateButton("Check PvP", function()
        ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
    end)
end)

Menu.ModifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", function(contextData, rootDescription)
    local applicants = C_LFGList.GetApplicants()

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("Check PvP Links")

    for i = 1, #applicants do
        local applicantData = C_LFGList.GetApplicantMemberInfo(applicants[i], 1)
        if applicantData then
            local characterName, realmName = strsplit("-", applicantData)
            if not realmName or realmName == "" then
                realmName = GetRealmName()
            end

            rootDescription:CreateButton(characterName .. "-" .. realmName, function()
                ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
            end)
        end
    end
end)

Menu.ModifyMenu("MENU_UNIT_ENEMY_PLAYER", function(ownerRegion, rootDescription, contextData)
    local characterName = contextData.name
    local realmName = contextData.server

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("CheckPvP Link")
    rootDescription:CreateButton("Check PvP", function()
        ShowCopyDialog(GenerateCheckPvPLink(characterName, realmName, "https://check-pvp.fr"))
    end)
end)
