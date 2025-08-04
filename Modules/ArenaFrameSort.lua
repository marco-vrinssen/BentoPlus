-- Sort enemy arena frames with healer first followed by dps players
local ArenaFrameSort = {}

-- Healer specialization detection mapping
local healerSpecializations = {
    [65] = true,    -- Holy Paladin
    [256] = true,   -- Discipline Priest
    [257] = true,   -- Holy Priest
    [264] = true,   -- Restoration Shaman
    [270] = true,   -- Mistweaver Monk
    [102] = true,   -- Balance Druid (can heal)
    [105] = true,   -- Restoration Druid
    [1468] = true,  -- Preservation Evoker
}

-- Check if unit is healer based on specialization
local function isUnitHealer(unit)
    if not unit or not UnitExists(unit) then
        return false
    end
    
    local specIndex = GetInspectSpecialization(unit)
    return healerSpecializations[specIndex] or false
end

-- Get arena enemy unit role priority for sorting
local function getUnitSortPriority(unit)
    if not unit or not UnitExists(unit) then
        return 999
    end
    
    if isUnitHealer(unit) then
        return 1
    else
        return 2
    end
end

-- Sort arena enemy frames based on role priority
local function sortArenaEnemyFrames()
    if not IsActiveBattlefieldArena() then
        return
    end
    
    local frameData = {}
    local validFrameCount = 0
    
    -- Collect arena enemy frame information
    for frameIndex = 1, 3 do
        local arenaFrame = _G["ArenaEnemyMatchFrame" .. frameIndex]
        local unit = "arena" .. frameIndex
        
        if arenaFrame and UnitExists(unit) then
            validFrameCount = validFrameCount + 1
            frameData[validFrameCount] = {
                frame = arenaFrame,
                unit = unit,
                priority = getUnitSortPriority(unit),
                originalPosition = frameIndex
            }
        end
    end
    
    -- Sort frames by priority healer first then dps
    table.sort(frameData, function(frameA, frameB)
        if frameA.priority == frameB.priority then
            return frameA.originalPosition < frameB.originalPosition
        end
        return frameA.priority < frameB.priority
    end)
    
    -- Reposition sorted frames maintaining visual spacing
    for sortedIndex, frameInfo in ipairs(frameData) do
        local targetFrame = _G["ArenaEnemyMatchFrame" .. sortedIndex]
        local sourceFrame = frameInfo.frame
        
        if targetFrame and sourceFrame and targetFrame ~= sourceFrame then
            local targetX, targetY = targetFrame:GetPoint()
            sourceFrame:ClearAllPoints()
            sourceFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", targetX, targetY)
        end
    end
end

-- Handle arena enemy frame sorting on events
local function handleArenaFrameEvents(self, event, ...)
    if event == "ARENA_OPPONENT_UPDATE" or 
       event == "INSPECT_READY" or
       event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" then
        C_Timer.After(0.1, sortArenaEnemyFrames)
    end
end

-- Initialize arena frame sorting functionality
local function initializeArenaFrameSort()
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
    eventFrame:RegisterEvent("INSPECT_READY") 
    eventFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
    eventFrame:SetScript("OnEvent", handleArenaFrameEvents)
end

-- Start arena frame sorting when addon loads
local loadEventFrame = CreateFrame("Frame")
loadEventFrame:RegisterEvent("ADDON_LOADED")
loadEventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "BentoPlus" then
        initializeArenaFrameSort()
        loadEventFrame:UnregisterAllEvents()
    end
end)