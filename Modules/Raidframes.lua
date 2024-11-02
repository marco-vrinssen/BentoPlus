-- Hide raid frame auras

local function HideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", HideAllAuras)




-- Update size and columns of raid frames based on group size

local function UpdateRaidFrameSize()
    local numGroupMembers = GetNumGroupMembers()
    local width, height, columns

    if numGroupMembers >= 6 and numGroupMembers <= 10 then
        width = 80
        height = 40
        columns = (numGroupMembers == 8) and 4 or 5
    elseif numGroupMembers >= 11 and numGroupMembers <= 40 then
        width = 40
        height = 20
        columns = 10
    else
        return
    end

    for i = 1, numGroupMembers do
        local RaidFrame = _G["CompactRaidFrame"..i]
        if RaidFrame then
            RaidFrame:SetSize(width, height)
            RaidFrame:SetAttribute("columnAnchorPoint", "LEFT")
            RaidFrame:SetAttribute("unitsPerColumn", columns)
        end
    end
end

local RaidFrameEvents = CreateFrame("Frame")
RaidFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
RaidFrameEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
RaidFrameEvents:SetScript("OnEvent", UpdateRaidFrameSize)