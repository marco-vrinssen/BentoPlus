
-- Hide specific arena frame elements for a cleaner UI

local function hideArenaFrameElements(arenaMemberFrame)
    if not arenaMemberFrame then return end

    local arenaElementFrameList = {
        arenaMemberFrame.CastingBarFrame,
        arenaMemberFrame.CcRemoverFrame,
        arenaMemberFrame.name,
        arenaMemberFrame.DebuffFrame
    }

    for _, arenaElementFrame in ipairs(arenaElementFrameList) do
        if arenaElementFrame then
            arenaElementFrame:SetScript("OnShow", function(self)
                self:Hide()
            end)
            arenaElementFrame:Hide()
        end
    end
end


-- Move the stealth icon to a new position on the arena frame

local function repositionArenaStealthIcon(arenaMemberFrame)
    if not arenaMemberFrame or not arenaMemberFrame.StealthIcon then return end

    arenaMemberFrame.StealthIcon:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", arenaMemberFrame, "TOPRIGHT")
    end)
end


-- Set up all arena frames by hiding elements and repositioning icons

local function setupAllArenaFrames()
    for arenaMemberIndex = 1, 5 do
        local arenaMemberFrame = _G["CompactArenaFrameMember"..arenaMemberIndex]
        hideArenaFrameElements(arenaMemberFrame)
        repositionArenaStealthIcon(arenaMemberFrame)
    end
end


-- Register event to configure arena frame behavior

local arenaFrameEventFrame = CreateFrame("Frame")
arenaFrameEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaFrameEventFrame:SetScript("OnEvent", setupAllArenaFrames)