--National 4-hour performance by month (october 2024 to September 2026)


       
       
SELECT period,
      sum(total_att) AS Total_attendance,
      sum(total_over_4hrs) AS Total_4hrs_breach,
      round(sum(total_att-total_over_4hrs)/sum(total_att) *100,1) AS Pct_4hrs
      from ae_monthly
      
      GROUP BY period
      ORDER by period;
      
      
       
       