-- POST ITEMS ON THE AUCTIONHOUSE WITH SPACEBAR

local KeyPressFrame = CreateFrame("Frame")

local function OnKeyPress(self, key)
    if key == "SPACE" then
        if AuctionHouseFrame and AuctionHouseFrame:IsShown() then
            local commoditiesSellFrame = AuctionHouseFrame.CommoditiesSellFrame
            local itemSellFrame = AuctionHouseFrame.ItemSellFrame

            if (commoditiesSellFrame and commoditiesSellFrame:IsShown()) or (itemSellFrame and itemSellFrame:IsShown()) then
                if commoditiesSellFrame and commoditiesSellFrame:IsShown() then
                    commoditiesSellFrame.PostButton:Click()
                elseif itemSellFrame and itemSellFrame:IsShown() then
                    itemSellFrame.PostButton:Click()
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