-- Update loot rate configuration

local function UpdateLootRate()
    SetCVar("autoLootRate", 0)
end

local LootConfigFrame = CreateFrame("Frame")
LootConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LootConfigFrame:SetScript("OnEvent", UpdateLootRate)




-- Speed up the auto looting process

local function FasterLooting()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        LootFrame:Hide()
        for ItemCount = 1, GetNumLootItems() do
            LootSlot(ItemCount)
        end
        LootFrame:Hide()
    end
end

local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterLooting)