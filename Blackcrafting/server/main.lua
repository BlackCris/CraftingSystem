local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('craftingxp:getXP', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0) or "no_identifier"
    local steamName = GetPlayerName(src) or "Unknown Steam"
    local characterName = "Unknown RP"

    -- ✅ 获取 RP 名（确保非空）
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.charinfo then
        characterName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    end

    -- ✅ 检查是否已存在记录
    exports.oxmysql:execute('SELECT xp FROM playercraftxp WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] then
            -- ✅ 已存在，返回经验给客户端
            TriggerClientEvent('craftingxp:setXP', src, result[1].xp)
        else
            -- ✅ 不存在，创建新记录
            exports.oxmysql:insert([[
                INSERT INTO playercraftxp (identifier, steam_name, character_name, xp)
                VALUES (?, ?, ?, ?)
            ]], {identifier, steamName, characterName, 0})

            TriggerClientEvent('craftingxp:setXP', src, 0)
        end
    end)
end)

RegisterServerEvent('craftingxp:addXP', function(amount)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return end

    exports.oxmysql:update('UPDATE playercraftxp SET xp = xp + ? WHERE identifier = ?', {amount, identifier})
end)

-- ✅ 物品给予
RegisterServerEvent('blackcrafting:Giveitem', function(itemname, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(itemname, amount, false)
    end
end)

-- ✅ 物品扣除
RegisterServerEvent('blackcrafting:Takeitem', function(itemname, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem(itemname, amount, false)
    end
end)
