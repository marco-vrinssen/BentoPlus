-- AutoRecruit Addon
local AutoRecruit = CreateFrame("Frame")
local addonName = "AutoRecruit"

-- Initialize saved variables
BentoDB = BentoDB or {}
BentoDB.recruitMessage = BentoDB.recruitMessage or "Welcome to our community! Feel free to ask if you have any questions."
BentoDB.autoSendEnabled = BentoDB.autoSendEnabled ~= false -- Default to true

-- Variables for tracking invitation process
local inviteButtonClicked = false
local waitingForStaticPopup = false
local waitingForChatMessage = false
local checkStartTime = 0

-- Chat message pattern to match invitation confirmations
local INVITE_PATTERN = "You have invited (.+) to join"

-- Create the message input frame
local function CreateMessageInputFrame()
    local frame = CreateFrame("Frame", "AutoRecruitInputFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(450, 280)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    
    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFontObject("GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
    frame.title:SetText("Set Recruit Message")
    
    -- Instructions
    local instructions = frame:CreateFontString(nil, "OVERLAY")
    instructions:SetFontObject("GameFontNormal")
    instructions:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -35)
    instructions:SetText("Enter the message to whisper invited players:")
    
    -- Scrollable text input container
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", instructions, "BOTTOMLEFT", 0, -15)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -45, 60)
    
    -- Text input
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetMaxLetters(255)
    editBox:SetWidth(scrollFrame:GetWidth() - 20)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetText(BentoDB.recruitMessage)
    editBox:SetCursorPosition(0)
    
    scrollFrame:SetScrollChild(editBox)
    frame.editBox = editBox
    
    -- Create a helper FontString for text width calculations
    local textWidthHelper = frame:CreateFontString(nil, "OVERLAY")
    textWidthHelper:SetFontObject("ChatFontNormal")
    textWidthHelper:Hide()
    
    -- Auto-resize editBox height based on content
    editBox:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        local fontObject = self:GetFontObject()
        local fontHeight = 14
        if fontObject then
            local _, height = fontObject:GetFont()
            if height then
                fontHeight = height
            end
        end
        local lines = 1
        for _ in text:gmatch("\n") do
            lines = lines + 1
        end
        textWidthHelper:SetText(text)
        local textWidth = textWidthHelper:GetStringWidth()
        local editBoxWidth = self:GetWidth()
        if editBoxWidth > 0 and textWidth > editBoxWidth then
            local wrapLines = math.ceil(textWidth / editBoxWidth)
            lines = math.max(lines, wrapLines)
        end
        local newHeight = math.max(fontHeight * lines + 10, 60)
        self:SetHeight(newHeight)
    end)
    
    -- Cancel button
    local cancelBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    cancelBtn:SetSize(80, 25)
    cancelBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 20)
    cancelBtn:SetText("Cancel")
    cancelBtn:SetScript("OnClick", function()
        frame:Hide()
    end)
    
    -- Save button
    local saveBtn = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    saveBtn:SetSize(80, 25)
    saveBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 20)
    saveBtn:SetText("Save")
    saveBtn:SetScript("OnClick", function()
        BentoDB.recruitMessage = editBox:GetText()
        print("|cff00ff00AutoRecruit:|r Message saved!")
        frame:Hide()
    end)
    
    return frame
end

-- Initialize the input frame
local inputFrame = CreateMessageInputFrame()

-- Function to send whisper message
local function SendRecruitWhisper(playerName)
    if BentoDB.autoSendEnabled and playerName and BentoDB.recruitMessage and BentoDB.recruitMessage ~= "" then
        SendChatMessage(BentoDB.recruitMessage, "WHISPER", nil, playerName)
        print("|cff00ff00AutoRecruit:|r Whispered " .. playerName)
    elseif not BentoDB.autoSendEnabled then
        print("|cff00ff00AutoRecruit:|r Auto-send disabled, skipping whisper to " .. (playerName or "unknown"))
    end
end

-- Function to extract player name from chat message
local function ExtractPlayerName(message)
    local playerName = string.match(message, INVITE_PATTERN)
    return playerName
end

-- Function to add checkbox to static popup
local function AddCheckboxToStaticPopup(popup)
    if popup.autoRecruitCheckbox then
        return -- Already added
    end
    
    local checkboxFrame = CreateFrame("CheckButton", nil, popup, "UICheckButtonTemplate")
    checkboxFrame:SetPoint("TOPLEFT", popup, "TOPLEFT", 25, -120)
    checkboxFrame:SetSize(20, 20)
    checkboxFrame:SetChecked(BentoDB.autoSendEnabled)
    
    local checkboxLabel = popup:CreateFontString(nil, "OVERLAY")
    checkboxLabel:SetFontObject("GameFontNormalSmall")
    checkboxLabel:SetPoint("LEFT", checkboxFrame, "RIGHT", 5, 0)
    checkboxLabel:SetText("Send recruit message")
    
    checkboxFrame:SetScript("OnClick", function(self)
        BentoDB.autoSendEnabled = self:GetChecked()
    end)
    
    popup.autoRecruitCheckbox = checkboxFrame
    popup.autoRecruitLabel = checkboxLabel
end

-- Function to check for static popup
local function CheckForStaticPopup()
    if StaticPopup1 and StaticPopup1:IsShown() then
        -- Add checkbox to the popup
        AddCheckboxToStaticPopup(StaticPopup1)
        
        waitingForStaticPopup = false
        -- Hook the button click
        if StaticPopup1Button1 then
            StaticPopup1Button1:HookScript("OnClick", function()
                -- Update the setting from checkbox state before proceeding
                if StaticPopup1.autoRecruitCheckbox then
                    BentoDB.autoSendEnabled = StaticPopup1.autoRecruitCheckbox:GetChecked()
                end
                waitingForChatMessage = true
                checkStartTime = GetTime()
            end)
        end
    elseif GetTime() - checkStartTime > 5 then
        -- Timeout after 5 seconds
        waitingForStaticPopup = false
    end
end

-- Event handling
AutoRecruit:RegisterEvent("ADDON_LOADED")
AutoRecruit:RegisterEvent("CHAT_MSG_SYSTEM")

AutoRecruit:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AutoRecruit" then
            print("|cff00ff00AutoRecruit loaded!|r Use /recruitmessage to set your whisper message.")
        end
    elseif event == "CHAT_MSG_SYSTEM" then
        local message = ...
        if waitingForChatMessage and message then
            local playerName = ExtractPlayerName(message)
            if playerName then
                waitingForChatMessage = false
                -- Wait 1 second before sending whisper
                C_Timer.After(1, function()
                    SendRecruitWhisper(playerName)
                end)
            elseif GetTime() - checkStartTime > 10 then
                -- Timeout after 10 seconds
                waitingForChatMessage = false
            end
        end
    end
end)

-- Monitor for invite button clicks
local function MonitorInviteButton()
    if CommunitiesFrame and CommunitiesFrame:IsShown() and CommunitiesFrame.InviteButton then
        if not CommunitiesFrame.InviteButton.hookedForAutoRecruit then
            CommunitiesFrame.InviteButton:HookScript("OnClick", function()
                inviteButtonClicked = true
                waitingForStaticPopup = true
                checkStartTime = GetTime()
            end)
            CommunitiesFrame.InviteButton.hookedForAutoRecruit = true
        end
    end
end

-- OnUpdate handler for monitoring
AutoRecruit:SetScript("OnUpdate", function(self, elapsed)
    -- Monitor for Communities frame and hook invite button
    MonitorInviteButton()
    
    -- Check for static popup if waiting
    if waitingForStaticPopup then
        CheckForStaticPopup()
    end
end)

-- Slash command
SLASH_RECRUITMESSAGE1 = "/recruitmessage"
SlashCmdList["RECRUITMESSAGE"] = function(msg)
    inputFrame:Show()
    inputFrame.editBox:SetFocus()
end

-- Additional slash command for quick testing
SLASH_AUTORECRUIT1 = "/autorecruit"
SlashCmdList["AUTORECRUIT"] = function(msg)
    local args = {strsplit(" ", msg)}
    local command = args[1]
    
    if command == "test" and args[2] then
        SendRecruitWhisper(args[2])
    elseif command == "message" then
        print("|cff00ff00Current message:|r " .. (BentoDB.recruitMessage or "None set"))
    elseif command == "toggle" then
        BentoDB.autoSendEnabled = not BentoDB.autoSendEnabled
        local status = BentoDB.autoSendEnabled and "enabled" or "disabled"
        print("|cff00ff00AutoRecruit:|r Auto-send " .. status)
    else
        print("|cff00ff00AutoRecruit Commands:|r")
        print("/recruitmessage - Set whisper message")
        print("/autorecruit message - Show current message")
        print("/autorecruit toggle - Toggle auto-send on/off")
        print("/autorecruit test PlayerName-Server - Test whisper")
        local status = BentoDB.autoSendEnabled and "enabled" or "disabled"
        print("|cff00ff00Current status:|r Auto-send " .. status)
    end
end