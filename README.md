# 🔧 BlackCrafting - Advanced Crafting & XP System

**BlackCrafting** is an advanced crafting system for QBCore-based FiveM servers.  
It features a fully integrated XP (experience) system that allows players to craft items based on their skill level.  
This system encourages player progression and immersion through a level-based crafting mechanism.

---

## ✨ Features

- 🛠️ Interactive Crafting Bench with `ox_target`
- 📈 XP & Level System – Gain XP and unlock new craftable items
- 🎯 Skill Check Minigame – Adds difficulty and engagement to crafting
- 🧰 Customizable Recipes – With required items, XP rewards, and level locks
- 💾 MySQL Integration – XP stored per player using `oxmysql`
- 🎮 Full support for QBCore Framework
- 📦 Inventory Check – Ensures players have the required materials
- ❌ Fail Conditions – Crafting fails if skill check is unsuccessful

- ![ima1ge](https://github.com/user-attachments/assets/18edd45d-886d-4da4-ad17-d85f8f550235)
- ![ima32ge](https://github.com/user-attachments/assets/8f53526b-ccd4-477d-a5c4-a5b79a7692e9)
- ![image](https://github.com/user-attachments/assets/f2102693-affc-4ea8-abcf-ba6ebb41bfad)


---

## 📦 Requirements

- [QBCore Framework](https://github.com/qbcore-framework)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [oxmysql](https://github.com/overextended/oxmysql)

---

## 📁 File Structure

```
Blackcrafting/
├── client/
│   └── main.lua         # Handles interaction, UI, skill check, crafting logic
├── server/
│   ├── main.lua         # XP saving/loading, item transactions
│   ├── xp.lua           # (Optional) XP-specific events
│   └── sql.sql          # SQL table schema
├── config.lua           # Bench position, crafting recipes, XP levels
├── fxmanifest.lua       # Resource manifest
└── LICENSE              # License file
```

---

## ⚙️ Config Example

```lua
Config.Levels = {
    {0, "Novice"},
    {100, "Apprentice"},
    {200, "Journeyman"},
    {300, "Expert"},
    {400, "Master"}
}

Config.CraftableItems = {
    ['lockpick'] = {
        menutitle = 'Lock Pick',
        requiredXP = 0,
        rewardXP = 10,
        image = 'https://items.bit-scripts.com/images/general/lockpick.png',
        recipe = {
            { itemname = 'metal', itemamont = 5 },
            { itemname = 'plastic', itemamont = 2 }
        }
    }
}
```

---

## 🗃️ SQL Table

```sql
CREATE TABLE IF NOT EXISTS playercraftxp (
    identifier VARCHAR(100) NOT NULL PRIMARY KEY,
    steam_name VARCHAR(100),
    character_name VARCHAR(100),
    xp INT DEFAULT 0
);
```

---

## 🎮 How It Works

1. Player interacts with a crafting bench (`ox_target`)
2. Menu shows XP level and available items
3. If requirements are met, player completes a skill check minigame
4. On success:
   - Required items are removed
   - New item is added to inventory
   - XP is rewarded and stored in database
   - Player levels up and unlocks more recipes

---

## 📜 License

MIT
