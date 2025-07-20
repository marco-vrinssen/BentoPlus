

-- Sell all junk items automatically when merchant window opens

local function sellAllJunkItemsAutomatically()
    C_Timer.After(0.1, function()
        MerchantSellAllJunkButton:Click()

        C_Timer.After(0.1, function()
            StaticPopup1Button1:Click()
        end)
    end)
end



-- Repair all equipment automatically when merchant window opens

local function repairAllEquipmentAutomatically()
    C_Timer.After(0.1, function()
        MerchantRepairAllButton:Click()
    end)
end



-- Handle merchant window show event to trigger automation

local function handleMerchantWindowShowEvent()
    sellAllJunkItemsAutomatically()
    repairAllEquipmentAutomatically()
end



-- Create merchantAutomationEventFrame to manage merchant automation events

local merchantAutomationEventFrame = CreateFrame("Frame")
merchantAutomationEventFrame:SetScript("OnEvent", handleMerchantWindowShowEvent)
merchantAutomationEventFrame:RegisterEvent("MERCHANT_SHOW")









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