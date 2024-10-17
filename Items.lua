-- AUTO SELL GREY ITEMS AND REPAIR GEAR

local function AutoSellRepair()
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)
                if itemRarity == 0 and itemSellPrice > 0 then
                    C_Container.UseContainerItem(bag, slot)
                    PickupMerchantItem()
                end
            end
        end
    end

    if CanMerchantRepair() then
        local repairCost, canRepair = GetRepairAllCost()
        if canRepair and repairCost > 0 then
            if IsInGuild() and CanGuildBankRepair() then
                local availableFunds = min(GetGuildBankWithdrawMoney(), GetGuildBankMoney())
                if availableFunds >= repairCost then
                    RepairAllItems(true)
                end
            end
            if repairCost <= GetMoney() then
                RepairAllItems(false)
            end
        end
    end
end

local MerchantEvents = CreateFrame("Frame")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)
MerchantEvents:RegisterEvent("MERCHANT_SHOW")




-- POST ITEMS ON THE AUCTIONHOUSE WITH SPACEBAR

local KeyPressFrame = CreateFrame("Frame")

local function OnKeyPress(self, key)
    if key == "SPACE" then
        if AuctionHouseFrame and AuctionHouseFrame:IsShown() then
            local commoditiesSellFrame = AuctionHouseFrame.CommoditiesSellFrame
            local itemsSellFrame = AuctionHouseFrame.ItemsSellFrame

            if (commoditiesSellFrame and commoditiesSellFrame:IsShown()) or (itemsSellFrame and itemsSellFrame:IsShown()) then
                if commoditiesSellFrame and commoditiesSellFrame:IsShown() then
                    commoditiesSellFrame.PostButton:Click()
                elseif itemsSellFrame and itemsSellFrame:IsShown() then
                    itemsSellFrame.PostButton:Click()
                end
                self:SetPropagateKeyboardInput(false)
                return
            end
        end
    end
    self:SetPropagateKeyboardInput(true)
end

KeyPressFrame:SetScript("OnKeyDown", OnKeyPress)
KeyPressFrame:EnableKeyboard(true)
KeyPressFrame:SetPropagateKeyboardInput(true)