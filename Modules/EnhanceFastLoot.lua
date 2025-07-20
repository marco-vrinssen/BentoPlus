
-- Set the loot rate to instant for faster looting

local function setInstantLootRateCVar()
    SetCVar("autoLootRate", 0)
end

-- Loot all available slots automatically if auto-loot is enabled

local function lootAllAvailableSlotsAutomatically()
    if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
        local totalLootItemCount = GetNumLootItems()
        if totalLootItemCount > 0 then
            LootFrame:Hide()
            for lootSlotIndex = totalLootItemCount, 1, -1 do
                LootSlot(lootSlotIndex)
            end
        end
    end
end

-- Close the loot window if there are no items left

local function closeLootWindowIfEmpty()
    if GetNumLootItems() == 0 then
        CloseLoot()
    end
end

-- Register loot-related events for fast looting automation

local fastLootEventFrame = CreateFrame("Frame")
fastLootEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
fastLootEventFrame:RegisterEvent("LOOT_READY")
fastLootEventFrame:RegisterEvent("LOOT_OPENED")
fastLootEventFrame:SetScript("OnEvent", function(_, eventTypeString)
    if eventTypeString == "PLAYER_ENTERING_WORLD" then
        setInstantLootRateCVar()
    elseif eventTypeString == "LOOT_READY" then
        lootAllAvailableSlotsAutomatically()
    elseif eventTypeString == "LOOT_OPENED" then
        closeLootWindowIfEmpty()
    end
end)