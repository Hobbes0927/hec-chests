local VORPCore = exports.vorp_core:GetCore()
local PromptGroup = GetRandomIntInRange(0, 0xffffff)


---@param code table
RegisterNetEvent('hec-chests:unlock')
AddEventHandler("hec-chests:unlock", function(item, combo1, combo2, combo3, combo4)
    local itemID = item
    local code = {code1=combo1, code2=combo2, code3=combo3, code4=combo4}
    local openLock = exports['SS-Padlock']:Padlock(code)

    if openLock then
        local cbresult =  VORPCore.Callback.TriggerAwait('hec-chests:callback:canCarry', itemID)
        if not cbresult then
            VORPCore.NotifyRightTip("You do not have enough room in your inventory", 4000)
        else
            if Config.DiscordIntegration then
                TriggerServerEvent("hec-chests:discord", itemID)
            end
            TriggerServerEvent("hec-chests:openChest", itemID)
        end
    else
        VORPCore.NotifyRightTip("You failed to open the lock", 4000)
    end

end)