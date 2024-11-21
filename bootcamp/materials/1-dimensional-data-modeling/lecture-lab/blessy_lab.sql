SELECT * FROM player_seasons;

-- create a table with 1 row per player and have an array for all of their seasons
CREATE TYPE season_stats AS (
    season INTEGER,
    gp INTEGER,
    pts REAL,
    reb REAL,
    ast REAL
);

CREATE TABLE players(
    player_name TEXT,
    height TEXT,
    college TEXT,
    country TEXT,
    draft_year TEXT,
    draft_round TEXT,
    draft_number TEXT,
    season_stats season_stats[],
    current_season INTEGER,
    PRIMARY KEY(player_name, current_season)
);

SELECT * FROM players;

SELECT MIN(season) FROM player_seasons;

WITH yesterday AS (
    SELECT * FROM players
    WHERE current_season = 1995
),
today AS (
    SELECT * FROM player_seasons
    WHERE season = 1996
)
SELECT 
COALESCE(t.player_name, y.player_name) AS player_name, 
COALESCE(t.height, y.height) AS height, 
COALESCE(t.college, y.college) AS college, 
COALESCE(t.country, y.country) AS country, 
COALESCE(t.draft_year, y.draft_year) AS draft_year, 
COALESCE(t.draft_round, y.draft_round) AS draft_round, 
COALESCE(t.draft_number, y.draft_number) AS draft_number,
CASE WHEN y.season_stats IS NULL
    THEN ARRAY[
        ROW(
            t.season,
            t.gp,
            t.pts,
            t.reb,
            t.ast
        )::season_stats
    ]
ELSE y.season_stats || ARRAY[
        ROW(
            t.season,
            t.gp,
            t.pts,
            t.reb,
            t.ast
        )::season_stats
    ]
END as season_stats
FROM today t FULL OUTER JOIN yesterday y
ON t.player_name = y.player_name;