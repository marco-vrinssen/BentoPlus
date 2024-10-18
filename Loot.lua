local EPOCH = 0
local DELAY = 0.05

local function FasterAutoLoot()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        if (GetTime() - EPOCH) >= DELAY then
            for i = GetNumLootItems(), 1, -1 do
                LootSlot(i)
                LootFrame:Hide()
            end
            EPOCH = GetTime()
        end
    end
end

local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterAutoLoot)