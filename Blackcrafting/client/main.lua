-- 客户端脚本 client.lua

-- 初始化变量
local benchObj = nil
local benchHash = `gr_prop_gr_bench_02a`
local currentXP = 0

-- 确保配置存在
if not Config then Config = {} end
if not Config.Levels then
    Config.Levels = {
        {0, "Novice"},      -- 等级0: 0-99 XP
        {100, "Apprentice"},-- 等级1: 100-199 XP
        {200, "Journeyman"},-- 等级2: 200-299 XP
        {300, "Expert"},    -- 等级3: 300-399 XP
        {400, "Master"}     -- 等级4: 400+ XP
    }
end

-- ======================
-- 核心功能函数
-- ======================

-- 获取详细的等级信息
local function getLevelInfo(xp)
    local currentLevel = 0
    local nextLevelXP = Config.Levels[1][1] or 100
    local levelName = "Novice"
    
    -- 从最高级开始检查当前等级
    for i = #Config.Levels, 1, -1 do
        if xp >= Config.Levels[i][1] then
            currentLevel = i - 1
            levelName = Config.Levels[i][2] or ("Level "..(i-1))
            
            -- 计算下一级所需经验
            if Config.Levels[i+1] then
                nextLevelXP = Config.Levels[i+1][1]
            else
                nextLevelXP = Config.Levels[i][1] + 100 -- 默认增加100
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


-- 更新本地经验值
RegisterNetEvent('craftingxp:setXP', function(xp)
    currentXP = xp or 0
end)

-- 创建工作台
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
        
        -- 添加交互选项
        exports.ox_target:addLocalEntity(benchObj, {
            distance = 1.5,
            name = 'bench_open',
            icon = 'fa-solid fa-screwdriver-wrench',
            label = 'Open Bench',
            onSelect = function()
                TriggerServerEvent('craftingxp:getXP')
                Wait(100) -- 确保经验值加载
                TriggerEvent('blackcrafting:client:OpenMenu')
            end
        })
    end
end)

-- 打开制作菜单
RegisterNetEvent('blackcrafting:client:OpenMenu', function()
    local levelInfo = getLevelInfo(currentXP)
    local options = {}
    
    -- 1. 添加等级信息头
    table.insert(options, {
        title = string.format('%s Level', levelInfo.name, levelInfo.level),
        description = string.format('XP: %d/%d | Next level in: %d XP', 
            levelInfo.currentXP, levelInfo.nextLevelXP, levelInfo.xpToNext),
        icon = 'fa-solid fa-medal',
        disabled = true
    })

    -- 3. 添加可制作物品
    for itemId, itemData in pairs(Config.CraftableItems) do
        if currentXP >= itemData.requiredXP then
            -- 生成材料文本
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

    -- 显示菜单
    lib.registerContext({
        id = 'generalcrafting',
        title = 'Crafting Station',
        options = options
    })
    lib.showContext('generalcrafting')
end)

-- 物品制作逻辑
RegisterNetEvent('blackcrafting:craftItem', function(data)
    local recipe = Config.CraftableItems[data.item]
    if not recipe then return end

    -- 检查材料是否足够
    local hasAllMaterials = true
    for _, material in ipairs(recipe.recipe) do
        if exports.ox_inventory:GetItemCount(material.itemname) < material.itemamont then
            hasAllMaterials = false
            break
        end
    end

    if not hasAllMaterials then
        return lib.notify({
            title = 'Materials Missing',
            description = 'You dont have enough materials!',
            type = 'error',
            position = 'center-right'
        })
    end

    -- 开始制作
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)

    -- 技能检查小游戏
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

    -- 制作进度条
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
        -- 扣除材料
        for _, material in ipairs(recipe.recipe) do
            TriggerServerEvent('blackcrafting:Takeitem', material.itemname, material.itemamont)
        end
        
        -- 给予成品和经验
        TriggerServerEvent('blackcrafting:Giveitem', data.item, 1)
        TriggerServerEvent('craftingxp:addXP', recipe.rewardXP or 10)
        
        lib.notify({
            title = 'Success',
            description = 'Crafted: '..recipe.menutitle,
            type = 'success',
            position = 'center-right'
        })
    end

    ClearPedTasks(ped)
end)

-- 资源停止时清理
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    if DoesEntityExist(benchObj) then
        DeleteEntity(benchObj)
    end
end)