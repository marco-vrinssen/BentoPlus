-- Initialize database for storing button glow visibility state

local buttonGlowVisibilityState = "ButtonGlowVisibility"

if not BentoDB then
  BentoDB = {}
end
if BentoDB[buttonGlowVisibilityState] == nil then
  BentoDB[buttonGlowVisibilityState] = false
end

-- Check if button glow should be hidden

local function shouldHideButtonGlow()
  return not BentoDB[buttonGlowVisibilityState]
end

-- Toggle visibility of button glow and show status message

local function toggleButtonGlowVisibility()
  BentoDB[buttonGlowVisibilityState] = not BentoDB[buttonGlowVisibilityState]
  if BentoDB[buttonGlowVisibilityState] then
    print("|cffffffffBentoPlus: Button glow is now |cff0080ffshown|r.")
  else
    print("|cffffffffBentoPlus: Button glow is now |cff0080ffhidden|r.")
  end
end

-- Register slash command for toggling button glow

SLASH_BENTOPLUS_BUTTONGLOW1 = "/buttonglow"
SlashCmdList["BENTOPLUS_BUTTONGLOW"] = toggleButtonGlowVisibility

-- Show notification on login if button glow is hidden

local buttonGlowLoginFrame = CreateFrame("Frame")
buttonGlowLoginFrame:RegisterEvent("PLAYER_LOGIN")
buttonGlowLoginFrame:SetScript("OnEvent", function()
  if not BentoDB[buttonGlowVisibilityState] then
    print("|cffffffffBentoPlus: Button glow is |cff0080ffhidden|r by default. Use /buttonglow to toggle.")
  end
end)

-- Blizzard Bars

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
