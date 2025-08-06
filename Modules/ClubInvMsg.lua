-- ClubInvMessage Addon
local ClubInvMessage = CreateFrame("Frame")
local addonName = "ClubInvMessage"

-- Initialize saved variables
BentoDB = BentoDB or {}
BentoDB.clubInvitationMessage = BentoDB.clubInvitationMessage or BentoDB.recruitMessage or "Welcome to our community! Feel free to ask if you have any questions."
BentoDB.autoSendEnabled = BentoDB.autoSendEnabled ~= false

-- Variables for tracking invitation process
local inviteButtonClicked = false
local waitingForStaticPopup = false
local waitingForChatMessage = false
local checkStartTime = 0

-- Chat message pattern to match invitation confirmations
local INVITE_PATTERN = "You have invited (.+) to join"

-- Function to send whisper message
local function SendClubInvitationWhisper(playerName)
    if BentoDB.autoSendEnabled and playerName and BentoDB.clubInvitationMessage and BentoDB.clubInvitationMessage ~= "" then
        SendChatMessage(BentoDB.clubInvitationMessage, "WHISPER", nil, playerName)
        print("|cff00ff00ClubInvMessage:|r Whispered " .. playerName)
    elseif not BentoDB.autoSendEnabled then
        print("|cff00ff00ClubInvMessage:|r Auto-send disabled, skipping whisper to " .. (playerName or "unknown"))
    end
end

-- Function to extract player name from chat message
local function ExtractPlayerName(message)
    local playerName = string.match(message, INVITE_PATTERN)
    return playerName
end

-- Create child recruitment popup frame
local function CreateClubInvitationChildPopup()
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
    childFrame.title:SetText("Club Invitation Message Settings")
    
    -- Input text field label for recruitment message at top
    local messageLabel = childFrame:CreateFontString(nil, "OVERLAY")
    messageLabel:SetFontObject("GameFontNormal")
    messageLabel:SetPoint("TOPLEFT", childFrame, "TOPLEFT", 20, -35)
    messageLabel:SetText("Club invitation message:")
    
    -- Create multi-line text input (no scroll, fixed size for 3 lines)
    local messageEditBox = CreateFrame("EditBox", nil, childFrame)
    messageEditBox:SetPoint("TOPLEFT", messageLabel, "BOTTOMLEFT", 0, -8)
    messageEditBox:SetSize(432, 160)
    messageEditBox:SetMultiLine(true)
    messageEditBox:SetMaxLetters(260)
    messageEditBox:SetAutoFocus(false)
    messageEditBox:SetFontObject("ChatFontNormal")
    
    -- Limit input to prevent scrolling beyond visible area
    messageEditBox:SetScript("OnTextChanged", function(self)
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
        messageEditBox:SetText(originalMessage)
        enableCheckbox:SetChecked(originalEnabled)
    end
    
    -- Cancel button behavior - restore original values and close
    cancelButton:SetScript("OnClick", function()
        messageEditBox:SetText(originalMessage)
        enableCheckbox:SetChecked(originalEnabled)
        childFrame:Hide()
    end)
    
    -- Save button behavior - persist values and close
    saveButton:SetScript("OnClick", function()
        BentoDB.clubInvitationMessage = messageEditBox:GetText()
        BentoDB.autoSendEnabled = enableCheckbox:GetChecked()
        childFrame:Hide()
    end)
    
    -- Store references for external access
    childFrame.messageEditBox = messageEditBox
    childFrame.enableCheckbox = enableCheckbox
    childFrame.InitializeControls = InitializeControls
    
    return childFrame
end

-- Initialize the club invitation child popup
local clubInvitationChildPopup = CreateClubInvitationChildPopup()

-- Function to show popup anchored to static popup
local function ShowClubInvitationPopup(parentPopup)
    if not parentPopup then return end
    
    -- Initialize controls with current values
    clubInvitationChildPopup.InitializeControls()
    
    -- Anchor child popup top-left to parent popup top-right
    clubInvitationChildPopup:ClearAllPoints()
    clubInvitationChildPopup:SetPoint("TOPLEFT", parentPopup, "TOPRIGHT", 10, 0)
    clubInvitationChildPopup:Show()
    
    -- Auto-focus the text input when popup opens
    if clubInvitationChildPopup.messageEditBox then
        clubInvitationChildPopup.messageEditBox:SetFocus()
    end
end

-- Function to add settings button to static popup
local function AddClubInvitationButtonToStaticPopup(popup)
    if popup.clubInvitationButtonAdded then
        return
    end
    
    -- Only add button if CommunitiesFrame is shown
    if not (CommunitiesFrame and CommunitiesFrame:IsShown()) then
        return
    end
    
    -- Hide the separator element for this popup
    if popup.Separator then
        popup.Separator:Hide()
    end
    
    -- Create settings button for popup
    local settingsButton = CreateFrame("Button", nil, popup, "GameMenuButtonTemplate")
    
    -- Set text first to calculate proper width
    settingsButton:SetText("Settings")
    
    -- Set default WoW popup button yellow text color
    settingsButton:GetFontString():SetTextColor(1, 0.82, 0)
    
    -- Calculate proper button width to fit text
    local fontString = settingsButton:GetFontString()
    if fontString then
        local textWidth = fontString:GetStringWidth()
        local buttonWidth = math.max(textWidth + 50, 120)
        settingsButton:SetSize(buttonWidth, 20)
    else
        settingsButton:SetSize(120, 20)
    end
    
    -- Position button above the extra button with proper margin
    if popup.extraButton then
        settingsButton:SetPoint("BOTTOM", popup.extraButton, "TOP", 0, 4)
    else
        settingsButton:SetPoint("BOTTOM", popup, "BOTTOM", 0, 45)
    end
    
    -- Show popup when button clicked
    settingsButton:SetScript("OnClick", function()
        ShowClubInvitationPopup(popup)
    end)
    
    popup.clubInvitationButton = settingsButton
    popup.clubInvitationButtonAdded = true
end

-- Function to check for static popup
local function CheckForStaticPopup()
    if StaticPopup1 and StaticPopup1:IsShown() then
        -- Add settings button to the popup
        AddClubInvitationButtonToStaticPopup(StaticPopup1)
        
        waitingForStaticPopup = false
        -- Hook the button click
        if StaticPopup1Button1 then
            StaticPopup1Button1:HookScript("OnClick", function()
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
        if waitingForChatMessage and message then
            local playerName = ExtractPlayerName(message)
            if playerName then
                waitingForChatMessage = false
                -- Wait 1 second before sending whisper
                C_Timer.After(1, function()
                    SendClubInvitationWhisper(playerName)
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
        if not CommunitiesFrame.InviteButton.hookedForClubInvMessage then
            CommunitiesFrame.InviteButton:HookScript("OnClick", function()
                inviteButtonClicked = true
                waitingForStaticPopup = true
                checkStartTime = GetTime()
            end)
            CommunitiesFrame.InviteButton.hookedForClubInvMessage = true
        end
    end
end

-- OnUpdate handler for monitoring
ClubInvMessage:SetScript("OnUpdate", function(self, elapsed)
    -- Monitor for Communities frame and hook invite button
    MonitorInviteButton()
    
    -- Check for static popup if waiting
    if waitingForStaticPopup then
        CheckForStaticPopup()
    end
end)