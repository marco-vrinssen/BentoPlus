-- Display available BentoPlus commands on login and provide shared helpers

-- Create BentoPlus namespace so that modules can reuse helpers
BentoPlus = BentoPlus or {}

-- Highlight helper for light-yellow text
function BentoPlus.hl(text)
  return "|cffffff80" .. tostring(text) .. "|r"
end

-- Standard print helper with white base label and body
function BentoPlus.print(msg)
  if not msg then return end
  print("|cffffffffBentoPlus:|r |cffffffff" .. tostring(msg) .. "|r")
end

-- Centralized notifications used by feature modules
BentoPlus.Notify = BentoPlus.Notify or {}

function BentoPlus.Notify.ButtonGlowToggled(isVisible)
  if isVisible then
    BentoPlus.print("Button glow effects are now " .. BentoPlus.hl("visible") .. "|cffffffff on action bars.|r")
  else
    BentoPlus.print("Button glow effects are now " .. BentoPlus.hl("hidden") .. "|cffffffff for cleaner UI.|r")
  end
end

function BentoPlus.Notify.ButtonGlowDefaultHidden()
  BentoPlus.print("Button glow effects are " .. BentoPlus.hl("hidden") .. "|cffffffff by default. Use " .. BentoPlus.hl("/bentoglow") .. "|cffffffff to toggle.|r")
end

function BentoPlus.Notify.RaidAurasToggled(isVisible)
  if isVisible then
    BentoPlus.print("Raid frame auras are now " .. BentoPlus.hl("visible") .. "|cffffffff on all frames.|r")
  else
    BentoPlus.print("Raid frame auras are now " .. BentoPlus.hl("hidden") .. "|cffffffff for better performance.|r")
  end
end

function BentoPlus.Notify.RaidAurasDefaultHidden()
  BentoPlus.print("Raid frame auras are " .. BentoPlus.hl("hidden") .. "|cffffffff by default. Use " .. BentoPlus.hl("/bentoraid") .. "|cffffffff to toggle.|r")
end

function BentoPlus.Notify.ArenaElementsToggled(isRestored)
  if isRestored then
    BentoPlus.print("Arena frame elements are now " .. BentoPlus.hl("restored") .. "|cffffffff (cast bar " .. BentoPlus.hl("shown") .. "|cffffffff).|r")
  else
    BentoPlus.print("Arena frame elements are now " .. BentoPlus.hl("modified") .. "|cffffffff (cast bar " .. BentoPlus.hl("hidden") .. "|cffffffff).|r")
  end
end

function BentoPlus.Notify.ArenaElementsDefaultModified()
  BentoPlus.print("Arena frame elements are " .. BentoPlus.hl("modified") .. "|cffffffff by default (cast bar " .. BentoPlus.hl("hidden") .. "|cffffffff). Use " .. BentoPlus.hl("/bentoarena") .. "|cffffffff to toggle.|r")
end

local function displayAvailableCommands()
  print("|cffffffffBentoPlus Available Commands:|r")
  print("|cffffff80/bentoraid|r|cffffffff: Toggle raid frame aura visibility|r")
  print("|cffffff80/bentoarena|r|cffffffff: Toggle arena frame element visibility|r")
  print("|cffffff80/bentoglow|r|cffffffff: Toggle button glow effect visibility|r")
  print("|cffffff80/w+|r|cffffffff: Open multi-whisper interface for player lists|r")
  print("|cffffff80/w+ MESSAGE|r|cffffffff: Send MESSAGE to all players in whisper list|r")
  print("|cffffffffRight-click Main Menu button to reload UI|r")

  -- Also show current status for quick visibility
  local raidAuras = BentoDB and BentoDB.RaidFrameAuras == true
  local arenaRestored = BentoDB and BentoDB.ArenaFrameElements == true
  local glowVisible = BentoDB and BentoDB.ButtonGlowVisibility == true

  print("|cffffffffBentoPlus Current Status:|r")
  print("- |cffffffffRaid frame auras:|r " .. (raidAuras and BentoPlus.hl("visible") or BentoPlus.hl("hidden")) .. "|cffffffff.|r")
  print("- |cffffffffArena elements:|r " .. (arenaRestored and BentoPlus.hl("restored") or BentoPlus.hl("modified")) .. "|cffffffff (cast bar " .. (arenaRestored and BentoPlus.hl("shown") or BentoPlus.hl("hidden")) .. "|cffffffff).|r")
  print("- |cffffffffButton glow:|r " .. (glowVisible and BentoPlus.hl("visible") or BentoPlus.hl("hidden")) .. "|cffffffff.|r")
end

-- Register login event for delayed command list display

local introMessageFrame = CreateFrame("Frame")
introMessageFrame:RegisterEvent("PLAYER_LOGIN")
introMessageFrame:SetScript("OnEvent", function()
  C_Timer.After(2, displayAvailableCommands)
end)

-- Add slash command to show commands and status on demand
SLASH_BENTOPLUS1 = "/bento"
SlashCmdList["BENTOPLUS"] = displayAvailableCommands