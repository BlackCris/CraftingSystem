local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('craftingxp:getXP')
AddEventHandler('craftingxp:getXP', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    exports.oxmysql:execute('SELECT xp FROM playercraftxp WHERE identifier = ?', {identifier}, function(result)
        if result[1] then
            TriggerClientEvent('craftingxp:setXP', src, result[1].xp)
        else
            exports.oxmysql:insert('INSERT INTO playercraftxp (identifier, xp) VALUES (?, ?)', {identifier, 0})
            TriggerClientEvent('craftingxp:setXP', src, 0)
        end
    end)
end)

RegisterServerEvent('craftingxp:addXP')
AddEventHandler('craftingxp:addXP', function(amount)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    exports.oxmysql:update('UPDATE playercraftxp SET xp = xp + ? WHERE identifier = ?', {amount, identifier})
end)
