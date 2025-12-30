
-- 07_kpi_reduction_template.sql
-- Parameterized KPI query for Tableau using a :start_date parameter.
-- Returns single-row reduction ratio and percent (post vs pre).
WITH labeled AS (
  SELECT
    *,
    CASE WHEN race_date <  :start_date::date THEN 'pre'
         ELSE 'post' END AS phase
  FROM ops_delay_per_entry
),
agg AS (
  SELECT
    phase,
    SUM(ops_delay_sec) AS total_ops_delay_sec
  FROM labeled
  GROUP BY phase
)
SELECT
  1.0 - (post.total_ops_delay_sec / NULLIF(pre.total_ops_delay_sec,0)) AS reduction_ratio,
  ROUND(100 * (1.0 - (post.total_ops_delay_sec / NULLIF(pre.total_ops_delay_sec,0)))::numeric, 2) AS reduction_pct
FROM agg pre
JOIN agg post ON post.phase='post'
WHERE pre.phase='pre';
