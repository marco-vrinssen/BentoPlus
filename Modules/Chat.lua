-- Hide and reposition chat buttons

local function UpdateChatFrame()
    ChatFrameChannelButton:Hide()
    ChatFrameToggleVoiceDeafenButton:Hide()
    ChatFrameToggleVoiceMuteButton:Hide()
    ChatFrameMenuButton:Hide()
    QuickJoinToastButton:Hide()

    for i = 1, 16 do
        local chatFrameButtonFrame = _G["ChatFrame" .. i .. "ButtonFrame"]
        if chatFrameButtonFrame then
            chatFrameButtonFrame:Hide()
            chatFrameButtonFrame:SetScript("OnShow", chatFrameButtonFrame.Hide)
        end
    end
end

local ChatButtonEvents = CreateFrame("Frame")
ChatButtonEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ChatButtonEvents:RegisterEvent("CHAT_MSG_WHISPER")
ChatButtonEvents:SetScript("OnEvent", UpdateChatFrame)