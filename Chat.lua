-- HIDE CHAT BUTTONS WHEN PLAYER ENTERS WORLD

local function HideChatButtons()
    ChatFrameChannelButton:Hide()
    ChatFrameToggleVoiceDeafenButton:Hide()
    ChatFrameToggleVoiceMuteButton:Hide()
    ChatFrameMenuButton:Hide()

    for i = 1, 16 do
        local chatFrameButtonFrame = _G["ChatFrame" .. i .. "ButtonFrame"]
        if chatFrameButtonFrame then
            chatFrameButtonFrame:Hide()
            chatFrameButtonFrame:SetScript("OnShow", chatFrameButtonFrame.Hide)
        end
    end
end

local function RepositionQuickJoinToastButton()
    QuickJoinToastButton:ClearAllPoints()
    QuickJoinToastButton:SetPoint("BOTTOMRIGHT", GeneralDockManager, "TOPLEFT", 0, -4)
end

local function OnEvent(self, event, ...)
    HideChatButtons()
    RepositionQuickJoinToastButton()
end

local ChatButtonEvents = CreateFrame("Frame")
ChatButtonEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatButtonEvents:RegisterEvent("CHAT_MSG_WHISPER")
ChatButtonEvents:SetScript("OnEvent", OnEvent)