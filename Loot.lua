-- Function to update loot rate configuration settings
local function UpdateLootRate()
    SetCVar("autoLootRate", 0)
end

-- Create a frame to handle loot rate configuration events
local LootConfigFrame = CreateFrame("Frame")
LootConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LootConfigFrame:SetScript("OnEvent", UpdateLootRate)

-- Function to handle faster looting process
local function FasterLooting()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        local ItemsTotal = GetNumLootItems()
        if ItemsTotal > 0 then
            LootFrame:Hide()
            for ItemCount = 1, ItemsTotal do
                LootSlot(ItemCount)
            end
        end
        C_Timer.After(0, function()
            LootFrame:Hide()
        end)
    end
end

-- Create a frame to handle loot events
local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterLooting)