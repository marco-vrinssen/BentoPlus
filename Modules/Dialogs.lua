-- Core functionality to hide and auto-confirm popups in WoW Retail

local function HidePopup(popupName, ...)
    local popup = StaticPopup_FindVisible(popupName, ...)
    if popup then
        popup:Hide()
        return true
    end
    return false
end

local function AutoConfirmPopup(popupName, onAcceptFunc, ...)
    if HidePopup(popupName, ...) then
        RunNextFrame(onAcceptFunc, ...)
    end
end

local function OnEvent(self, event, ...)
    if event == "LOOT_BIND_CONFIRM" then
        AutoConfirmPopup("LOOT_BIND", StaticPopupDialogs["LOOT_BIND"].OnAccept, ...)
    elseif event == "EQUIP_BIND_TRADEABLE_CONFIRM" then
        AutoConfirmPopup("EQUIP_BIND_TRADEABLE", StaticPopupDialogs["EQUIP_BIND_TRADEABLE"].OnAccept, ...)
    elseif event == "EQUIP_BIND_REFUNDABLE_CONFIRM" then
        AutoConfirmPopup("EQUIP_BIND_REFUNDABLE", StaticPopupDialogs["EQUIP_BIND_REFUNDABLE"].OnAccept, ...)
    elseif event == "USE_NO_REFUND_CONFIRM" then
        AutoConfirmPopup("USE_NO_REFUND_CONFIRM", StaticPopupDialogs["USE_NO_REFUND_CONFIRM"].OnAccept, ...)
    elseif event == "MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL" then
        AutoConfirmPopup("CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL", SellCursorItem, ...)
    elseif event == "MAIL_LOCK_SEND_ITEMS" then
        AutoConfirmPopup("MAIL_LOCK_SEND_ITEMS", RespondMailLockSendItem, ...)
    elseif event == "CONFIRM_LOOT_ROLL" then
        AutoConfirmPopup("CONFIRM_LOOT_ROLL", StaticPopupDialogs["CONFIRM_LOOT_ROLL"].OnAccept, ...)
    elseif event == "CONFIRM_BINDER" then
        AutoConfirmPopup("CONFIRM_BINDER", ConfirmBinder, ...)
    elseif event == "DELETE_ITEM_CONFIRM" then
        AutoConfirmPopup("DELETE_ITEM", StaticPopupDialogs["DELETE_ITEM"].OnAccept, ...)
    elseif event == "CONFIRM_TALENT_WIPE" then
        AutoConfirmPopup("CONFIRM_TALENT_WIPE", StaticPopupDialogs["CONFIRM_TALENT_WIPE"].OnAccept, ...)
    end
end

local DialogEvents = CreateFrame("Frame")
DialogEvents:RegisterEvent("LOOT_BIND_CONFIRM")
DialogEvents:RegisterEvent("EQUIP_BIND_TRADEABLE_CONFIRM")
DialogEvents:RegisterEvent("EQUIP_BIND_REFUNDABLE_CONFIRM")
DialogEvents:RegisterEvent("USE_NO_REFUND_CONFIRM")
DialogEvents:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
DialogEvents:RegisterEvent("MAIL_LOCK_SEND_ITEMS")
DialogEvents:RegisterEvent("CONFIRM_LOOT_ROLL")
DialogEvents:RegisterEvent("CONFIRM_BINDER")
DialogEvents:RegisterEvent("DELETE_ITEM_CONFIRM")
DialogEvents:RegisterEvent("CONFIRM_TALENT_WIPE")
DialogEvents:SetScript("OnEvent", OnEvent)