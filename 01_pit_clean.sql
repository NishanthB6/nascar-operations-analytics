
-- 01_pit_clean.sql
-- Normalizes staging CSV data into a clean view for downstream analytics.
CREATE OR REPLACE VIEW pit_clean AS
SELECT
  source_file,
  race_date::date,
  track_name,
  car_no,
  COALESCE(NULLIF(driver_name,''), NULL)  AS driver_name,
  COALESCE(NULLIF(team_name,''), NULL)    AS team_name,
  stop_seq::int                           AS stop_seq,
  lap_in::int                             AS lap_in,
  lap_out::int                            AS lap_out,
  pit_in_ts::timestamp                    AS pit_in_ts,
  pit_out_ts::timestamp                   AS pit_out_ts,
  NULLIF(stop_time_sec,'')::numeric       AS stop_time_sec,
  COALESCE(NULLIF(reason,''),'unspecified') AS reason,
  COALESCE(NULLIF(penalty_code,''), NULL) AS penalty_code,
  NULLIF(penalty_seconds,'')::numeric     AS penalty_seconds
FROM stg_pitdata_raw;
