-- Automatically sell all junk items to merchant using safe API
local function sellJunk()
    -- Avoid taint during combat
    if InCombatLockdown() then return end

    -- Prefer Blizzard helper if available
    if C_MerchantFrame and C_MerchantFrame.SellAllJunk then
        C_MerchantFrame.SellAllJunk()
        return
    end

    -- Fallback: iterate bags and sell poor-quality items
    for bagId = 0, NUM_BAG_SLOTS do
        local slotCount = C_Container.GetContainerNumSlots(bagId)
        for slotId = 1, slotCount do
            local info = C_Container.GetContainerItemInfo(bagId, slotId)
            if info and info.quality == Enum.ItemQuality.Poor and not info.isLocked and not info.hasNoValue then
                C_Container.UseContainerItem(bagId, slotId)
            end
        end
    end
end

-- Automatically repair all items using merchant API
local function repairItems()
    -- Avoid taint during combat
    if InCombatLockdown() then return end

    if CanMerchantRepair and CanMerchantRepair() then
        -- Use personal funds; guild repair can be added later if desired
        RepairAllItems()
    end
end

-- Handle merchant interaction by performing sell + repair
local function handleMerchant()
    sellJunk()
    repairItems()
end

-- Create merchant event handler frame
local merchantFrame = CreateFrame("Frame")
merchantFrame:SetScript("OnEvent", handleMerchant)
merchantFrame:RegisterEvent("MERCHANT_SHOW")