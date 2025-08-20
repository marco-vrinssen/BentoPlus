-- Persistently hide arena member name and debuffs for CompactArenaFrameMember frames

local function hidePersistently(targetWidget)
	if not targetWidget then return end

	targetWidget:Hide()
	if targetWidget.SetScript then
		targetWidget:SetScript("OnShow", targetWidget.Hide)
	end
end

-- Hide arena name and debuff subframes so that frames remain clean
local function hideArenaSubframes(arenaMemberFrame)
	if not arenaMemberFrame then return end

	hidePersistently(arenaMemberFrame.name)
	hidePersistently(arenaMemberFrame.DebuffFrame)
end

-- Iterate all compact arena frames so that all instances are processed
local function hideAllArenaFrames()
	for frameIndex = 1, 5 do
		local compactArenaFrame = _G["CompactArenaFrameMember" .. frameIndex]
		if compactArenaFrame then
			hideArenaSubframes(compactArenaFrame)
		end
	end
end

-- Reapply hiding on load and opponent updates so that new frames are covered
local arenaEventsFrame = CreateFrame("Frame")
arenaEventsFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
arenaEventsFrame:SetScript("OnEvent", hideAllArenaFrames)