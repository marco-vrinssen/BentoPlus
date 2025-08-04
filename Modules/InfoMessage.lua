-- Display available commands and their descriptions on login

local function displayAvailableCommands()
  print("|cffffffffBentoPlus Available Commands:|r")
  print("|cffadc9ff/rl|r: Reload UI with graphics restart and cache clear")
  print("|cffadc9ff/ui|r: Reload UI")
  print("|cffadc9ff/gx|r: Restart graphics")
  print("|cffadc9ff/errors|r: Toggle script error display")
  print("|cffadc9ff/bentoraidframe|r: Toggle raid frame aura visibility")
  print("|cffadc9ff/bentoarenaframe|r: Toggle arena frame element visibility")
  print("|cffadc9ff/bentobuttonglow|r: Toggle button glow effect visibility")
  print("|cffadc9ff/recruit|r: Open recruitment window for adding multiple friends")
  print("|cffadc9ff/w+ MESSAGE|r: Send MESSAGE to all players in recruitment list")
  print("|cffffffffRight-click Main Menu button to reload UI|r")
end

-- Register event listener for player login to show commands

local introMessageFrame = CreateFrame("Frame")
introMessageFrame:RegisterEvent("PLAYER_LOGIN")
introMessageFrame:SetScript("OnEvent", function()
  C_Timer.After(2, displayAvailableCommands)
end)