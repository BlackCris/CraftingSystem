local QBCore = exports['qb-core']:GetCoreObject()

-- 🧠 Retrieve XP for the player
RegisterServerEvent('craftingxp:getXP', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0) or "no_identifier"
    local steamName = GetPlayerName(src) or "Unknown Steam"
    local characterName = "Unknown RP"

    -- ✅ Get RP character name (ensure not empty)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.charinfo then
        characterName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    end

    -- ✅ Check if XP record already exists
    exports.oxmysql:execute('SELECT xp FROM playercraftxp WHERE identifier = ?', {identifier}, function(result)
        if result and result[1] then
            -- ✅ Record exists, send XP to client
            TriggerClientEvent('craftingxp:setXP', src, result[1].xp)
        else
            -- ✅ Record does not exist, create new entry
            exports.oxmysql:insert([[
                INSERT INTO playercraftxp (identifier, steam_name, character_name, xp)
                VALUES (?, ?, ?, ?)
            ]], {identifier, steamName, characterName, 0})

            TriggerClientEvent('craftingxp:setXP', src, 0)
        end
    end)
end)

-- ➕ Add XP to player
RegisterServerEvent('craftingxp:addXP', function(amount)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return end

    exports.oxmysql:update('UPDATE playercraftxp SET xp = xp + ? WHERE identifier = ?', {amount, identifier})
end)

-- 🎁 Give item to player
RegisterServerEvent('blackcrafting:Giveitem', function(itemname, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(itemname, amount, false)
    end
end)

-- ❌ Remove item from player
RegisterServerEvent('blackcrafting:Takeitem', function(itemname, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem(itemname, amount, false)
    end
end)
