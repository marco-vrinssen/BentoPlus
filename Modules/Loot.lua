-- Update loot rate configuration

local function UpdateLootRate()
    SetCVar("autoLootRate", 0)
end

local LootConfigFrame = CreateFrame("Frame")
LootConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LootConfigFrame:SetScript("OnEvent", UpdateLootRate)




-- Speed up auto looting while hiding the loot frame during the looting

local LootEpoch = 0
local LootDelay = 0.1

local function FasterLooting()
	if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
		if (GetTime() - LootEpoch) >= LootDelay then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end    
			LootEpoch = GetTime()
            LootFrame:Hide()
		end
	end
end

local LootTrigger = CreateFrame("Frame")
LootTrigger:RegisterEvent("LOOT_READY")
LootTrigger:SetScript("OnEvent", FasterLooting)