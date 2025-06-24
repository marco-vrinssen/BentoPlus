local function hideFrameElements(targetFrame)
    if not targetFrame then return end

    local elementList = {
        targetFrame.CastingBarFrame,
        targetFrame.CcRemoverFrame,
        targetFrame.name,
        targetFrame.DebuffFrame
    }
    
    for _, element in ipairs(elementList) do
        if element then
            element:SetScript("OnShow", function(self)
                self:Hide()
            end)
            element:Hide()
        end
    end
end

local function moveStealthIcon(targetFrame)
    if not targetFrame or not targetFrame.StealthIcon then return end

    targetFrame.StealthIcon:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", targetFrame, "TOPRIGHT")
    end)
end

local function setupArenaFrames()
    for i = 1, 5 do
        local memberFrame = _G["CompactArenaFrameMember"..i]
        hideFrameElements(memberFrame)
        moveStealthIcon(memberFrame)
    end
end

-- Configure arena frame behavior

local frameHandler = CreateFrame("Frame")
frameHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
frameHandler:SetScript("OnEvent", setupArenaFrames)