-- Initialize database flag for button glow visibility

local buttonGlowVisibilityState = "ButtonGlowVisibility"

if not BentoDB then
  BentoDB = {}
end
if BentoDB[buttonGlowVisibilityState] == nil then
  BentoDB[buttonGlowVisibilityState] = false
end

-- Determine if button glow overlays should be hidden

local function shouldHideButtonGlow()
  return not BentoDB[buttonGlowVisibilityState]
end

-- Toggle button glow visibility and print status

local function toggleButtonGlowVisibility()
  BentoDB[buttonGlowVisibilityState] = not BentoDB[buttonGlowVisibilityState]
  if BentoDB[buttonGlowVisibilityState] then
    print("|cffffffffBentoPlus: Button glow effects are now |cffadc9ffvisible|r on action bars.")
  else
    print("|cffffffffBentoPlus: Button glow effects are now |cffadc9ffhidden|r for cleaner UI.")
  end
end

-- Register slash command for button glow toggle

SLASH_BENTOPLUS_BUTTONGLOW1 = "/bentoglow"
SlashCmdList["BENTOPLUS_BUTTONGLOW"] = toggleButtonGlowVisibility

-- Notify user on login when button glow starts hidden

local buttonGlowLoginFrame = CreateFrame("Frame")
buttonGlowLoginFrame:RegisterEvent("PLAYER_LOGIN")
buttonGlowLoginFrame:SetScript("OnEvent", function()
  if not BentoDB[buttonGlowVisibilityState] then
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
