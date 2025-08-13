-- Show hint on login and provide /bento to list commands

local function printCommandList()
  print("Bento Plus: [commands]")
  print("[/bentoraid]: Toggle raid frame auras")
  print("[/bentoarena]: Toggle arena elements")
  print("[/bentoglow]: Toggle button glow effects")
  print("[/w+]: Open multi-whisper UI")
  print("[/w+ MESSAGE]: Send MESSAGE to whisper list")
  print("[Right-click Main Menu]: Reload UI")
end

-- Display login hint shortly after login
local loginHintFrame = CreateFrame("Frame")
loginHintFrame:RegisterEvent("PLAYER_LOGIN")
loginHintFrame:SetScript("OnEvent", function()
  C_Timer.After(2, function()
    print("Bento Plus: type /bento for available commands.")
  end)
end)

-- Register slash command to display the command list
SLASH_BENTOPLUS1 = "/bento"
SlashCmdList["BENTOPLUS"] = printCommandList