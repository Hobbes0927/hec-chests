local VORPCore = exports.vorp_core:GetCore()

--Discord Notice
RegisterServerEvent('hec-chests:discord')
AddEventHandler("hec-chests:discord", function(item)
    local _source = source
    local itemID = item
    local User = VORPCore.getUser(_source)
    local Character = User.getUsedCharacter
    local botname = Config.DiscordBotName
    local avatar = Config.DiscordAvatar
    local webhook = Config.DiscordWebHook
    local CharName
    if Character ~= nil then
        if Character.lastname ~= nil then
            CharName = Character.firstname .. ' ' .. Character.lastname
        else
            CharName = Character.firstname
        end
    end

    local dbRecord = exports.vorp_inventory:getItemByName(_source, itemID)

    local itemName = 'Unknown'
    if dbRecord ~= nil then
        itemName = dbRecord.label
    end

    local embeds = {
        {
            ["title"] = CharName,
            ["description"] = "The player opened " .. itemName,
            ["type"]="rich",
            ["color"] = 11027200,
            ["footer"] =  {
                ["text"] = "HEC Chests",
                ["icon_url"] = avatar,
            }
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = botname,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end)


--Give the player their rewards after opening the chest
RegisterServerEvent('hec-chests:openChest')
AddEventHandler("hec-chests:openChest", function(item)
    local _source = source
    local _item = item
    local rewards = ""
    for k, v in pairs(Config.Chests) do
        if v.item == _item then
            if not v.itemRewards == false then
                for l,c in pairs(v.itemRewards) do
                    exports.vorp_inventory:addItem(_source, c.itemName, c.amount)
                    if rewards == "" then
                        rewards = "You have received " .. c.amount .. " " .. c.itemName
                    else
                        rewards = rewards .. ", " .. c.amount .. " " .. c.itemName
                    end
                end
            end
            
            if not v.cashReward == false then
                local Character = VORPCore.getUser(_source).getUsedCharacter
                Character.addCurrency(0,v.cashReward)
                if rewards == "" then
                    rewards = "You have received $" .. v.cashReward
                else
                    rewards = rewards .. ", $" .. v.cashReward
                end
            end

            exports.vorp_inventory:subItem(_source, v.item, 1)
            break
        end
    end
    VORPCore.NotifyRightTip(_source, rewards ,4000)
end)

--Check to ensure player can receive all rewards
VORPCore.Callback.Register('hec-chests:callback:canCarry', function(source, cb, item)
    local _source = source
    local _item = item
	local canCarry = true

	for k, v in pairs(Config.Chests) do
        if v.item == item then
            for l,c in pairs(v.itemRewards) do
                local itemCheck = exports.vorp_inventory:canCarryItem(_source, c.itemName, c.amount)
                if not itemCheck then
                    canCarry = false
                    break
                end
            end
            break
        end
    end
    cb(canCarry)	
end)

--Register all chests as usable items to unlock
CreateThread(function()
    for k, v in pairs(Config.Chests) do
        exports.vorp_inventory:registerUsableItem(v.item, function(data)
            local _source = data.source
            exports.vorp_inventory:closeInventory(_source)           
            TriggerClientEvent('hec-chests:unlock', _source, v.item, v.combo1, v.combo2, v.combo3, v.combo4)
        end)
    end
end)