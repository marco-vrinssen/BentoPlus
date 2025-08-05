-- Display available commands and their descriptions on login

local function displayAvailableCommands()
  print("|cffffffffBentoPlus Available Commands:|r")
  print("|cffffff80/rl|r|cffffffff: Reload UI with graphics restart and cache clear|r")
  print("|cffffff80/ui|r|cffffffff: Reload UI|r")
  print("|cffffff80/gx|r|cffffffff: Restart graphics|r")
  print("|cffffff80/errors|r|cffffffff: Toggle script error display|r")
  print("|cffffff80/bentoraidframe|r|cffffffff: Toggle raid frame aura visibility|r")
  print("|cffffff80/bentoarenaframe|r|cffffffff: Toggle arena frame element visibility|r")
  print("|cffffff80/bentobuttonglow|r|cffffffff: Toggle button glow effect visibility|r")
  print("|cffffff80/multiwhisper|r|cffffffff: Open multi-whisper interface for player lists|r")
  print("|cffffff80/w+ MESSAGE|r|cffffffff: Send MESSAGE to all players in whisper list|r")
  print("|cffffff80/recruitmessage|r|cffffffff: Set customizable guild invitation message|r")
  print("|cffffff80/autorecruit|r|cffffffff: Manage auto-recruitment settings and messages|r")
  print("|cffffff80/pm|r|cffffffff: Mark all party members with raid markers|r")
  print("|cffffffffRight-click Main Menu button to reload UI|r")
end

-- Register event listener for player login to show commands

local introMessageFrame = CreateFrame("Frame")
introMessageFrame:RegisterEvent("PLAYER_LOGIN")
introMessageFrame:SetScript("OnEvent", function()
  C_Timer.After(2, displayAvailableCommands)
end)