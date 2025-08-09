-- Update database to manage button glow visibility so that we control overlays

local buttonGlowKey = "ButtonGlowVisibility"

if not BentoDB then
  BentoDB = {}
end
if BentoDB[buttonGlowKey] == nil then
	BentoDB[buttonGlowKey] = false
end

-- Determine if button glow overlays should be hidden

local function shouldHideButtonGlow()
	return not BentoDB[buttonGlowKey]
end

-- Toggle button glow visibility and print status

local function toggleButtonGlowVisibility()
	BentoDB[buttonGlowKey] = not BentoDB[buttonGlowKey]
	if BentoDB[buttonGlowKey] then
    print("|cffffffffBentoPlus: Button glow effects are now |cffadc9ffvisible|r on action bars.")
  else
    print("|cffffffffBentoPlus: Button glow effects are now |cffadc9ffhidden|r for cleaner UI.")
  end
end

-- Register slash command for button glow toggle

SLASH_BENTOPLUS_BUTTONGLOW1 = "/bentoglow"
SlashCmdList["BENTOPLUS_BUTTONGLOW"] = toggleButtonGlowVisibility

-- Notify user on login when button glow starts hidden

local buttonGlowFrame = CreateFrame("Frame")
buttonGlowFrame:RegisterEvent("PLAYER_LOGIN")
buttonGlowFrame:SetScript("OnEvent", function()
	if not BentoDB[buttonGlowKey] then
    print("|cffffffffBentoPlus: Button glow effects are |cffadc9ffhidden|r by default. Use |cffadc9ff/bentoglow|r to toggle.")
  end
end)

-- Hook Blizzard action button glow functions to hide overlays

if ActionButtonSpellAlertManager and C_ActionBar.IsAssistedCombatAction then
	local IsAssistedCombatAction = C_ActionBar.IsAssistedCombatAction
	hooksecurefunc(ActionButtonSpellAlertManager, "ShowAlert", function(_, actionButton)
		if shouldHideButtonGlow() then
			local action = actionButton.action
			if action and IsAssistedCombatAction(action) then
				if actionButton.AssistedCombatRotationFrame and actionButton.AssistedCombatRotationFrame.SpellActivationAlert then
					actionButton.AssistedCombatRotationFrame.SpellActivationAlert:Hide()
				end
			elseif actionButton.SpellActivationAlert then
				actionButton.SpellActivationAlert:Hide()
			end
		end
	end)
else
	hooksecurefunc("ActionButton_ShowOverlayGlow", function(actionButton)
		if shouldHideButtonGlow() and actionButton then
			if actionButton.overlay then
				actionButton.overlay:Hide()
			elseif actionButton.SpellActivationAlert then
				actionButton.SpellActivationAlert:Hide()
			end
		end
	end)
end
