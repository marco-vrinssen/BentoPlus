-- Automatically mark party members with raid markers when typing /pm

local partyMarkerRaidMarkers = {8, 4, 1, 6, 2}

-- Assign raid markers to all party members including player

local function assignPartyMarkers()
  local partyMemberUnits = {"player"}
  
  for memberIndex = 1, GetNumGroupMembers() - 1 do
    table.insert(partyMemberUnits, "party" .. memberIndex)
  end
  
  for unitIndex, unitIdentifier in ipairs(partyMemberUnits) do
    if unitIndex <= #partyMarkerRaidMarkers then
      SetRaidTarget(unitIdentifier, partyMarkerRaidMarkers[unitIndex])
    end
  end
end

-- Request party leadership from current leader

local function requestPartyLeadership()
  local currentLeaderUnit = UnitIsGroupLeader("player") and "player" or nil
  
  if not currentLeaderUnit then
    for memberIndex = 1, GetNumGroupMembers() - 1 do
      local checkUnit = "party" .. memberIndex
      if UnitIsGroupLeader(checkUnit) then
        currentLeaderUnit = checkUnit
        break
      end
    end
  end
  
  if currentLeaderUnit and currentLeaderUnit ~= "player" then
    local leaderName = UnitName(currentLeaderUnit)
    SendChatMessage("Can you give me party lead to mark everyone? Type: /script PromoteToLeader('" .. UnitName("player") .. "')", "WHISPER", nil, leaderName)
  end
end

-- Handle party marker slash command

local function handlePartyMarkerCommand()
  if not IsInGroup() then
    return
  end
  
  if UnitIsGroupLeader("player") then
    assignPartyMarkers()
  else
    requestPartyLeadership()
  end
end

SLASH_PARTYMARKER1 = "/pm"
SlashCmdList["PARTYMARKER"] = handlePartyMarkerCommand