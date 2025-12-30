
-- 02_pit_benchmarks.sql
-- Track-level percentile benchmarks for pit stop time.
CREATE OR REPLACE VIEW pit_benchmarks AS
SELECT
  track_name,
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY stop_time_sec) AS p50_sec,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY stop_time_sec) AS p75_sec,
  COUNT(*) AS n_stops
FROM pit_clean
WHERE stop_time_sec BETWEEN 5 AND 60
GROUP BY track_name;
