local function HideArenaFrameElements(arenaFrame)
    if not arenaFrame then return end

    local elementsToHide = {
        arenaFrame.CastingBarFrame,
        arenaFrame.CcRemoverFrame,
        arenaFrame.name,
        arenaFrame.DebuffFrame
    }
    for _, arenaFrameElement in ipairs(elementsToHide) do
        if arenaFrameElement then
            arenaFrameElement:SetScript("OnShow", function(self)
                self:Hide()
            end)
            arenaFrameElement:Hide()
        end
    end
end

local function MoveStealthIconOnShow(arenaFrame)
    if not arenaFrame or not arenaFrame.StealthIcon then return end

    arenaFrame.StealthIcon:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", arenaFrame, "TOPRIGHT")
    end)
end

local function InitializeArenaFrames()
    for i = 1, 3 do
        local arenaFrame = _G["CompactArenaFrameMember"..i]
        HideArenaFrameElements(arenaFrame)
        MoveStealthIconOnShow(arenaFrame)
    end
end

local arenaFrameEvents = CreateFrame("Frame")
arenaFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaFrameEvents:SetScript("OnEvent", InitializeArenaFrames)