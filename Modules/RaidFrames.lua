local function resizeAuraFrames(frame)
    if not frame then return end
    
    -- Resize buff frames to 16x16
    for i = 1, frame.maxBuffs or 0 do
        local buffFrame = frame.buffFrames and frame.buffFrames[i]
        if buffFrame then
            buffFrame:SetSize(24, 24)
            
            local icon = buffFrame.icon
            if icon then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end
    end
    
    -- Resize debuff frames to 16x16
    for i = 1, frame.maxDebuffs or 0 do
        local debuffFrame = frame.debuffFrames and frame.debuffFrames[i]
        if debuffFrame then
            debuffFrame:SetSize(24, 24)
            
            local icon = debuffFrame.icon
            if icon then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end
    end
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", resizeAuraFrames)