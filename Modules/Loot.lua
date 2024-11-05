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
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
        for name, frame in pairs(_G) do
            if type(frame) == "table" and frame.Hide and name:find("LootFrame") then
                frame:Hide()
            end
        end
    end
end

local LootTrigger = CreateFrame("Frame")
LootTrigger:RegisterEvent("LOOT_READY")
LootTrigger:SetScript("OnEvent", UpdateAutoLoot)