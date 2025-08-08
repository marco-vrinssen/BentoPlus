-- Auto loot functionality with slight delay to ensure loot list stability

local lootTime = 0
local LOOT_DELAY = 0.05

-- Set autoLootRate CVar to instant

local function setInstantAutoLootRate()
    SetCVar("autoLootRate", 0)
end

-- Perform delayed auto-loot iteration across slots

local function handleAutoLootWithDelay()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        if (GetTime() - lootTime) >= LOOT_DELAY then
            for slotIndex = GetNumLootItems(), 1, -1 do
                LootSlot(slotIndex)
            end
            lootTime = GetTime()
        end
    end
end

local lootAddon = CreateFrame("Frame")
lootAddon:RegisterEvent("PLAYER_ENTERING_WORLD")
lootAddon:RegisterEvent("LOOT_READY")
lootAddon:SetScript("OnEvent", function(self, eventType)
    if eventType == "PLAYER_ENTERING_WORLD" then
        setInstantAutoLootRate()
    elseif eventType == "LOOT_READY" then
        handleAutoLootWithDelay()
    end
end)