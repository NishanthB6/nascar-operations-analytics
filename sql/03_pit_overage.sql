
-- 03_pit_overage.sql
-- Overage per stop vs the P75 benchmark.
CREATE OR REPLACE VIEW pit_overage AS
SELECT
  p.*,
  b.p75_sec,
  GREATEST(COALESCE(p.stop_time_sec,0) - COALESCE(b.p75_sec,0), 0) AS overage_sec
FROM pit_clean p
LEFT JOIN pit_benchmarks b USING (track_name);
