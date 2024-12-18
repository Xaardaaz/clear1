UI.Label("Zawsze odpalone:")

-- Auto open channels (Czat, Handel, Loot, Taski)
local channelList = {9, 6, 13, 14}
for _, channel in pairs(channelList) do
    g_game.joinChannel(channel)
end

-- Auto Auto Bless
local bless = false
macro(1000, "Auto Bless", function()
    if bless ~= true then
        bless = true
        say("!bless")
    end
end)

-- Auto-Tasking
local autoTasking = addSwitch("autoTasking", "Auto-Tasking", function(widget)
  widget:setOn(not widget:isOn())
  storage.autoTasking = widget:isOn()
end)
autoTasking:setOn(storage.autoTasking)

onTextMessage(function(mode, text)
  if autoTasking:isOn() and string.find(text, 'task. Wpisz') then
    local creature = string.match(text, "!tasklevel%s+([%a%s']+)")
    if creature then say('!tasklevel ' .. creature) end
  end
end)

-- Repair Cyleria/Soft boots
macro(10000, "Repair Cyleria/Soft boots", function()
  if getFeet() == nil then return end
  if getFeet():getId() == 6530 then
    say("!soft")
  elseif getFeet():getId() == 9020 then
    say("!cyleria boots")
  end   
end)

-- Auto utamo vita
macro(7*1000, "Auto utamo vita", function()
  say("utamo vita")
end)

if not hasManaShield() then 
say("utamo vita")
end

macro(1000, "Stop CaveBot (20% MP)", function()
  local mpPercent = manapercent()
  if mpPercent < 20 then
      CaveBot.setOn(false)
  elseif mpPercent > 60 then
      CaveBot.setOn(true)
  end
end)

UI.Separator()

UI.Label("Skrypty EXP:")

-- AUTO STAMINA 40H
macro(10*1000, "Auto stamina (40h)", function()
  local minimalStamina = 60*40
  local item1 = 11719
  local item2 = 3209
  stamina = g_game.getLocalPlayer():getStamina()

  if stamina < minimalStamina then
    local foundItem1 = findItem(item1)
    local foundItem2 = findItem(item2)

    if foundItem1 then
      use(item1)
    elseif foundItem2 then
      use(item2)
    end
  end
end)

-- AUTO STAMINA 14H
macro(10*1000, "Auto stamina (14h)", function()
  local minimalStamina = 60*14
  local item1 = 11719
  local item2 = 3209
  stamina = g_game.getLocalPlayer():getStamina()

  if stamina < minimalStamina then
    local foundItem1 = findItem(item1)
    local foundItem2 = findItem(item2)

    if foundItem1 then
      use(item1)
    elseif foundItem2 then
      use(item2)
    end
  end
end)

-- AUTO EXP POTION
macro(1000, "Auto Exp Potion", function()
    local item1 = 11720
    local item2 = 7440
    local Mp = 95
    if not isInPz() then
        if manapercent() < Mp then
            delay(20000)
            local foundItem1 = findItem(item1)
            local foundItem2 = findItem(item2)

            if foundItem1 then
                return use(item1)
            elseif foundItem2 then
                return use(item2)
            end
        end
    end
end)

-- AUTO LORD EXP
macro(1000, "Auto Lord Exp", function()
    local item1 = 11721
    local item2 = 3594
    local Mp = 95
    if not isInPz() then
        if manapercent() < Mp then
            delay(20000)
            local foundItem1 = findItem(item1)
            local foundItem2 = findItem(item2)

            if foundItem1 then
                return use(item1)
            elseif foundItem2 then
                return use(item2)
            end
        end
    end
end)

-- Auto !staminafull
macro(6000, "Auto !staminafull", function() say("!staminafull") end)


UI.Separator()

UI.Label("Inne:")

-- Mikstura many
macro(1000, "Mikstura many (60% MP)", function()
    if not isInPz() and manapercent() < 60 and not hasPartyBuff() then
        for _, container in pairs(g_game.getContainers()) do
            for __, item in ipairs(container:getItems()) do
                if item:getId() == 11372 then
                    return g_game.use(item)
                end
            end
        end
    end
end)

-- SPAM SPELL
macro(300, "Spam spell",  function()      say(storage.spamue)    end) addTextEdit("Spam Ue", storage.spamue or "ice shark", function (widget, text) storage.spamue = text end)

-- Auto follow
UI.Label('Podazanie za graczem:')
storage.followLeader = storage.followLeader or "Gav"
addTextEdit("playerToFollow", storage.followLeader, function(widget, text)
  storage.followLeader = text
end)
FollowMacro = macro(1231321321, "Auto follow", function() end)

-- Auto select channel
UI.Label('Zaznaczanie kanalu:')
UI.TextEdit(storage.selectChannel or "1", function(widget, text)
  storage.selectChannel = text
end)
macro(750, "Select Channel", function()
  local channels = g_ui.getRootWidget():recursiveGetChildById("channels")
  local widget = channels:getParent()
  local submit = widget:recursiveGetChildById("submitButton")
  if #channels:getChildren() > 0 then
    channels:focusChild(channels:getChildByIndex(storage.selectChannel))
    submit:onClick()
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if FollowMacro:isOff() then return end

  if newPos and oldPos and creature:getName() == player:getName() and getCreatureByName(storage.followLeader) == nil and newPos.z > oldPos.z then
    say('exani tera')
    for i = -1, 1 do
      for j = -1, 1 do
        local useTile = g_map.getTile({ x = posx() + i, y = posy() + j, z = posz() })
        g_game.use(useTile:getTopUseThing())
      end
    end
  end
  if creature:getName() == storage.followLeader then
    if not newPos then
      if oldPos then
        lastPos = oldPos

        schedule(200, function()
          autoWalk(oldPos)
        end)
      end

      schedule(1000, function()
        for i = -1, 1 do
          for j = -1, 1 do
            local useTile = g_map.getTile({ x = posx() + i, y = posy() + j, z = posz() })
            if useTile then
              local top useTile:getTopUseThing()
              if top then
                g_game.use(top)
              end
            end
          end
        end
      end)
    end

    if not newPos or not oldPos then return end
    if oldPos.z == newPos.z then
      schedule(300, function()
        local useTile = g_map.getTile({ x = oldPos.x, y = oldPos.y, z = oldPos.z })
        topThing = useTile:getTopThing()

        if not useTile:isWalkable() then
          use(topThing)
        end
      end)


      autoWalk({ x = oldPos.x, y = oldPos.y, z = oldPos.z })
    else
      lastPos = oldPos
      autoWalk(oldPos)
      for i = 1, 6 do
        schedule(i * 200, function()
          autoWalk(oldPos)

          if getDistanceBetween(pos(), oldPos) == 0 and (posz() > newPos.z and getCreatureByName(storage.followLeader) == nil) then
            say('exani tera')
          end
        end)
      end
      local useTile = g_map.getTile({ x = newPos.x, y = newPos.y - 1, z = oldPos.z })
      g_game.use(useTile:getTopUseThing())
    end
  end
end)
