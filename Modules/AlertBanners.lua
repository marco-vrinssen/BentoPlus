-- Mute alert sounds and unregister related events.
-- TEST
local function configureAlertBanners()
  MuteSoundFile(569143)
  AlertFrame:UnregisterAllEvents()
end

-- Defer alert configuration until the player enters the world.

local alertBannerFrame = CreateFrame("Frame")
alertBannerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
alertBannerFrame:SetScript("OnEvent", configureAlertBanners)