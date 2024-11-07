-- Function to automatically sell junk and repair items

local function AutoSellRepair()
    MerchantSellAllJunkButton:Click()
    StaticPopup1Button1:Click()
    C_Timer.After(0, function()
        MerchantRepairAllButton:Click()
    end)
end

local MerchantEvents = CreateFrame("Frame")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)
MerchantEvents:RegisterEvent("MERCHANT_SHOW")







-- Update loot rate configuration

local function UpdateLootRate()
    SetCVar("autoLootRate", 0)
end

local LootConfigFrame = CreateFrame("Frame")
LootConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LootConfigFrame:SetScript("OnEvent", UpdateLootRate)




-- Speed up auto looting while hiding the loot frame during the looting

local function UpdateAutoLoot()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        local numLootItems = GetNumLootItems()
        if numLootItems > 0 then
            LootFrame:Hide()
            for i = numLootItems, 1, -1 do
                LootSlot(i)
            end
        end
    end
end

local LootTrigger = CreateFrame("Frame")
LootTrigger:RegisterEvent("LOOT_READY")
LootTrigger:SetScript("OnEvent", UpdateAutoLoot)