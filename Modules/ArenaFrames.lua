local function HideArenaFrames()
    for i = 1, 3 do
        local arenaMemberFrame = _G["CompactArenaFrameMember"..i]
        if arenaMemberFrame then
            local elementsToHide = {
                arenaMemberFrame.CastingBarFrame,
                arenaMemberFrame.CcRemoverFrame,
                arenaMemberFrame.name,
                arenaMemberFrame.DebuffFrame,
                arenaMemberFrame.StealthFrame -- Added StealthFrame
            }
            for _, element in ipairs(elementsToHide) do
                if element then
                    element:SetScript("OnShow", function(self)
                        self:Hide()
                    end)
                    element:Hide()
                end
            end
        end
    end
end

local arenaMemberEvents = CreateFrame("Frame")
arenaMemberEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaMemberEvents:SetScript("OnEvent", HideArenaFrames)