local mod = RegisterMod('Crafting Shenanigans', 1)
local game = Game()

if REPENTOGON then
  mod.craftingXmlMap = {
    [BagOfCraftingPickup.BOC_RED_HEART] = 'h',
    [BagOfCraftingPickup.BOC_SOUL_HEART] = 's',
    [BagOfCraftingPickup.BOC_BLACK_HEART] = 'b',
    [BagOfCraftingPickup.BOC_ETERNAL_HEART] = 'e',
    [BagOfCraftingPickup.BOC_GOLD_HEART] = 'g',
    [BagOfCraftingPickup.BOC_BONE_HEART] = 'B',
    [BagOfCraftingPickup.BOC_ROTTEN_HEART] = 'r',
    [BagOfCraftingPickup.BOC_PENNY] = '.',
    [BagOfCraftingPickup.BOC_NICKEL] = 'o',
    [BagOfCraftingPickup.BOC_DIME] = 'O',
    [BagOfCraftingPickup.BOC_LUCKY_PENNY] = 'Q',
    [BagOfCraftingPickup.BOC_KEY] = '/',
    [BagOfCraftingPickup.BOC_GOLD_KEY] = '|',
    [BagOfCraftingPickup.BOC_CHARGED_KEY] = '%',
    [BagOfCraftingPickup.BOC_BOMB] = 'v',
    [BagOfCraftingPickup.BOC_GOLD_BOMB] = '^',
    [BagOfCraftingPickup.BOC_GIGA_BOMB] = 'V',
    [BagOfCraftingPickup.BOC_MINI_BATTERY] = '1', -- micro battery 5.90.2
    [BagOfCraftingPickup.BOC_BATTERY] = '2', -- lil battery 5.90.1
    [BagOfCraftingPickup.BOC_MEGA_BATTERY] = '3', -- 5.90.3
    [BagOfCraftingPickup.BOC_CARD] = '[',
    [BagOfCraftingPickup.BOC_PILL] = '(',
    [BagOfCraftingPickup.BOC_RUNE] = '>',
    [BagOfCraftingPickup.BOC_DICE_SHARD] = '?',
    [BagOfCraftingPickup.BOC_CRACKED_KEY] = '~',
    [BagOfCraftingPickup.BOC_GOLD_PENNY] = '$',
    [BagOfCraftingPickup.BOC_GOLD_PILL] = '{',
    [BagOfCraftingPickup.BOC_GOLD_BATTERY] = '4', -- 5.90.4
    [BagOfCraftingPickup.BOC_POOP] = '_',
  }
  
  function mod:onModsLoaded()
    mod:setupImGui()
  end
  
  function mod:localize(category, key)
    local s = Isaac.GetString(category, key)
    return (s == nil or s == 'StringTable::InvalidCategory' or s == 'StringTable::InvalidKey') and key or s
  end
  
  function mod:getItemTypeName(i)
    local tbl = {
      [ItemType.ITEM_NULL] = 'Null',
      [ItemType.ITEM_PASSIVE] = 'Passive',
      [ItemType.ITEM_TRINKET] = 'Trinket',
      [ItemType.ITEM_ACTIVE] = 'Active',
      [ItemType.ITEM_FAMILIAR] = 'Familiar',
    }
    return tbl[i] or i
  end
  
  function mod:getItemPoolName(i)
    local tbl = {
      [ItemPoolType.POOL_NULL] = 'Null',
      [ItemPoolType.POOL_TREASURE] = 'Treasure',
      [ItemPoolType.POOL_SHOP] = 'Shop',
      [ItemPoolType.POOL_BOSS] = 'Boss',
      [ItemPoolType.POOL_DEVIL] = 'Devil',
      [ItemPoolType.POOL_ANGEL] = 'Angel',
      [ItemPoolType.POOL_SECRET] = 'Secret',
      [ItemPoolType.POOL_LIBRARY] = 'Library',
      [ItemPoolType.POOL_SHELL_GAME] = 'Shell Game',
      [ItemPoolType.POOL_GOLDEN_CHEST] = 'Golden Chest',
      [ItemPoolType.POOL_RED_CHEST] = 'Red Chest',
      [ItemPoolType.POOL_BEGGAR] = 'Beggar',
      [ItemPoolType.POOL_DEMON_BEGGAR] = 'Demon Beggar',
      [ItemPoolType.POOL_CURSE] = 'Curse',
      [ItemPoolType.POOL_KEY_MASTER] = 'Key Master',
      [ItemPoolType.POOL_BATTERY_BUM] = 'Battery Bum',
      [ItemPoolType.POOL_MOMS_CHEST] = 'Mom\'s Chest',
      [ItemPoolType.POOL_GREED_TREASURE] = 'Treasure',
      [ItemPoolType.POOL_GREED_BOSS] = 'Boss',
      [ItemPoolType.POOL_GREED_SHOP] = 'Shop',
      [ItemPoolType.POOL_GREED_DEVIL] = 'Devil',
      [ItemPoolType.POOL_GREED_ANGEL] = 'Angel',
      [ItemPoolType.POOL_GREED_CURSE] = 'Curse',
      [ItemPoolType.POOL_GREED_SECRET] = 'Secret',
      [ItemPoolType.POOL_CRANE_GAME] = 'Crane Game',
      [ItemPoolType.POOL_ULTRA_SECRET] = 'Ultra Secret',
      [ItemPoolType.POOL_BOMB_BUM] = 'Bomb Bum',
      [ItemPoolType.POOL_PLANETARIUM] = 'Planetarium',
      [ItemPoolType.POOL_OLD_CHEST] = 'Old Chest',
      [ItemPoolType.POOL_BABY_SHOP] = 'Baby Shop',
      [ItemPoolType.POOL_WOODEN_CHEST] = 'Wooden Chest',
      [ItemPoolType.POOL_ROTTEN_BEGGAR] = 'Rotten Beggar',
    }
    return tbl[i] or i
  end
  
  function mod:buildXmlStr(craftingPickups)
    local s = ''
    for _, v in ipairs(craftingPickups) do
      s = s .. mod.craftingXmlMap[v]
    end
    return s
  end
  
  function mod:doXmlMapReverseLookup(c)
    for k, v in pairs(mod.craftingXmlMap) do
      if c == v then
        return k
      end
    end
    return nil
  end
  
  function mod:calculateBagOfCraftingOutput(craftingPickups, txtOutputId)
    if Isaac.IsInGame() then
      local itemConfig = Isaac.GetItemConfig()
      local collectible, itemPool = EntityPlayer.CalculateBagOfCraftingOutput(craftingPickups)
      local collectibleConfig = itemConfig:GetCollectible(collectible)
      if collectibleConfig then
        ImGui.UpdateText(txtOutputId, mod:localize('Items', collectibleConfig.Name) .. ' (' .. collectibleConfig.ID .. ') | ' .. mod:getItemPoolName(itemPool) .. ' | ' .. mod:getItemTypeName(collectibleConfig.Type) .. ' | Quality: ' .. collectibleConfig.CraftingQuality) -- Quality
      else
        ImGui.UpdateText(txtOutputId, collectible .. ' | ' .. mod:getItemPoolName(itemPool))
      end
    else
      ImGui.UpdateText(txtOutputId, 'Refresh once you are in a run!')
    end
  end
  
  function mod:logBagOfCraftingOutput(craftingPickups)
    local itemConfig = Isaac.GetItemConfig()
    local collectible, itemPool = EntityPlayer.CalculateBagOfCraftingOutput(craftingPickups)
    local collectibleConfig = itemConfig:GetCollectible(collectible)
    if collectibleConfig then
      Isaac.DebugString(mod:buildXmlStr(craftingPickups) .. ' | ' .. mod:localize('Items', collectibleConfig.Name) .. ' (' .. collectibleConfig.ID .. ') | ' .. mod:getItemPoolName(itemPool) .. ' | ' .. mod:getItemTypeName(collectibleConfig.Type) .. ' | Quality: ' .. collectibleConfig.CraftingQuality)
    else
      Isaac.DebugString(mod:buildXmlStr(craftingPickups) .. ' | ' .. collectible .. ' | ' .. mod:getItemPoolName(itemPool))
    end
  end
  
  -- https://www.geeksforgeeks.org/dsa/combinations-with-repetitions/
  -- converted to lua
  function mod:doCombinationRepetition(arr, n, r, tblPrefix)
    local chosen = {}
    mod:doCombinationRepetitionUtil(chosen, arr, 1, r, 1, n, tblPrefix)
  end
  
  function mod:doCombinationRepetitionUtil(chosen, arr, index, r, start, last, tblPrefix)
    if index == r + 1 then
      local temp = {}
      for _, v in ipairs(tblPrefix) do
        table.insert(temp, v)
      end
      for i = 1, r do
        table.insert(temp, arr[chosen[i]])
      end
      mod:logBagOfCraftingOutput(temp)
      return
    end
    
    for i = start, last do
      chosen[index] = i
      mod:doCombinationRepetitionUtil(chosen, arr, index + 1, r, i, last, tblPrefix)
    end
  end
  
  function mod:setupImGuiMenu()
    if not ImGui.ElementExists('shenanigansMenu') then
      ImGui.CreateMenu('shenanigansMenu', '\u{f6d1} Shenanigans')
    end
  end
  
  function mod:setupImGui()
    ImGui.AddElement('shenanigansMenu', 'shenanigansMenuItemCrafting', ImGuiElement.MenuItem, '\u{f81d} Crafting Shenanigans')
    ImGui.CreateWindow('shenanigansWindowCrafting', 'Crafting Shenanigans')
    ImGui.LinkWindowToElement('shenanigansWindowCrafting', 'shenanigansMenuItemCrafting')
    
    local craftingOptions = {}                                   -- BagOfCraftingPickup
    table.insert(craftingOptions, 'Red Heart (1)')               -- 1 BOC_RED_HEART
    table.insert(craftingOptions, 'Soul Heart (4)')              -- 2 BOC_SOUL_HEART
    table.insert(craftingOptions, 'Black Heart (5|Devil)')       -- 3 BOC_BLACK_HEART
    table.insert(craftingOptions, 'Eternal Heart (5|Angel)')     -- 4 BOC_ETERNAL_HEART
    table.insert(craftingOptions, 'Gold Heart (5|Golden Chest)') -- 5 BOC_GOLD_HEART
    table.insert(craftingOptions, 'Bone Heart (5|Secret)')       -- 6 BOC_BONE_HEART
    table.insert(craftingOptions, 'Rotten Heart (1|Curse)')      -- 7 BOC_ROTTEN_HEART
    table.insert(craftingOptions, 'Penny (1)')                   -- 8 BOC_PENNY
    table.insert(craftingOptions, 'Nickel (3)')                  -- 9 BOC_NICKEL
    table.insert(craftingOptions, 'Dime (5)')                    -- 10 BOC_DIME
    table.insert(craftingOptions, 'Lucky Penny (8)')             -- 11 BOC_LUCKY_PENNY
    table.insert(craftingOptions, 'Key (2)')                     -- 12 BOC_KEY
    table.insert(craftingOptions, 'Golden Key (7)')              -- 13 BOC_GOLD_KEY
    table.insert(craftingOptions, 'Charged Key (5)')             -- 14 BOC_CHARGED_KEY
    table.insert(craftingOptions, 'Bomb (2)')                    -- 15 BOC_BOMB
    table.insert(craftingOptions, 'Golden Bomb (7)')             -- 16 BOC_GOLD_BOMB
    table.insert(craftingOptions, 'Giga Bomb (10)')              -- 17 BOC_GIGA_BOMB
    table.insert(craftingOptions, 'Micro Battery (2)')           -- 18 BOC_MINI_BATTERY
    table.insert(craftingOptions, 'Lil Battery (4)')             -- 19 BOC_BATTERY
    table.insert(craftingOptions, 'Mega Battery (8)')            -- 20 BOC_MEGA_BATTERY
    table.insert(craftingOptions, 'Card (2)')                    -- 21 BOC_CARD
    table.insert(craftingOptions, 'Pill (2)')                    -- 22 BOC_PILL
    table.insert(craftingOptions, 'Rune (4|Planetarium)')        -- 23 BOC_RUNE
    table.insert(craftingOptions, 'Dice Shard (4)')              -- 24 BOC_DICE_SHARD
    table.insert(craftingOptions, 'Cracked Key (2|Red Chest)')   -- 25 BOC_CRACKED_KEY
    table.insert(craftingOptions, 'Golden Penny (7)')            -- 26 BOC_GOLD_PENNY
    table.insert(craftingOptions, 'Golden Pill (7)')             -- 27 BOC_GOLD_PILL
    table.insert(craftingOptions, 'Golden Battery (7)')          -- 28 BOC_GOLD_BATTERY
    table.insert(craftingOptions, 'Poop Nugget (0|Shell Game)')  -- 29 BOC_POOP
    
    local craftingPickups = { 1, 1, 1, 1, 1, 1, 1, 1 }
    local txtInputId = 'shenanigansTxtCraftingInput'
    local txtOutputId = 'shenanigansTxtCraftingOutput'
    ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SeparatorText, 'Bag of Crafting')
    for i = 1, 8 do
      ImGui.AddCombobox('shenanigansWindowCrafting', 'shenanigansCmbCraftingPickup' .. i, '', function(j)
        craftingPickups[i] = j + 1
        ImGui.UpdateData(txtInputId, ImGuiData.Value, mod:buildXmlStr(craftingPickups))
        mod:calculateBagOfCraftingOutput(craftingPickups, txtOutputId)
      end, craftingOptions, 0, true)
    end
    
    ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SeparatorText, 'XML Formatting')
    ImGui.AddInputText('shenanigansWindowCrafting', txtInputId, '', nil, mod:buildXmlStr(craftingPickups), '')
    ImGui.AddCallback(txtInputId, ImGuiCallback.DeactivatedAfterEdit, function(s)
      s = string.match(s, '^%s*(.-)%s*$') -- http://lua-users.org/wiki/StringTrim
      
      local length = string.len(s)
      if length > 8 then
        s = string.sub(s, 1, 8)
      elseif length < 8 then
        s = string.gsub(string.format('%-8s', s), ' ', 'h') -- right pad with h's
      end
      
      for i = 1, string.len(s) do
        local c = string.sub(s, i, i)
        local bocPickup = mod:doXmlMapReverseLookup(c)
        if bocPickup then
          ImGui.UpdateData('shenanigansCmbCraftingPickup' .. i, ImGuiData.Value, bocPickup - 1)
          craftingPickups[i] = bocPickup
        else
          ImGui.UpdateData('shenanigansCmbCraftingPickup' .. i, ImGuiData.Value, 0)
          craftingPickups[i] = BagOfCraftingPickup.BOC_RED_HEART
        end
      end
      
      ImGui.UpdateData(txtInputId, ImGuiData.Value, mod:buildXmlStr(craftingPickups))
      mod:calculateBagOfCraftingOutput(craftingPickups, txtOutputId)
    end)
    local txtInputHelp = 'Formatting from recipes.xml\n'
    for i, v in ipairs(mod.craftingXmlMap) do
      txtInputHelp = txtInputHelp .. '\n' .. craftingOptions[i] .. ': ' .. v
    end
    ImGui.SetHelpmarker(txtInputId, txtInputHelp)
    
    ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SeparatorText, 'Players')
    for i = 1, 8 do
      local btnPlayerId = 'shenanigansBtnCraftingPlayer' .. i
      ImGui.AddButton('shenanigansWindowCrafting', btnPlayerId, i, function()
        if Isaac.IsInGame() then
          local player = game:GetPlayer(i - 1)
          for j = 1, 8 do
            local bocPickup = player:GetBagOfCraftingSlot(j - 1)
            if bocPickup == BagOfCraftingPickup.BOC_NONE then
              bocPickup = BagOfCraftingPickup.BOC_RED_HEART
            end
            ImGui.UpdateData('shenanigansCmbCraftingPickup' .. j, ImGuiData.Value, bocPickup - 1)
            craftingPickups[j] = bocPickup
          end
          ImGui.UpdateData(txtInputId, ImGuiData.Value, mod:buildXmlStr(craftingPickups))
          mod:calculateBagOfCraftingOutput(craftingPickups, txtOutputId)
        end
      end, false)
      if i < 8 then
        ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SameLine, '')
      else
        ImGui.SetHelpmarker(btnPlayerId, 'Copy the player\'s bag of crafting')
      end
    end
    
    ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SeparatorText, 'Output')
    ImGui.AddText('shenanigansWindowCrafting', 'Refresh once you are in a run!', true, txtOutputId)
    
    ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SeparatorText, 'Log')
    for i = 1, 6 do
      local btnLogId = 'shenanigansBtnCraftingLog' .. i
      local btnLogLbl = i == 1 and 'Last ' .. i or i
      ImGui.AddButton('shenanigansWindowCrafting', btnLogId, btnLogLbl, function()
        if Isaac.IsInGame() then
          local seeds = game:GetSeeds()
          local arr = {}
          for j in ipairs(craftingOptions) do -- 1-29
            table.insert(arr, j)
          end
          local n = #arr
          local r = i
          local tblPrefix = { table.unpack(craftingPickups, 1, 8 - i) }
          Isaac.DebugString('Last ' .. i .. ' | Seed: ' .. seeds:GetStartSeedString())
          mod:doCombinationRepetition(arr, n, r, tblPrefix)
          ImGui.PushNotification('Recipes logged to file', ImGuiNotificationType.SUCCESS, 5000)
        else
          ImGui.PushNotification('Start a run to log recipes!', ImGuiNotificationType.ERROR, 5000)
        end
      end, false)
      if i < 6 then
        ImGui.AddElement('shenanigansWindowCrafting', '', ImGuiElement.SameLine, '')
      else
        local btnLogHelp = 'There\'s more than 30 million recipes in total. Generating all of them has terrible performance. This will let you set static choices in the first few slots and log all the options for the last x.\n'
        btnLogHelp = btnLogHelp .. '\nLast 1 = 29 recipes'
        btnLogHelp = btnLogHelp .. '\nLast 2 = 435 recipes'
        btnLogHelp = btnLogHelp .. '\nLast 3 = 4,495 recipes'
        btnLogHelp = btnLogHelp .. '\nLast 4 = 35,960 recipes'
        btnLogHelp = btnLogHelp .. '\nLast 5 = 237,336 recipes (can freeze ~10s)'
        btnLogHelp = btnLogHelp .. '\nLast 6 = 1,344,904 recipes (can freeze ~1m)'
        ImGui.SetHelpmarker(btnLogId, btnLogHelp)
      end
    end
  end
  
  mod:setupImGuiMenu()
  mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.onModsLoaded)
end