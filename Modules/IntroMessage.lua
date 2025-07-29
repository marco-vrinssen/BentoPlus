-- Display available commands and their descriptions on login

local function displayAvailableCommands()
  print("|cffffffffBentoPlus Available Commands:|r")
  print("|cff00ff00/rl|r: Reload the UI with a graphics restart and cache clear")
  print("|cff00ff00/ui|r: Reload the UI")
  print("|cff00ff00/gx|r: Restart graphics")
  print("|cff00ff00/errors|r: Toggle error display on/off")
  print("|cff00ff00/raidframeauras|r: Toggle visibility of raid frame auras")
  print("|cff00ff00/arenaframeelements|r: Toggle visibility of arena frame elements")
  print("|cff00ff00/buttonglow|r: Toggle visibility of button glow effects")
  print("|cffffffffRight-click Main Menu button to reload UI|r")
end

-- Register event listener for player login to show commands

local introMessageFrame = CreateFrame("Frame")
introMessageFrame:RegisterEvent("PLAYER_LOGIN")
introMessageFrame:SetScript("OnEvent", function()
  C_Timer.After(2, displayAvailableCommands)
end)