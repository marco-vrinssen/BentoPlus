-- Update auto loot with short delay so that we ensure stability

local lastLootTime = 0
local lootDelay = 0.05

-- Update loot rate to instant so that we speed up looting

local function setInstantAutoLootRate()
    SetCVar("autoLootRate", 0)
end

-- Perform delayed auto loot across slots

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