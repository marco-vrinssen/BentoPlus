local CancelAuraEvents = CreateFrame("Frame")
CancelAuraEvents:RegisterEvent("UNIT_AURA")
CancelAuraEvents:SetScript("OnEvent", function(self, event, arg1)
    if event == "UNIT_AURA" and arg1 == "player" then
        for i = 1, 40 do
            local name, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
            if name == "Wrapped Up In Weaving" then
                CancelUnitBuff("player", i)
                break
            end
        end
    end
end)