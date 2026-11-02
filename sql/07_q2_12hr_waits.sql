-- Q2: Concentration of 12-hour waits (decision to admit to admission) by trust
-- Oct 2024 to Sep 2026, the 112 trusts with all 24 months of data

WITH trust_waits AS (
    SELECT org_code,
           org_name,
           SUM(dta_to_admission_above_12hrs)               AS waits_12hr,
           SUM(emergency_admissions_via_ae_type_1
             + emergency_admissions_via_ae_type_2
             + emergency_admissions_via_ae_others)         AS admissions_via_ae
    FROM   ae_monthly
    WHERE  has_type1
    GROUP BY org_code, org_name
    HAVING COUNT(DISTINCT period) = 24
)
SELECT org_code,
       org_name AS provider,
       waits_12hr,
       admissions_via_ae,
       ROUND(waits_12hr / NULLIF(admissions_via_ae, 0) * 1000, 1) AS waits_per_1000_admissions,
       ROUND(waits_12hr / SUM(waits_12hr) OVER () * 100, 1)        AS pct_of_all_waits,
       ROUND(SUM(waits_12hr) OVER (ORDER BY waits_12hr DESC, org_code
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
             / SUM(waits_12hr) OVER () * 100, 1)                    AS cumulative_pct,
       RANK() OVER (ORDER BY waits_12hr DESC)                      AS waits_rank
FROM   trust_waits
ORDER BY waits_12hr DESC;


--ranking by admissions per 1000
WITH trust_waits AS (
    SELECT org_code,
           org_name,
           SUM(dta_to_admission_above_12hrs)               AS waits_12hr,
           SUM(emergency_admissions_via_ae_type_1
             + emergency_admissions_via_ae_type_2
             + emergency_admissions_via_ae_others)         AS admissions_via_ae
    FROM   ae_monthly
    WHERE  has_type1
    GROUP BY org_code, org_name
    HAVING COUNT(DISTINCT period) = 24
)
SELECT org_code,
       org_name AS provider,
       waits_12hr,
       admissions_via_ae,
       ROUND(waits_12hr / NULLIF(admissions_via_ae, 0) * 1000, 1) AS waits_per_1000_admissions,
       ROUND(waits_12hr / SUM(waits_12hr) OVER () * 100, 1)        AS pct_of_all_waits,
       ROUND(SUM(waits_12hr) OVER (ORDER BY waits_12hr DESC, org_code
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
             / SUM(waits_12hr) OVER () * 100, 1)                    AS cumulative_pct,
       RANK() OVER (ORDER BY waits_12hr DESC)                      AS waits_rank
FROM   trust_waits
ORDER BY waits_per_1000_admissions DESC;


--checking org_code 'RJ6'
SELECT period, dta_to_admission_above_12hrs,
       emergency_admissions_via_ae_type_1 + emergency_admissions_via_ae_type_2
     + emergency_admissions_via_ae_others AS admissions_via_ae
FROM   ae_monthly
WHERE  org_code = 'RJ6'
ORDER BY period;
--“Croydon’s admissions via A&E are low relative to its waits; worth confirming against trust-level sources--


-- How many Type 1 trusts reported zero 12-hour waits each month?
SELECT period,
       COUNT(CASE WHEN dta_to_admission_above_12hrs = 0 THEN 1 END) AS trusts_with_zero,
       COUNT(*)                                                    AS trusts_reporting
FROM   ae_monthly
WHERE  has_type1
GROUP BY period
ORDER BY period;