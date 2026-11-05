-- Q2: Trust pressure bands, Type 1 4-hour performance against the 95% standard
-- Oct 2024 to Sep 2026, the 112 trusts with all 24 months of data

WITH trust_perf AS (
    SELECT org_code,
           max(org_name) KEEP (DENSE_RANK LAST ORDER BY period) AS org_name,
           (SUM(ae_att_type_1 + ae_att_type_1_booked)
          - SUM(ae_att_over_4hrs_type_1 + ae_att_over_4hrs_type_1_booked))
          / SUM(ae_att_type_1 + ae_att_type_1_booked) * 100      AS pct_4hr
    FROM   ae_monthly
    WHERE  has_type1
    GROUP BY org_code
    HAVING COUNT(DISTINCT period) = 24
),
categorised AS (
    SELECT org_code,
           org_name,
           pct_4hr,
           95 - pct_4hr                                          AS gap_to_standard,
           CASE
               WHEN pct_4hr >= 95 THEN '1. Meets standard (95%+)'
               WHEN pct_4hr >= 85 THEN '2. Near standard (85-94.9%)'
               WHEN pct_4hr >= 75 THEN '3. Moderate pressure (75-84.9%)'
               WHEN pct_4hr >= 60 THEN '4. High pressure (60-74.9%)'
               ELSE                    '5. Severe pressure (below 60%)'
           END                                                   AS pressure_band
    FROM   trust_perf
)
SELECT pressure_band,
       COUNT(*)                                              AS trusts,
       ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)      AS pct_of_trusts,
       ROUND(MIN(pct_4hr), 1)                                AS lowest_pct,
       ROUND(MAX(pct_4hr), 1)                                AS highest_pct,
       ROUND(AVG(gap_to_standard), 1)                        AS avg_gap_to_95
FROM   categorised
GROUP BY pressure_band
ORDER BY pressure_band;


--trust lists 
WITH trust_perf AS (
    SELECT org_code,
           org_name,
           (SUM(ae_att_type_1 + ae_att_type_1_booked)
          - SUM(ae_att_over_4hrs_type_1 + ae_att_over_4hrs_type_1_booked))
          / SUM(ae_att_type_1 + ae_att_type_1_booked) * 100      AS pct_4hr
    FROM   ae_monthly
    WHERE  has_type1
    GROUP BY org_code,org_name
    HAVING COUNT(DISTINCT period) = 24
),
categorised AS (
    SELECT org_code,
           org_name,
           pct_4hr,
           95 - pct_4hr                                          AS gap_to_standard,
           CASE
               WHEN pct_4hr >= 95 THEN '1. Meets standard (95%+)'
               WHEN pct_4hr >= 85 THEN '2. Near standard (85-94.9%)'
               WHEN pct_4hr >= 75 THEN '3. Moderate pressure (75-84.9%)'
               WHEN pct_4hr >= 60 THEN '4. High pressure (60-74.9%)'
               ELSE                    '5. Severe pressure (below 60%)'
           END                                                   AS pressure_band
    FROM   trust_perf
)
SELECT org_code,
       org_name                 AS provider,
       ROUND(pct_4hr, 1)        AS pct_4hr,
       ROUND(gap_to_standard,1) AS gap_to_95,
       pressure_band
FROM   categorised
ORDER BY pct_4hr desc;

SELECT org_code, COUNT(DISTINCT org_name) AS name_versions
FROM   ae_monthly
WHERE  has_type1
GROUP BY org_code
HAVING COUNT(DISTINCT org_name) > 1;

SELECT org_code,
       org_name,
       MIN(period)            AS first_month,
       MAX(period)            AS last_month,
       COUNT(DISTINCT period) AS months
FROM   ae_monthly
WHERE  has_type1
AND    org_code IN (SELECT org_code
                    FROM   ae_monthly
                    WHERE  has_type1
                    GROUP BY org_code
                    HAVING COUNT(DISTINCT org_name) > 1)
GROUP BY org_code, org_name
ORDER BY org_code, first_month;


