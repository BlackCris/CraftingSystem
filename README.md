project:
  name: BlackCrafting
  description: >
    BlackCrafting is an advanced crafting system for QBCore-based FiveM servers.
    It features a fully integrated XP (experience) system that allows players to craft items based on their skill level.
    This system encourages player progression and immersion through a level-based crafting mechanism.

features:
  - "🛠️ Interactive Crafting Bench with ox_target"
  - "📈 XP & Level System – Gain XP and unlock new craftable items"
  - "🎯 Skill Check Minigame – Adds difficulty and engagement to crafting"
  - "🧰 Customizable Recipes – With required items, XP rewards, and level locks"
  - "💾 MySQL Integration – XP stored per player using oxmysql"
  - "🎮 Full support for QBCore Framework"
  - "📦 Inventory Check – Ensures players have the required materials"
  - "❌ Fail Conditions – Crafting fails if skill check is unsuccessful"

requirements:
  - QBCore Framework: https://github.com/qbcore-framework
  - ox_lib: https://github.com/overextended/ox_lib
  - ox_target: https://github.com/overextended/ox_target
  - ox_inventory: https://github.com/overextended/ox_inventory
  - oxmysql: https://github.com/overextended/oxmysql

file_structure:
  root: Blackcrafting/
  structure:
    client:
      - main.lua: "Handles interaction, UI, skill check, crafting logic"
    server:
      - main.lua: "XP saving/loading, item transactions"
      - xp.lua: "(Optional) XP-specific events"
      - sql.sql: "SQL table schema"
    - config.lua: "Bench position, crafting recipes, XP levels"
    - fxmanifest.lua: "Resource manifest"
    - LICENSE: "License file"

config_example:
  levels:
    - [0, "Novice"]
    - [100, "Apprentice"]
    - [200, "Journeyman"]
    - [300, "Expert"]
    - [400, "Master"]
  craftable_items:
    lockpick:
      menutitle: "Lock Pick"
      requiredXP: 0
      rewardXP: 10
      image: "https://items.bit-scripts.com/images/general/lockpick.png"
      recipe:
        - itemname: metal
          itemamont: 5
        - itemname: plastic
          itemamont: 2

sql_table:
  name: playercraftxp
  schema: |
    CREATE TABLE IF NOT EXISTS playercraftxp (
      identifier VARCHAR(100) NOT NULL PRIMARY KEY,
      steam_name VARCHAR(100),
      character_name VARCHAR(100),
      xp INT DEFAULT 0
    );

how_it_works:
  - "Player interacts with a crafting bench (ox_target)"
  - "Menu shows XP level and available items"
  - "If requirements are met, player completes a skill check minigame"
  - "On success:"
  - "  • Required items are removed"
  - "  • New item is added to inventory"
  - "  • XP is rewarded and stored in database"
  - "  • Player levels up and unlocks more recipes"

license: MIT
