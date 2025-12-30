
-- 06_trend_queries.sql
-- Handy trend slices for Tableau.
-- Pit efficiency trend (median & P75 per event)
CREATE OR REPLACE VIEW v_trend_pit_efficiency AS
SELECT
  race_date,
  track_name,
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY stop_time_sec) AS median_pit_sec,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY stop_time_sec) AS p75_pit_sec
FROM pit_clean
WHERE stop_time_sec BETWEEN 5 AND 60
GROUP BY race_date, track_name;

-- Overage by stop reason
CREATE OR REPLACE VIEW v_overage_by_reason AS
SELECT
  race_date,
  reason,
  SUM(overage_sec) AS total_overage_sec
FROM pit_overage
GROUP BY race_date, reason;

-- Penalty composition by event
CREATE OR REPLACE VIEW v_penalty_composition AS
SELECT
  race_date,
  penalty_code,
  SUM(seconds_std) AS total_penalty_seconds
FROM penalty_seconds
GROUP BY race_date, penalty_code;

-- Team leaderboard per event
CREATE OR REPLACE VIEW v_team_ops_delay AS
SELECT
  race_date,
  team_name,
  SUM(ops_delay_sec)   AS team_ops_delay_sec,
  SUM(pit_overage_sec) AS team_pit_overage_sec,
  SUM(penalty_sec)     AS team_penalty_sec
FROM ops_delay_per_entry
GROUP BY race_date, team_name;
