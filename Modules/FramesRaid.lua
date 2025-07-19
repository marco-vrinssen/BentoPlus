-- -- Database for storing raid aura settings
-- BentoPlusDB = BentoPlusDB or {}

-- -- Initialize default settings
-- local function initializeDatabase()
--     if not BentoPlusDB.raidAuras then
--         BentoPlusDB.raidAuras = {
--             enabled = true
--         }
--     end
-- end

-- local function resizeAuraFrames(frame)
--     if not frame then return end
    
--     -- Check if raid auras are enabled
--     if not BentoPlusDB.raidAuras or not BentoPlusDB.raidAuras.enabled then
--         return
--     end
    
--     for i = 1, frame.maxBuffs or 0 do
--         local buffFrame = frame.buffFrames and frame.buffFrames[i]
--         if buffFrame then
--             buffFrame:SetSize(20, 20)
            
--             local icon = buffFrame.icon
--             if icon then
--                 icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
--             end
            
--             local cooldown = buffFrame.cooldown
--             if cooldown then
--                 cooldown:Hide()
--             end
--         end
--     end
    
--     for i = 1, frame.maxDebuffs or 0 do
--         local debuffFrame = frame.debuffFrames and frame.debuffFrames[i]
--         if debuffFrame then
--             debuffFrame:SetSize(20, 20)
            
--             local icon = debuffFrame.icon
--             if icon then
--                 icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
--             end
            
--             local border = debuffFrame.border
--             if border then
--                 border:Hide()
--             end
            
--             local cooldown = debuffFrame.cooldown
--             if cooldown then
--                 cooldown:Hide()
--             end
--         end
--     end
-- end

-- local function hideAllRaidAuras()
--     for i = 1, 40 do
--         local frame = _G["CompactRaidFrame" .. i]
--         if frame then
--             -- Hide buff frames
--             if frame.buffFrames then
--                 for j = 1, #frame.buffFrames do
--                     if frame.buffFrames[j] then
--                         frame.buffFrames[j]:Hide()
--                     end
--                 end
--             end
            
--             -- Hide debuff frames
--             if frame.debuffFrames then
--                 for j = 1, #frame.debuffFrames do
--                     if frame.debuffFrames[j] then
--                         frame.debuffFrames[j]:Hide()
--                     end
--                 end
--             end
--         end
--     end
    
--     -- Also handle party frames
--     for i = 1, 4 do
--         local frame = _G["CompactPartyFrame" .. i]
--         if frame then
--             -- Hide buff frames
--             if frame.buffFrames then
--                 for j = 1, #frame.buffFrames do
--                     if frame.buffFrames[j] then
--                         frame.buffFrames[j]:Hide()
--                     end
--                 end
--             end
            
--             -- Hide debuff frames
--             if frame.debuffFrames then
--                 for j = 1, #frame.debuffFrames do
--                     if frame.debuffFrames[j] then
--                         frame.debuffFrames[j]:Hide()
--                     end
--                 end
--             end
--         end
--     end
-- end

-- local function updateAllRaidFrames()
--     -- Update all raid frames
--     for i = 1, 40 do
--         local frame = _G["CompactRaidFrame" .. i]
--         if frame then
--             CompactUnitFrame_UpdateAuras(frame)
--         end
--     end
    
--     -- Update all party frames
--     for i = 1, 4 do
--         local frame = _G["CompactPartyFrame" .. i]
--         if frame then
--             CompactUnitFrame_UpdateAuras(frame)
--         end
--     end
-- end

-- -- Slash command to toggle raid auras
-- SLASH_RAIDAURAS1 = "/raidauras"
-- SlashCmdList["RAIDAURAS"] = function()
--     if not BentoPlusDB.raidAuras then
--         initializeDatabase()
--     end
    
--     BentoPlusDB.raidAuras.enabled = not BentoPlusDB.raidAuras.enabled
    
--     if BentoPlusDB.raidAuras.enabled then
--         print("|cff00ff00[Bento Plus]|r Raid auras: |cff00ff00Enabled|r")
--         updateAllRaidFrames()
--     else
--         print("|cff00ff00[Bento Plus]|r Raid auras: |cffff0000Disabled|r")
--         hideAllRaidAuras()
--     end
-- end

-- -- Event frame for initialization
-- local eventFrame = CreateFrame("Frame")
-- eventFrame:RegisterEvent("ADDON_LOADED")
-- eventFrame:RegisterEvent("PLAYER_LOGIN")

-- eventFrame:SetScript("OnEvent", function(self, event, addonName)
--     if event == "ADDON_LOADED" and addonName == "BentoPlus" then
--         initializeDatabase()
--     elseif event == "PLAYER_LOGIN" then
--         -- Initialize database again to ensure it's available
--         initializeDatabase()
        
--         -- Apply initial state
--         if BentoPlusDB.raidAuras and not BentoPlusDB.raidAuras.enabled then
--             C_Timer.After(2, hideAllRaidAuras)
--         end
--     end
-- end)

-- -- Initialize aura frame resizing
-- hooksecurefunc("CompactUnitFrame_UpdateAuras", resizeAuraFrames)