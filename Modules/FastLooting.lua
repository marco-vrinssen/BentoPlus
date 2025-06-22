local function configureLootRate()
    SetCVar("autoLootRate", 0)
end

local function lootAllSlots()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        local lootItemCount = GetNumLootItems()
        if lootItemCount > 0 then
            LootFrame:Hide()
            for slotIndex = lootItemCount, 1, -1 do
                LootSlot(slotIndex)
            end
        end
    end
end

local function closeEmptyWindow()
    if GetNumLootItems() == 0 then
        CloseLoot()
    end
end

-- Initialize fast looting

local lootEventHandler = CreateFrame("Frame")
lootEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
lootEventHandler:RegisterEvent("LOOT_READY")
lootEventHandler:RegisterEvent("LOOT_OPENED")
lootEventHandler:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_ENTERING_WORLD" then
        configureLootRate()
    elseif event == "LOOT_READY" then
        lootAllSlots()
    elseif event == "LOOT_OPENED" then
        closeEmptyWindow()
    end
end)