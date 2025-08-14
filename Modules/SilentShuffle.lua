-- Minimalist style, no third-party libs, persists via BentoDB

-- SavedVariables key
local shuffleChatPrefKey = "hideSoloShuffleChat"

-- Ensure DB key exists
if not BentoDB then BentoDB = {} end
if BentoDB[shuffleChatPrefKey] == nil then
    BentoDB[shuffleChatPrefKey] = false
end

-- Cache Blizzard API references
local isChatDisabled         = C_SocialRestrictions and C_SocialRestrictions.IsChatDisabled
local setChatDisabled        = C_SocialRestrictions and C_SocialRestrictions.SetChatDisabled
local isRatedSoloShuffle     = C_PvP and C_PvP.IsRatedSoloShuffle
local inInstance             = IsInInstance

local function inShuffle()
    if not isRatedSoloShuffle or not inInstance then return false end
    local _, instanceType = inInstance()
    if instanceType ~= "arena" then return false end
    return isRatedSoloShuffle() == true
end

-- Pure toggle decision: only returns a boolean, no side effects
local function shouldHideChat()
    return BentoDB[shuffleChatPrefKey] and inShuffle()
end

-- Hide/restore chat according to state and context
local chatHideState -- { forced:boolean, original:boolean }
local function applyChatHide()
    if not setChatDisabled or not isChatDisabled then return end
    -- remember/restore user preference around Solo Shuffle
    if not chatHideState then
        chatHideState = { forced = false, original = isChatDisabled() }
    end
    local st = chatHideState

    if shouldHideChat() then
        if not st.forced then
            st.original = isChatDisabled()
            if not st.original then
                setChatDisabled(true)
                print("BentoPlus: Solo Shuffle Chat: Hidden")
            end
            st.forced = true
        end
    else
        if st.forced then
            if isChatDisabled() ~= st.original then
                setChatDisabled(st.original)
                local label = st.original and "Hidden" or "Visible"
                print("BentoPlus: Solo Shuffle Chat: " .. label)
            end
            st.forced = false
        end
    end
end

-- Slash command: /bentoshuffle
SLASH_BENTOPLUS_SHUFFLE1 = "/bentoshuffle"
SlashCmdList["BENTOPLUS_SHUFFLE"] = function()
    BentoDB[shuffleChatPrefKey] = not BentoDB[shuffleChatPrefKey]
    local label = BentoDB[shuffleChatPrefKey] and "Enabled" or "Disabled"
    print("BentoPlus: Solo Shuffle Chat Auto-hide: " .. label)
    applyChatHide()
end

-- Event driver
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
eventFrame:SetScript("OnEvent", function()
    -- Short delay helps after loading screens before C_PvP answers reliably
    C_Timer.After(0.5, applyChatHide)
end)

-- Immediate application on load
C_Timer.After(1, applyChatHide)
