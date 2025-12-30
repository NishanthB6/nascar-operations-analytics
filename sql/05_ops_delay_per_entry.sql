
-- 05_ops_delay_per_entry.sql
-- Unified Operations Delay per race/car.
CREATE OR REPLACE VIEW ops_delay_per_entry AS
SELECT
  o.race_date,
  o.track_name,
  o.car_no,
  MIN(o.driver_name) AS driver_name,
  MIN(o.team_name)   AS team_name,
  SUM(o.overage_sec) AS pit_overage_sec,
  COALESCE(SUM(ps.seconds_std), 0) AS penalty_sec,
  0::numeric AS driver_change_sec,
  (SUM(o.overage_sec) + COALESCE(SUM(ps.seconds_std),0)) AS ops_delay_sec
FROM pit_overage o
LEFT JOIN penalty_seconds ps
  ON ps.race_date=o.race_date AND ps.track_name=o.track_name AND ps.car_no=o.car_no
GROUP BY 1,2,3;
