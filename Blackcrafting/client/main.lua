-- client.lua

-- Initialize variables
local benchObj = nil
local benchHash = `gr_prop_gr_bench_02a`
local currentXP = 0

-- Ensure config exists
if not Config then Config = {} end
if not Config.Levels then
    Config.Levels = {
        {0, "Novice"},       -- Level 0: 0-99 XP
        {100, "Apprentice"}, -- Level 1: 100-199 XP
        {200, "Journeyman"}, -- Level 2: 200-299 XP
        {300, "Expert"},     -- Level 3: 300-399 XP
        {400, "Master"}      -- Level 4: 400+ XP
    }
end

-- ======================
-- Core Functions
-- ======================

-- Get detailed level info based on XP
local function getLevelInfo(xp)
    local currentLevel = 0
    local nextLevelXP = Config.Levels[1][1] or 100
    local levelName = "Novice"

    -- Check from highest level down
    for i = #Config.Levels, 1, -1 do
        if xp >= Config.Levels[i][1] then
            currentLevel = i - 1
            levelName = Config.Levels[i][2] or ("Level "..(i-1))

            -- Calculate XP needed for next level
            if Config.Levels[i+1] then
                nextLevelXP = Config.Levels[i+1][1]
            else
                nextLevelXP = Config.Levels[i][1] + 100
            end
            break
        end
    end

    return {
        level = currentLevel,
        name = levelName,
        currentXP = xp,
        nextLevelXP = nextLevelXP,
        xpToNext = nextLevelXP - xp
    }
end

-- Update local XP
RegisterNetEvent('craftingxp:setXP', function(xp)
    currentXP = xp or 0
end)

-- Create crafting bench
Citizen.CreateThread(function()
    RequestModel(benchHash)
    while not HasModelLoaded(benchHash) do Wait(0) end

    benchObj = CreateObject(
        benchHash,
        Config.bechnvec.x,
        Config.bechnvec.y,
        Config.bechnvec.z,
        false, false, false
    )
    SetModelAsNoLongerNeeded(benchHash)

    if benchObj then
        SetEntityAsMissionEntity(benchObj, true, true)

        -- Add interaction option
        exports.ox_target:addLocalEntity(benchObj, {
            distance = 1.5,
            name = 'bench_open',
            icon = 'fa-solid fa-screwdriver-wrench',
            label = 'Open Bench',
            onSelect = function()
                TriggerServerEvent('craftingxp:getXP')
                Wait(100) -- Ensure XP is loaded
                TriggerEvent('blackcrafting:client:OpenMenu')
            end
        })
    end
end)

-- Open crafting menu
RegisterNetEvent('blackcrafting:client:OpenMenu', function()
    local levelInfo = getLevelInfo(currentXP)
    local options = {}

    -- 1. Add level info header
    table.insert(options, {
        title = string.format('%s Level', levelInfo.name, levelInfo.level),
        description = string.format('XP: %d/%d | XP to next level: %d',
            levelInfo.currentXP, levelInfo.nextLevelXP, levelInfo.xpToNext),
        icon = 'fa-solid fa-medal',
        disabled = true
    })

    -- 2. Add craftable items
    for itemId, itemData in pairs(Config.CraftableItems) do
        if currentXP >= itemData.requiredXP then
            -- Generate materials text
            local materials = {}
            for _, mat in ipairs(itemData.recipe) do
                materials[#materials + 1] = mat.itemname .. " x" .. mat.itemamont
            end

            table.insert(options, {
                title = itemData.menutitle,
                description = string.format(
                    'Requires: Level %d (%d XP) | Reward: %d XP | Materials: %s',
                    getLevelInfo(itemData.requiredXP).level,
                    itemData.requiredXP,
                    itemData.rewardXP,
                    table.concat(materials, ", ")
                ),
                icon = 'fa-solid fa-toolbox',
                image = itemData.image or '',
                event = 'blackcrafting:craftItem',
                args = { item = itemId }
            })
        end
    end

    -- Show menu
    lib.registerContext({
        id = 'generalcrafting',
        title = 'Crafting Station',
        options = options
    })
    lib.showContext('generalcrafting')
end)

-- Crafting logic
RegisterNetEvent('blackcrafting:craftItem', function(data)
    local recipe = Config.CraftableItems[data.item]
    if not recipe then return end

    -- Check for required materials
    local hasAllMaterials = true
    for _, material in ipairs(recipe.recipe) do
        if exports.ox_inventory:GetItemCount(material.itemname) < material.itemamont then
            hasAllMaterials = false
            break
        end
    end

    if not hasAllMaterials then
        return lib.notify({
            title = 'Missing Materials',
            description = 'You do not have enough materials!',
            type = 'error',
            position = 'center-right'
        })
    end

    -- Start crafting animation
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)

    -- Skill check minigame
    local success = lib.skillCheck(
        {'easy', 'easy', {areaSize = 100, speedMultiplier = 1}, 'hard'},
        {'w', 'a', 's', 'd'}
    )

    if not success then
        ClearPedTasks(ped)
        return lib.notify({
            title = 'Crafting Failed',
            description = 'You failed the crafting minigame!',
            type = 'error',
            position = 'center-right'
        })
    end

    -- Progress bar
    local completed = lib.progressBar({
        duration = 5000,
        label = "Crafting "..recipe.menutitle.."...",
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, combat = true, car = true },
    })

    ClearPedTasks(ped)

    if completed then
        -- Remove materials
        for _, material in ipairs(recipe.recipe) do
            TriggerServerEvent('blackcrafting:Takeitem', material.itemname, material.itemamont)
        end

        -- Give item and XP
        TriggerServerEvent('blackcrafting:Giveitem', data.item, 1)
        TriggerServerEvent('craftingxp:addXP', recipe.rewardXP or 10)

        lib.notify({
            title = 'Crafted Successfully',
            description = 'You crafted: '..recipe.menutitle,
            type = 'success',
            position = 'center-right'
        })
    end

    ClearPedTasks(ped)
end)

-- Cleanup when resource stops
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    if DoesEntityExist(benchObj) then
        DeleteEntity(benchObj)
    end
end)
