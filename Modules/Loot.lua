-- Update loot rate configuration

local function UpdateLootRate()
    SetCVar("autoLootRate", 0.0001)
end

local LootConfigFrame = CreateFrame("Frame")
LootConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LootConfigFrame:SetScript("OnEvent", UpdateLootRate)




-- Speed up the auto looting process

local function FasterLooting()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        local numLootItems = GetNumLootItems()
        if numLootItems > 0 then
            LootFrame:Hide() -- Hide the loot frame
            for ItemCount = 1, numLootItems do
                LootSlot(ItemCount)
            end
        end
    end
end

local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterLooting)