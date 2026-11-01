--Ranking by Trusts
SELECT * FROM ae_monthly;

SELECT org_code,
       org_name AS provider,
       count(distinct period) AS month_reported,
      sum(ae_att_type_1+ae_att_type_1_booked) AS Major_Emergency_Attendance,
      sum(ae_att_over_4hrs_type_1+ae_att_over_4hrs_type_1_booked) AS Major_Emergency_4hr_Breaches,
      round((sum(ae_att_type_1+ae_att_type_1_booked)-sum(ae_att_over_4hrs_type_1+ae_att_over_4hrs_type_1_booked))/
      sum(ae_att_type_1+ae_att_type_1_booked)*100,1) AS Pct_Major_Emergency,
      RANK() OVER (ORDER BY ROUND((SUM(ae_att_type_1 + ae_att_type_1_booked) - 
      SUM(ae_att_over_4hrs_type_1 + ae_att_over_4hrs_type_1_booked)) / 
      SUM(ae_att_type_1 + ae_att_type_1_booked) * 100, 1) DESC) AS performance_rank
      
      from ae_monthly
      WHERE has_type1
      GROUP BY org_code,org_name
      ORDER BY performance_rank ;