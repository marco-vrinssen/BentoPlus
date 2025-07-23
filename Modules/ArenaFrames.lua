
-- Hide arena frame elements
local function hideElements(frame)
    if not frame then return end
    
    local elements = {
        frame.CastingBarFrame,
        frame.CcRemoverFrame,
        frame.name,
        frame.DebuffFrame
    }
    
    for _, element in ipairs(elements) do
        if element then
            element:SetScript("OnShow", function(self)
                self:Hide()
            end)
            element:Hide()
        end
    end
end

-- Reposition stealth icon
local function repositionStealthIcon(frame)
    if not frame or not frame.StealthIcon then return end
    
    frame.StealthIcon:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", frame, "TOPRIGHT")
    end)
end

-- Setup all arena frames
local function setupArenaFrames()
    for index = 1, 5 do
        local frame = _G["CompactArenaFrameMember"..index]
        hideElements(frame)
        repositionStealthIcon(frame)
    end
end

-- Register setup event
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", setupArenaFrames)