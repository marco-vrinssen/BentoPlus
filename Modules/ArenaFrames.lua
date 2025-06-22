local function hideArenaElements(arenaFrame)
    if not arenaFrame then return end

    local unwantedElements = {
        arenaFrame.CastingBarFrame,
        arenaFrame.CcRemoverFrame,
        arenaFrame.name,
        arenaFrame.DebuffFrame
    }
    
    for _, frameElement in ipairs(unwantedElements) do
        if frameElement then
            frameElement:SetScript("OnShow", function(self)
                self:Hide()
            end)
            frameElement:Hide()
        end
    end
end

local function repositionStealthIcon(arenaFrame)
    if not arenaFrame or not arenaFrame.StealthIcon then return end

    arenaFrame.StealthIcon:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", arenaFrame, "TOPRIGHT")
    end)
end

local function configureArenaFrames()
    for i = 1, 5 do
        local memberFrame = _G["CompactArenaFrameMember"..i]
        hideArenaElements(memberFrame)
        repositionStealthIcon(memberFrame)
    end
end

-- Initialize arena frame modifications

local arenaEventHandler = CreateFrame("Frame")
arenaEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaEventHandler:SetScript("OnEvent", configureArenaFrames)