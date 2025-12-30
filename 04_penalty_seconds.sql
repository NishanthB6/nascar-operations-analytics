
-- 04_penalty_seconds.sql
-- Standardize penalty seconds with sensible defaults when missing.
CREATE OR REPLACE VIEW penalty_seconds AS
SELECT
  race_date,
  track_name,
  car_no,
  penalty_code,
  COALESCE(
    penalty_seconds,
    CASE
      WHEN penalty_code ILIKE '%pass%'   THEN 22
      WHEN penalty_code ILIKE '%stop%'   THEN 14
      WHEN penalty_code ILIKE '%time%'   THEN 10
      WHEN penalty_code ILIKE '%speed%'  THEN 22
      WHEN penalty_code ILIKE '%equip%'  THEN 14
      ELSE 10
    END
  )::numeric AS seconds_std
FROM pit_clean
WHERE penalty_code IS NOT NULL;
