-- Update community invite message so that we auto whisper invited players

local ClubInvMessage = CreateFrame("Frame")
local addonName = "BentoPlus"

-- Initialize saved variables for invitation message and auto send state
BentoDB = BentoDB or {}
BentoDB.clubInvitationMessage = BentoDB.clubInvitationMessage or BentoDB.recruitMessage or "Welcome to our community! Feel free to ask if you have any questions."
BentoDB.autoSendEnabled = BentoDB.autoSendEnabled ~= false

-- Track invitation state through popup and chat confirmation flow
local inviteClick = false
local staticPopupWait = false
local chatMessageWait = false
local checkStartTime = 0

-- Pattern to match system chat invitation confirmation messages
local INVITE_PATTERN = "You have invited (.+) to join"

local function sendInviteWhisper(playerName)
    if BentoDB.autoSendEnabled and playerName and BentoDB.clubInvitationMessage and BentoDB.clubInvitationMessage ~= "" then
        SendChatMessage(BentoDB.clubInvitationMessage, "WHISPER", nil, playerName)
        print("|cff00ff00ClubInvMessage:|r Whispered " .. playerName)
    elseif not BentoDB.autoSendEnabled then
        print("|cff00ff00ClubInvMessage:|r Auto-send disabled, skipping whisper to " .. (playerName or "unknown"))
    end
end

-- Parse player name from system message using pattern
local function parsePlayerName(message)
    local playerName = string.match(message, INVITE_PATTERN)
    return playerName
end

-- Create child popup for invite message configuration
local function createInvitePopup()
    local childFrame = CreateFrame("Frame", "ClubInvMessageChildPopup", UIParent, "BasicFrameTemplateWithInset")
    childFrame:SetSize(480, 240)
    childFrame:SetFrameStrata("DIALOG")
    childFrame:SetFrameLevel(1000)
    childFrame:Hide()
    
    -- Focus the text input when popup is clicked
    childFrame:SetScript("OnMouseDown", function(self)
        if self.messageEditBox then
            self.messageEditBox:SetFocus()
        end
    end)
    
    -- Title for child popup
    childFrame.title = childFrame:CreateFontString(nil, "OVERLAY")
    childFrame.title:SetFontObject("GameFontHighlight")
    childFrame.title:SetPoint("CENTER", childFrame.TitleBg, "CENTER", 0, 0)
    childFrame.title:SetText("Club Invite Message Settings")
    
    -- Input text field label for recruitment message at top
    local messageLabel = childFrame:CreateFontString(nil, "OVERLAY")
    messageLabel:SetFontObject("GameFontNormal")
    messageLabel:SetPoint("TOPLEFT", childFrame, "TOPLEFT", 20, -35)
    messageLabel:SetText("Club invitation message:")
    
    -- Create multi-line text input (no scroll, fixed size for 3 lines)
    local messageInput = CreateFrame("EditBox", nil, childFrame)
    messageInput:SetPoint("TOPLEFT", messageLabel, "BOTTOMLEFT", 0, -8)
    messageInput:SetSize(432, 160)
    messageInput:SetMultiLine(true)
    messageInput:SetMaxLetters(260)
    messageInput:SetAutoFocus(false)
    messageInput:SetFontObject("ChatFontNormal")
    
    -- Limit input to prevent scrolling beyond visible area
    messageInput:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        local lines = 1
        for _ in text:gmatch("\n") do
            lines = lines + 1
        end
        -- Prevent more than 3 lines of text
        if lines > 3 then
            -- Remove the last character that caused overflow
            local newText = text:sub(1, -2)
            self:SetText(newText)
            self:SetCursorPosition(#newText)
        end
    end)
    
    -- Cancel button at bottom-left
    local cancelButton = CreateFrame("Button", nil, childFrame, "GameMenuButtonTemplate")
    cancelButton:SetSize(80, 25)
    cancelButton:SetPoint("BOTTOMLEFT", childFrame, "BOTTOMLEFT", 20, 20)
    cancelButton:SetText("Cancel")
    
    -- Save button at bottom-right
    local saveButton = CreateFrame("Button", nil, childFrame, "GameMenuButtonTemplate")
    saveButton:SetSize(80, 25)
    saveButton:SetPoint("BOTTOMRIGHT", childFrame, "BOTTOMRIGHT", -20, 20)
    saveButton:SetText("Save")
    
    -- Checkbox to toggle message sending left aligned with 8px margin above buttons
    local enableCheckbox = CreateFrame("CheckButton", nil, childFrame, "UICheckButtonTemplate")
    enableCheckbox:SetSize(20, 20)
    enableCheckbox:SetPoint("BOTTOMLEFT", childFrame, "BOTTOMLEFT", 20, 64)
    
    local enableLabel = childFrame:CreateFontString(nil, "OVERLAY")
    enableLabel:SetFontObject("GameFontNormal")
    enableLabel:SetPoint("LEFT", enableCheckbox, "RIGHT", 4, 0)
    enableLabel:SetText("Send message to player after sending out the invite.")
    
    -- Store original values for cancel functionality
    local originalMessage = ""
    local originalEnabled = true
    
    -- Initialize controls with current values
    local function InitializeControls()
        originalMessage = BentoDB.clubInvitationMessage or ""
        originalEnabled = BentoDB.autoSendEnabled
        messageInput:SetText(originalMessage)
        enableCheckbox:SetChecked(originalEnabled)
    end
    
    -- Cancel button behavior - restore original values and close
    cancelButton:SetScript("OnClick", function()
        messageInput:SetText(originalMessage)
        enableCheckbox:SetChecked(originalEnabled)
        childFrame:Hide()
    end)
    
    -- Save button behavior - persist values and close
    saveButton:SetScript("OnClick", function()
        BentoDB.clubInvitationMessage = messageInput:GetText()
        BentoDB.autoSendEnabled = enableCheckbox:GetChecked()
        -- Update original values to match saved values
        originalMessage = BentoDB.clubInvitationMessage
        originalEnabled = BentoDB.autoSendEnabled
        print("|cff00ff00ClubInvMessage:|r Settings saved successfully!")
        childFrame:Hide()
    end)
    
    -- Store references for external access
    childFrame.messageInput = messageInput
    childFrame.enableCheckbox = enableCheckbox
    childFrame.InitializeControls = InitializeControls
    
    return childFrame
end

-- Instantiate settings popup singleton
local clubInvitationChildPopup = createInvitePopup()

-- Show settings popup anchored to Communities frame
local function showInvitePopup()
    if not CommunitiesFrame or not CommunitiesFrame:IsShown() then
        return
    end
    
    -- Initialize controls with current values
    clubInvitationChildPopup.InitializeControls()
    
    -- Anchor settings panel bottom-left to community frame bottom-right
    clubInvitationChildPopup:ClearAllPoints()
    clubInvitationChildPopup:SetPoint("BOTTOMLEFT", CommunitiesFrame, "BOTTOMRIGHT", 10, 0)
    clubInvitationChildPopup:Show()
end

-- Create button to open invitation settings
local function createInviteButton()
    if not CommunitiesFrame or not CommunitiesFrame.CommunitiesControlFrame then
        return
    end
    
    -- Check if button already exists
    if CommunitiesFrame.InviteSettingsButton then
        return
    end
    
    -- Create invite settings button
    local inviteButton = CreateFrame("Button", nil, CommunitiesFrame.CommunitiesControlFrame, "GameMenuButtonTemplate")
    inviteButton:SetSize(100, 20)
    inviteButton:SetText("Invite Settings")
    
    -- Set default WoW button yellow text color for consistency
    inviteButton:GetFontString():SetTextColor(1, 0.82, 0)
    
    -- Position button in bottom-left of communities frame with 8px left margin
    inviteButton:SetPoint("BOTTOMLEFT", CommunitiesFrame, "BOTTOMLEFT", 8, 4)
    
    -- Toggle popup when button clicked
    inviteButton:SetScript("OnClick", function()
        if clubInvitationChildPopup:IsShown() then
            clubInvitationChildPopup:Hide()
        else
            showInvitePopup()
        end
    end)
    
    -- Store reference
    CommunitiesFrame.InviteSettingsButton = inviteButton
end

-- Monitor CommunitiesFrame visibility to show/hide settings
local function watchCommunityFrame()
    if CommunitiesFrame then
        if CommunitiesFrame:IsShown() then
            -- Create invite settings button when CommunitiesFrame is visible
            createInviteButton()
        else
            -- Hide settings panel when CommunitiesFrame is hidden
            clubInvitationChildPopup:Hide()
        end
    end
end

-- Poll for static popup presence to hook accept button
local function checkStaticPopup()
    if StaticPopup1 and StaticPopup1:IsShown() then
    staticPopupWait = false
        -- Hook the button click
        if StaticPopup1Button1 then
            StaticPopup1Button1:HookScript("OnClick", function()
                chatMessageWait = true
                checkStartTime = GetTime()
            end)
        end
    elseif GetTime() - checkStartTime > 5 then
        -- Timeout after 5 seconds
    staticPopupWait = false
    end
end

-- Register events for addon load and system chat
ClubInvMessage:RegisterEvent("ADDON_LOADED")
ClubInvMessage:RegisterEvent("CHAT_MSG_SYSTEM")

ClubInvMessage:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "ClubInvMessage" then
            print("|cff00ff00ClubInvMessage loaded!|r Club invitation message settings available in guild invitation popups.")
        end
    elseif event == "CHAT_MSG_SYSTEM" then
        local message = ...
        if chatMessageWait and message then
            local playerName = parsePlayerName(message)
            if playerName then
                chatMessageWait = false
                -- Wait 1 second before sending whisper
                C_Timer.After(1, function()
                    sendInviteWhisper(playerName)
                end)
            elseif GetTime() - checkStartTime > 10 then
                -- Timeout after 10 seconds
                chatMessageWait = false
            end
        end
    end
end)

-- Hook invite button to start tracking flow
local function watchInviteButton()
    if CommunitiesFrame and CommunitiesFrame:IsShown() and CommunitiesFrame.InviteButton then
        if not CommunitiesFrame.InviteButton.hookedForClubInvMessage then
            CommunitiesFrame.InviteButton:HookScript("OnClick", function()
                inviteClick = true
                staticPopupWait = true
                checkStartTime = GetTime()
            end)
            CommunitiesFrame.InviteButton.hookedForClubInvMessage = true
        end
    end
end

-- Per-frame update handler to poll invite flow state
ClubInvMessage:SetScript("OnUpdate", function()
    -- Monitor for Communities frame and hook invite button
    watchInviteButton()
    
    -- Monitor CommunitiesFrame visibility to show/hide settings panel
    watchCommunityFrame()
    
    -- Check for static popup if waiting
    if staticPopupWait then
        checkStaticPopup()
    end
end)