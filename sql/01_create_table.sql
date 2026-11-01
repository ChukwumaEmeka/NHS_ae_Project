

CREATE TABLE ae_monthly (
           period DATE,
           org_code varchar(6),
           parent_org VARCHAR2(50),
           org_name varchar2(80),
           ae_att_type_1 NUMBER,
           ae_att_type_2 NUMBER,
           ae_att_others NUMBER,
           ae_att_type_1_booked NUMBER,
           ae_att_type_2_booked NUMBER,
           ae_att_others_booked NUMBER,
           ae_att_over_4hrs_type_1 NUMBER,
           ae_att_over_4hrs_type_2 NUMBER,
           ae_att_over_4hrs_others NUMBER,
           ae_att_over_4hrs_type_1_booked NUMBER,
           ae_att_over_4hrs_type_2_booked NUMBER,
           ae_att_over_4hrs_others_booked NUMBER,
           dta_to_admission_4_12hrs NUMBER,
           dta_to_admission_above_12hrs NUMBER,
           emergency_admissions_via_ae_type_1 NUMBER,
           emergency_admissions_via_ae_type_2 NUMBER,
           emergency_admissions_via_ae_others NUMBER,
           emergency_admissions_not_via_ae NUMBER,
           total_att NUMBER,
           total_over_4hrs NUMBER,
           has_type1 boolean
           
           );

DESC ae_monthly;

SELECT column_name
FROM   user_tab_columns
WHERE  table_name = 'AE_MONTHLY'
AND    column_name = 'HAS_TYPE1';

SELECT COUNT(*) FROM ae_monthly;

