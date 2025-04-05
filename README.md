🔧 BlackCrafting - Advanced Crafting & XP System
BlackCrafting is an advanced crafting system for QBCore-based FiveM servers. It features a fully integrated XP (experience) system that allows players to craft items based on their skill level. This system encourages player progression and immersion through a level-based crafting mechanism.

🚀 Features
🛠️ Interactive Crafting Bench with target interaction (ox_target)

📈 XP & Level System – Gain XP and unlock new craftable items

🧠 Skill Check Minigame – Adds difficulty and engagement to crafting

🧰 Customizable Recipes with required items, XP rewards, and level locks

🧾 MySQL Integration – XP is stored per player using oxmysql

🎮 QBCore Support – Fully compatible with the QBCore framework

📦 Inventory Check – Ensures players have required materials

📉 Fail Conditions – Crafting fails if skill check is unsuccessful

🧪 Requirements
QBCore Framework

ox_lib

ox_target

ox_inventory

oxmysql

📂 File Structure
client/main.lua: Handles target interaction, UI menu, skill check, and crafting logic.

server/main.lua: Manages XP saving/loading and item transactions.

server/xp.lua: (Optional duplicate logic) for XP-specific events.

config.lua: Customize levels, item recipes, and bench location.

fxmanifest.lua: Resource declaration.

server/sql.sql: Contains SQL table creation (not shown above).

🧬 Config Example (config.lua)
lua
复制
编辑
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
        recipe = {
            { itemname = 'metal', itemamont = 5 },
            { itemname = 'plastic', itemamont = 2 }
        }
    }
}
🧱 SQL Table Example
sql
复制
编辑
CREATE TABLE IF NOT EXISTS playercraftxp (
  identifier VARCHAR(100) NOT NULL PRIMARY KEY,
  steam_name VARCHAR(100),
  character_name VARCHAR(100),
  xp INT DEFAULT 0
);
🧠 How It Works
Player interacts with a crafting bench.

A menu displays their XP level and available items.

If they have enough materials and XP, they must pass a skill-check minigame.

On success: materials are removed, XP is added, and the item is granted.

XP is saved server-side using oxmysql.

