-- Update bank open to auto switch to Warband so that we reduce clicks

-- Try to find the Warband tab button using multiple heuristics

local function findWarbandTab(tabSystem)
	if not tabSystem or not tabSystem.GetChildren then return nil end

	local function containsWarbandText(sourceText)
		return type(sourceText) == "string" and string.find(string.lower(sourceText), "warband", 1, true) ~= nil
	end

	-- Prefer structured tab access if available
	if tabSystem.GetNumTabs and tabSystem.GetTabButtonAtIndex then
		local tabCount = tabSystem:GetNumTabs()
		for i = 1, tabCount do
			local button = tabSystem:GetTabButtonAtIndex(i)
			if button then
				local tabId = button.GetTabID and button:GetTabID() or button.tabID or button.id or button.key
				local frameName = (button.GetName and button:GetName()) or nil
				local labelText = (button.Text and button.Text.GetText and button.Text:GetText()) or nil
				local tooltipText = button.tooltipText or (button.GetTooltipText and button:GetTooltipText())
				if containsWarbandText(tabId) or containsWarbandText(frameName) or containsWarbandText(labelText) or containsWarbandText(tooltipText) then
					return button, i
				end
			end
		end
	end

	-- Fallback: scan child frames for a matching tab-like button
	local childFrames = { tabSystem:GetChildren() }
	for i = 1, #childFrames do
		local button = childFrames[i]
		if button and button.GetObjectType and button:GetObjectType() == "Button" then
			local frameName = (button.GetName and button:GetName()) or nil
			local labelText = (button.Text and button.Text.GetText and button.Text:GetText()) or nil
			local tooltipText = button.tooltipText or (button.GetTooltipText and button:GetTooltipText())
			local tabId = button.GetTabID and button:GetTabID() or button.tabID or button.id or button.key
			if containsWarbandText(frameName) or containsWarbandText(labelText) or containsWarbandText(tooltipText) or containsWarbandText(tabId) then
				return button, nil
			end
		end
	end

	return nil, nil
end

-- Select the Warband tab using the strongest available API, return true on success

local function selectWarbandTab()
	if InCombatLockdown and InCombatLockdown() then return false end

	local bankFrame = _G.BankFrame
	if not bankFrame or not bankFrame.TabSystem or not bankFrame:IsShown() then return false end

	local tabSystem = bankFrame.TabSystem

	-- If the system exposes a direct select by id, prefer that
	if tabSystem.SelectTabByID then
		-- Try common identifiers directly in case they exist
		local triedDirect = false
		local candidateIds = { "warband", "Warband", "WARBand", "BANK_TAB_WARBAND" }
		for i = 1, #candidateIds do
			local success = pcall(function()
				tabSystem:SelectTabByID(candidateIds[i])
			end)
			if success then return true end
			triedDirect = true
		end

		-- If direct guess failed, resolve the button and use its id
		local button = select(1, findWarbandTab(tabSystem))
		if button and button.GetTabID then
			local tabId = button:GetTabID()
			if tabId ~= nil then
				local success = pcall(function()
					tabSystem:SelectTabByID(tabId)
				end)
				if success then return true end
			end
		end

		if triedDirect then return false end
	end

	-- Try selecting by index if available
	if tabSystem.GetNumTabs and tabSystem.GetTabButtonAtIndex then
		local _, tabIndex = findWarbandTab(tabSystem)
		if tabIndex and tabSystem.SelectTabAtIndex then
			local success = pcall(function()
				tabSystem:SelectTabAtIndex(tabIndex)
			end)
			if success then return true end
		end
	end

	-- Fallback: click the button directly
	local button = select(1, findWarbandTab(tabSystem))
	if button and button.Click then
		local success = pcall(function()
			button:Click()
		end)
		if success then return true end
	end

	-- Last-resort heuristic: third tab is often Warband; avoid if fewer tabs
	if tabSystem.SelectTabAtIndex and tabSystem.GetNumTabs and tabSystem:GetNumTabs() >= 3 then
		local success = pcall(function()
			tabSystem:SelectTabAtIndex(3)
		end)
		if success then return true end
	end

	return false
end

-- Schedule repeated attempts because the tab system can initialize after the frame shows

local function scheduleWarbandSelect()
	local bankFrame = _G.BankFrame
	if not bankFrame then return end

	if bankFrame.BentoPlusWarTicker then
		return
	end

	local remainingAttempts = 40
	bankFrame.BentoPlusWarTicker = C_Timer.NewTicker(0.05, function()
		if not bankFrame:IsShown() then
			if bankFrame.BentoPlusWarTicker and bankFrame.BentoPlusWarTicker.Cancel then
				bankFrame.BentoPlusWarTicker:Cancel()
			end
			bankFrame.BentoPlusWarTicker = nil
			return
		end

		if selectWarbandTab() then
			if bankFrame.BentoPlusWarTicker and bankFrame.BentoPlusWarTicker.Cancel then
				bankFrame.BentoPlusWarTicker:Cancel()
			end
			bankFrame.BentoPlusWarTicker = nil
			return
		end

		remainingAttempts = remainingAttempts - 1
		if remainingAttempts <= 0 then
			if bankFrame.BentoPlusWarTicker and bankFrame.BentoPlusWarTicker.Cancel then
				bankFrame.BentoPlusWarTicker:Cancel()
			end
			bankFrame.BentoPlusWarTicker = nil
		end
	end)
end

-- Hook bank frame show to trigger selection

local function hookBankFrame()
	local bankFrame = _G.BankFrame
	if bankFrame and not bankFrame.BentoPlusWarHooked then
		bankFrame.BentoPlusWarHooked = true
		bankFrame:HookScript("OnShow", scheduleWarbandSelect)
	end
end

-- Event routing to initialize when the bank is available

local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
	if event == "PLAYER_LOGIN" then
		hookBankFrame()
	elseif event == "ADDON_LOADED" then
		-- Bank UI loads on demand in some clients
		if arg1 and (arg1 == "Blizzard_BankUI" or arg1 == "Blizzard_Bank" or string.find(arg1, "Bank", 1, true)) then
			hookBankFrame()
		end
	elseif event == "BANKFRAME_OPENED" then
		hookBankFrame()
		scheduleWarbandSelect()
	elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and Enum and Enum.PlayerInteractionType then
		if arg1 == Enum.PlayerInteractionType.Banker then
			hookBankFrame()
			scheduleWarbandSelect()
		end
	end
end)

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("BANKFRAME_OPENED")
eventFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

