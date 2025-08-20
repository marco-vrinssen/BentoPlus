-- Hide Blizzard action button glow overlays (spell activation and assisted rotation)

-- hide overlays for a given action button

local function hide(btn)
	if not btn then return end

	-- hide assisted rotation alert
	local acr = btn.AssistedCombatRotationFrame
	if acr and acr.SpellActivationAlert then
		acr.SpellActivationAlert:Hide()
	end

	-- hide classic overlay variants
	if btn.overlay then
		btn.overlay:Hide()
	end
	if btn.SpellActivationAlert then
		btn.SpellActivationAlert:Hide()
	end
end

-- hook modern alert manager if available

if ActionButtonSpellAlertManager then
	hooksecurefunc(ActionButtonSpellAlertManager, "ShowAlert", function(_, btn)
		hide(btn)
	end)

-- fallback to legacy overlay hook
else
	hooksecurefunc("ActionButton_ShowOverlayGlow", function(btn)
		hide(btn)
	end)
end
