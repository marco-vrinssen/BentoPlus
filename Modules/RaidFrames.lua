-- local function resizeAuraFrames(frame)
--     if not frame then return end
    
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

-- -- Initialize aura frame resizing

-- hooksecurefunc("CompactUnitFrame_UpdateAuras", resizeAuraFrames)