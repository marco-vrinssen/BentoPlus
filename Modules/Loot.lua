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
        local ItemsTotal = GetNumLootItems()
        if ItemsTotal > 0 then
            for ItemCount = 1, ItemsTotal do
                LootSlot(ItemCount)
            end
        end
    end
end

local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterLooting)