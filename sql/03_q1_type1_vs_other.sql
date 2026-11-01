--Q1:4-hour performance,major emergency(Type1) vs other departments

SELECT period,
      sum(ae_att_type_1+ae_att_type_1_booked) AS Major_Emergency_Attendance,
      sum(ae_att_over_4hrs_type_1+ae_att_over_4hrs_type_1_booked) AS Major_Emergency_4hr_Breaches,
      round((sum(ae_att_type_1+ae_att_type_1_booked)-sum(ae_att_over_4hrs_type_1+ae_att_over_4hrs_type_1_booked))/
      sum(ae_att_type_1+ae_att_type_1_booked)*100,1) AS Pct_Major_Emergency,
      sum(ae_att_type_2+ae_att_others+ae_att_type_2_booked+ae_att_others_booked) AS Total_Other_Emergency_Attendance,
      sum(ae_att_over_4hrs_type_2+ae_att_over_4hrs_type_2_booked+ae_att_over_4hrs_others+ae_att_over_4hrs_others_booked)AS Other_Emergency_Breaches,
      round((sum(ae_att_type_2+ae_att_others+ae_att_type_2_booked+ae_att_others_booked)-
      sum(ae_att_over_4hrs_type_2+ae_att_over_4hrs_type_2_booked+ae_att_over_4hrs_others+ae_att_over_4hrs_others_booked))/
      sum(ae_att_type_2+ae_att_others+ae_att_type_2_booked+ae_att_others_booked)*100,1) AS  Pct_Other_Emergencies
      from ae_monthly
      GROUP BY period
      ORDER BY period;