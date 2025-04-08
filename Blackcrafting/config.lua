Config = {}

-- Bench location (vec4: x, y, z, heading)
Config.bechnvec = vec4(-509.1, -698.97, 44.03 -1, 358.76)

-- Level system configuration (Format: {Required XP, Optional Level Name})
Config.Levels = {
    {0, "1"},       -- Level 0: 0-99 XP
    {100, "2"},     -- Level 1: 100-199 XP
    {200, "3"},     -- Level 2: 200-299 XP
    {300, "4"},     -- Level 3: 300-399 XP
    {400, "5"},     -- Level 4: 400-9999 XP
    {10000, "6"},    -- Level 5: 10000+ XP
    {1000, "7"}    -- Level 5: 10000+ XP
}

-- Craftable item configuration
Config.CraftableItems = {
    ['lockpick'] = {
        menutitle = 'Lock Pick',
        requiredXP = 0,
        rewardXP = 10,
        image = 'https://items.bit-scripts.com/images/general/lockpick.png',
        recipe = {
            { itemname = 'water', itemamont = 5 }
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
    },
    ['water'] = {
        menutitle = 'water',
        requiredXP = 200,
        rewardXP = 40,
        image = 'https://items.bit-scripts.com/images/drinks/watercup.png',
        recipe = {
            { itemname = 'water', itemamont = 3 }
        }
    }
}
