-- Q2: Change in Type 1 4-hour performance by trust, Year 1 vs Year 2
-- Year 1 = Oct 2024 to Sep 2025, Year 2 = Oct 2025 to Sep 2026
-- Restricted to the 112 trusts with all 24 months of data

WITH trust_years AS (
    SELECT org_code,
           org_name,
           SUM(CASE WHEN period <  DATE '2025-10-01'
                    THEN ae_att_type_1 + ae_att_type_1_booked END)                       AS att_y1,
           SUM(CASE WHEN period <  DATE '2025-10-01'
                    THEN ae_att_over_4hrs_type_1 + ae_att_over_4hrs_type_1_booked END)   AS breach_y1,
           SUM(CASE WHEN period >= DATE '2025-10-01'
                    THEN ae_att_type_1 + ae_att_type_1_booked END)                       AS att_y2,
           SUM(CASE WHEN period >= DATE '2025-10-01'
                    THEN ae_att_over_4hrs_type_1 + ae_att_over_4hrs_type_1_booked END)   AS breach_y2
    FROM   ae_monthly
    WHERE  has_type1
    GROUP BY org_code, org_name
    HAVING COUNT(DISTINCT period) = 24
)
SELECT org_code,
       org_name AS provider,
       ROUND((att_y1 - breach_y1) / att_y1 * 100, 1) AS pct_year1,
       ROUND((att_y2 - breach_y2) / att_y2 * 100, 1) AS pct_year2,
       ROUND((att_y2 - breach_y2) / att_y2 * 100
           - (att_y1 - breach_y1) / att_y1 * 100, 1) AS change_pts
FROM   trust_years
ORDER BY change_pts desc;