-- Display available BentoPlus commands on login

local function displayAvailableCommands()
  print("|cffffffffBentoPlus Available Commands:|r")
  print("|cffffff80/rl|r|cffffffff: Reload UI with graphics restart and cache clear|r")
  print("|cffffff80/ui|r|cffffffff: Reload UI|r")
  print("|cffffff80/gx|r|cffffffff: Restart graphics|r")
  print("|cffffff80/errors|r|cffffffff: Toggle script error display|r")
  print("|cffffff80/bentoraid|r|cffffffff: Toggle raid frame aura visibility|r")
  print("|cffffff80/bentoarena|r|cffffffff: Toggle arena frame element visibility|r")
  print("|cffffff80/bentoglow|r|cffffffff: Toggle button glow effect visibility|r")
  print("|cffffff80/multiwhisper|r|cffffffff: Open multi-whisper interface for player lists|r")
  print("|cffffff80/w+ MESSAGE|r|cffffffff: Send MESSAGE to all players in whisper list|r")
  print("|cffffffffRight-click Main Menu button to reload UI|r")
end

-- Register login event for delayed command list display

local introMessageFrame = CreateFrame("Frame")
introMessageFrame:RegisterEvent("PLAYER_LOGIN")
introMessageFrame:SetScript("OnEvent", function()
  C_Timer.After(2, displayAvailableCommands)
end)