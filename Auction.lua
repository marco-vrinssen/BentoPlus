-- Function to handle key press events
local function OnKeyPress(self, key)
    if key == "SPACE" then
        if InCombatLockdown() then
            self:SetPropagateKeyboardInput(true)
            return
        end

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

-- Create a frame to handle auction house events
local KeyPressFrame = CreateFrame("Frame")

-- Register events for showing and closing the auction house
KeyPressFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
KeyPressFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")

-- Set scripts for handling the registered events
KeyPressFrame:SetScript("OnEvent", function(self, event)
    if event == "AUCTION_HOUSE_SHOW" then
        self:SetScript("OnKeyDown", OnKeyPress)
        self:EnableKeyboard(true)
    elseif event == "AUCTION_HOUSE_CLOSED" then
        self:SetScript("OnKeyDown", nil)
        self:EnableKeyboard(false)
    end
end)

KeyPressFrame:SetPropagateKeyboardInput(true)