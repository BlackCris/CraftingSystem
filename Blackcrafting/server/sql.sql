CREATE TABLE IF NOT EXISTS playercraftxp (
    identifier VARCHAR(100) PRIMARY KEY,
    steam_name VARCHAR(100),
    character_name VARCHAR(100),
    xp INT DEFAULT 0
);
