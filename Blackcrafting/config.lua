Config = {}

-- 工作台位置
Config.bechnvec = vec4(-509.1, -698.97, 44.03 -1, 358.76)

-- 等级系统配置 (格式: {所需经验, 等级名称(可选)})
Config.Levels = {
    {0, "1"},      -- 等级0: 0-99 XP
    {100, "2"},-- 等级1: 100-199 XP
    {200, "3"},-- 等级2: 200-299 XP
    {300, "4"},    -- 等级3: 300-399 XP
    {400, "5"},    -- 等级4: 400+ XP
    {10000, "6"},    -- 等级4: 400+ XP
}

-- 可制作物品配置
Config.CraftableItems = {
    ['lockpick'] = {
        menutitle = 'Lock Pick',
        requiredXP = 0,
        rewardXP = 10,
        image = 'https://items.bit-scripts.com/images/general/lockpick.png',
        recipe = {
            { itemname = 'water', itemamont = 5 },
            { itemname = 'yarak', itemamont = 5 }
        }
    },
    ['weapon_pistol'] = {
        menutitle = 'Pistol',
        requiredXP = 100,
        rewardXP = 30,
        image = 'https://items.bit-scripts.com/images/weapons/weapon_pistol.png',
        recipe = {
            { itemname = 'burger', itemamont = 5 }
        }
    }
}