--Year on Year change in National 4-hour performance

WITH monthly AS(
SELECT period,
      sum(total_att) AS Total_attendance,
      sum(total_over_4hrs) AS Total_4hrs_breach,
      round(sum(total_att-total_over_4hrs)/sum(total_att) *100,1) AS Pct_4hrs
      from ae_monthly
      
      GROUP BY period
      
      )
      SELECT period,
      round(Pct_4hrs,1)  AS Pct_4hrs,
      round(LAG(Pct_4hrs,12) OVER (ORDER BY period),1) AS Pct_same_month_last_year,
      round(Pct_4hrs-LAG(Pct_4hrs,12) OVER (ORDER BY period),1) AS YoY_change
FROM monthly
ORDER BY period;
      
      