
-- 09_quality_checks.sql
-- Lightweight QA queries.
-- Duplicate stop keys (race/track/car/stop_seq)
SELECT race_date, track_name, car_no, stop_seq, COUNT(*) AS dup_rows
FROM pit_clean
GROUP BY 1,2,3,4
HAVING COUNT(*) > 1
ORDER BY dup_rows DESC;

-- Out-of-range or missing pit times
SELECT *
FROM pit_clean
WHERE stop_time_sec IS NULL
   OR stop_time_sec < 4
   OR stop_time_sec > 70
ORDER BY race_date, track_name, car_no, stop_seq;

-- Benchmark coverage
SELECT track_name, n_stops, p50_sec, p75_sec
FROM pit_benchmarks
ORDER BY n_stops ASC;
