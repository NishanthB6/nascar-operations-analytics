
-- 08_change_window_views.sql
-- Optional: fixed change window for reproducible pre/post views & KPI.
CREATE TABLE IF NOT EXISTS change_windows (
  window_name   TEXT PRIMARY KEY,
  start_date    DATE NOT NULL,
  end_date      DATE
);

-- Example window; edit dates or insert your own rows.
INSERT INTO change_windows(window_name, start_date, end_date)
VALUES ('Ops_Optimization_2025', DATE '2025-07-01', NULL)
ON CONFLICT (window_name) DO NOTHING;

CREATE OR REPLACE VIEW v_pre_post_ops_delay AS
WITH win AS (
  SELECT window_name, start_date, COALESCE(end_date, DATE '2999-12-31') AS end_date
  FROM change_windows
),
labeled AS (
  SELECT
    d.*,
    CASE
      WHEN d.race_date <  w.start_date THEN 'pre'
      WHEN d.race_date >= w.start_date AND d.race_date <= w.end_date THEN 'post'
      ELSE 'other'
    END AS phase,
    w.window_name
  FROM ops_delay_per_entry d
  CROSS JOIN win w
)
SELECT
  window_name,
  phase,
  COUNT(*)                 AS team_rows,
  AVG(ops_delay_sec)       AS avg_ops_delay_sec,
  SUM(ops_delay_sec)       AS total_ops_delay_sec
FROM labeled
WHERE phase IN ('pre','post')
GROUP BY 1,2;

CREATE OR REPLACE VIEW v_ops_delay_kpi AS
WITH agg AS (
  SELECT window_name, phase, total_ops_delay_sec
  FROM v_pre_post_ops_delay
)
SELECT
  p.window_name,
  pre.total_ops_delay_sec  AS total_pre_sec,
  post.total_ops_delay_sec AS total_post_sec,
  CASE WHEN pre.total_ops_delay_sec = 0 THEN NULL
       ELSE 1 - (post.total_ops_delay_sec / pre.total_ops_delay_sec) END AS reduction_ratio,
  ROUND( (CASE WHEN pre.total_ops_delay_sec = 0 THEN NULL
       ELSE 100*(1 - (post.total_ops_delay_sec / pre.total_ops_delay_sec)) END)::NUMERIC, 2) AS reduction_pct
FROM agg pre
JOIN agg post USING (window_name)
WHERE pre.phase='pre' AND post.phase='post';
