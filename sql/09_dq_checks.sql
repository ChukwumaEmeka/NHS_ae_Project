-- DQ check: Maidstone and Tunbridge Wells (RWF) monthly 12-hour waits
SELECT period,
       dta_to_admission_above_12hrs                     AS waits_12hr,
       dta_to_admission_4_12hrs                         AS waits_4_12hr,
       emergency_admissions_via_ae_type_1
     + emergency_admissions_via_ae_type_2
     + emergency_admissions_via_ae_others               AS admissions_via_ae
FROM   ae_monthly
WHERE  org_code = 'RWF'
ORDER BY period;

-- DQ check: Type 1 trusts reporting zero 12-hour waits
SELECT org_code,
       MAX(org_name) KEEP (DENSE_RANK LAST ORDER BY period)  AS org_name,
       COUNT(*)                                              AS months,
       SUM(CASE WHEN dta_to_admission_above_12hrs = 0
                THEN 1 ELSE 0 END)                           AS months_zero_12hr,
       SUM(dta_to_admission_above_12hrs)                     AS total_12hr_waits,
       SUM(dta_to_admission_4_12hrs)                         AS total_4_12hr_waits
FROM   ae_monthly
WHERE  has_type1
GROUP BY org_code
HAVING COUNT(DISTINCT period) = 24
   AND SUM(CASE WHEN dta_to_admission_above_12hrs = 0
                THEN 1 ELSE 0 END) >= 12
ORDER BY months_zero_12hr DESC;
