-- Update auto loot handler to improve stability to reduce loot errors

local lastLootTime = 0
local lootDelay = 0.05

-- Update loot rate setting to reduce looting time to improve gameplay flow

local function setLootRateInstant()
    SetCVar("autoLootRate", 0)
end

-- Update auto loot default to enable auto looting to improve looting speed

local function enableAutoLoot()
    SetCVar("autoLootDefault", 1)
end

-- Perform auto loot with delay across slots to ensure stability to improve reliability

local function handleAutoLootWithDelay()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        if (GetTime() - lastLootTime) >= lootDelay then
            for slotIndex = GetNumLootItems(), 1, -1 do
                LootSlot(slotIndex)
            end
            lastLootTime = GetTime()
        end
    end
end

local lootEventFrame = CreateFrame("Frame")
lootEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lootEventFrame:RegisterEvent("LOOT_READY")
lootEventFrame:SetScript("OnEvent", function(self, eventType)
    if eventType == "PLAYER_ENTERING_WORLD" then
    enableAutoLoot()
    setLootRateInstant()
    elseif eventType == "LOOT_READY" then
        handleAutoLootWithDelay()
    end
end)