-- Auto loot functionality with delay

local lootTime = 0
local LOOT_DELAY = 0.05

-- Set instant auto loot rate

local function setInstantAutoLootRate()
    SetCVar("autoLootRate", 0)
end

-- Handle auto loot with delay

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