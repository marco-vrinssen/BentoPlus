-- Display available commands and their descriptions on login

local function displayAvailableCommands()
  print("|cffffffffBentoPlus Available Commands:|r")
  print("|cff00ff00/rl|r: Reload UI with graphics restart and cache clear")
  print("|cff00ff00/ui|r: Reload UI")
  print("|cff00ff00/gx|r: Restart graphics")
  print("|cff00ff00/errors|r: Toggle script error display")
  print("|cff00ff00/raidframeauras|r: Toggle raid frame aura visibility")
  print("|cff00ff00/arenaframeelements|r: Toggle arena frame element visibility")
  print("|cff00ff00/buttonglow|r: Toggle button glow effect visibility")
  print("|cffffffffRight-click Main Menu button to reload UI|r")
end

-- Register event listener for player login to show commands

local introMessageFrame = CreateFrame("Frame")
introMessageFrame:RegisterEvent("PLAYER_LOGIN")
introMessageFrame:SetScript("OnEvent", function()
  C_Timer.After(2, displayAvailableCommands)
end)