-- ============================================================
-- HOSPITAL OPERATIONS & PATIENT FLOW ANALYTICS
-- STEP 3: MYSQL DATABASE + SQL ANALYSIS
-- ============================================================
--
-- Project:
-- Hospital Operations & Patient Flow Analytics
--
-- Database:
-- MySQL
--
-- Input File:
-- hospital_operations_cleaned.csv
--
-- Purpose:
-- Analyze hospital operations using SQL and generate
-- business-oriented insights for Power BI.
--
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_analytics;

-- Select the database
USE hospital_analytics;


-- ============================================================
-- 2. CREATE HOSPITAL OPERATIONS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital_operations (

    Patient_ID VARCHAR(20),

    Appointment_ID VARCHAR(20),

    Patient_Age INT,

    Gender VARCHAR(10),

    Department VARCHAR(50),

    City VARCHAR(50),

    Admission_Type VARCHAR(30),

    Appointment_Date DATE,

    Day_of_Week VARCHAR(15),

    Waiting_Time_Min INT,

    Consultation_Time_Min INT,

    Length_of_Stay_Days INT,

    Payment_Mode VARCHAR(20),

    Status VARCHAR(30),

    Age_Group VARCHAR(20),

    Year INT,

    Month INT,

    Month_Name VARCHAR(20)

);


-- ============================================================
-- 3. VERIFY TABLE STRUCTURE
-- ============================================================

-- Check the columns and their data types

DESCRIBE hospital_operations;


-- ============================================================
-- 4. CHECK WHETHER DATA WAS IMPORTED
-- ============================================================

-- Count total rows in the table.
-- Expected result after CSV import: 10,000

SELECT
    COUNT(*) AS total_rows
FROM hospital_operations;


-- ============================================================
-- 5. VIEW SAMPLE RECORDS
-- ============================================================

-- Display the first 10 records

SELECT *
FROM hospital_operations
LIMIT 10;


-- ============================================================
-- 6. BASIC DATA VALIDATION
-- ============================================================

-- Count unique patients

SELECT
    COUNT(DISTINCT Patient_ID) AS total_patients
FROM hospital_operations;


-- Count unique appointments

SELECT
    COUNT(DISTINCT Appointment_ID) AS total_appointments
FROM hospital_operations;


-- Check missing values in important columns

SELECT

    COUNT(*) AS total_rows,

    SUM(Patient_ID IS NULL) AS missing_patient_id,

    SUM(Appointment_ID IS NULL) AS missing_appointment_id,

    SUM(Department IS NULL) AS missing_department,

    SUM(Appointment_Date IS NULL) AS missing_date,

    SUM(Waiting_Time_Min IS NULL) AS missing_waiting_time

FROM hospital_operations;


-- ============================================================
-- 7. OVERALL HOSPITAL KPIs
-- ============================================================

-- Average waiting time of patients

SELECT
    ROUND(AVG(Waiting_Time_Min), 2)
        AS average_waiting_time
FROM hospital_operations;


-- Average consultation time

SELECT
    ROUND(AVG(Consultation_Time_Min), 2)
        AS average_consultation_time
FROM hospital_operations;


-- Average length of stay

SELECT
    ROUND(AVG(Length_of_Stay_Days), 2)
        AS average_length_of_stay
FROM hospital_operations;


-- ============================================================
-- 8. PATIENT VOLUME BY DEPARTMENT
-- ============================================================

-- Find which departments handle the highest number of patients

SELECT

    Department,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Department

ORDER BY patient_count DESC;


-- ============================================================
-- 9. AVERAGE WAITING TIME BY DEPARTMENT
-- ============================================================

-- Compare the average waiting time across departments

SELECT

    Department,

    COUNT(*) AS patient_count,

    ROUND(
        AVG(Waiting_Time_Min),
        2
    ) AS avg_waiting_time

FROM hospital_operations

GROUP BY Department

ORDER BY avg_waiting_time DESC;


-- ============================================================
-- 10. AVERAGE CONSULTATION TIME BY DEPARTMENT
-- ============================================================

SELECT

    Department,

    ROUND(
        AVG(Consultation_Time_Min),
        2
    ) AS avg_consultation_time

FROM hospital_operations

GROUP BY Department

ORDER BY avg_consultation_time DESC;


-- ============================================================
-- 11. AVERAGE LENGTH OF STAY BY DEPARTMENT
-- ============================================================

SELECT

    Department,

    ROUND(
        AVG(Length_of_Stay_Days),
        2
    ) AS avg_length_of_stay

FROM hospital_operations

GROUP BY Department

ORDER BY avg_length_of_stay DESC;


-- ============================================================
-- 12. PATIENT VOLUME BY CITY
-- ============================================================

SELECT

    City,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY City

ORDER BY patient_count DESC;


-- ============================================================
-- 13. ADMISSION TYPE ANALYSIS
-- ============================================================

-- Analyze Scheduled, Emergency and Walk-in visits

SELECT

    Admission_Type,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Admission_Type

ORDER BY patient_count DESC;


-- ============================================================
-- 14. PATIENT STATUS ANALYSIS
-- ============================================================

-- Analyze Discharged, Admitted and Transferred patients

SELECT

    Status,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Status

ORDER BY patient_count DESC;


-- ============================================================
-- 15. PAYMENT MODE ANALYSIS
-- ============================================================

SELECT

    Payment_Mode,

    COUNT(*) AS transaction_count

FROM hospital_operations

GROUP BY Payment_Mode

ORDER BY transaction_count DESC;


-- ============================================================
-- 16. AGE GROUP ANALYSIS
-- ============================================================

SELECT

    Age_Group,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Age_Group

ORDER BY patient_count DESC;


-- ============================================================
-- 17. GENDER ANALYSIS
-- ============================================================

SELECT

    Gender,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Gender

ORDER BY patient_count DESC;


-- ============================================================
-- 18. DAY OF WEEK ANALYSIS
-- ============================================================

-- Identify days with higher patient volume

SELECT

    Day_of_Week,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Day_of_Week

ORDER BY patient_count DESC;


-- ============================================================
-- 19. MONTHLY PATIENT VOLUME
-- ============================================================

-- Analyze patient volume month by month

SELECT

    Year,

    Month,

    Month_Name,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY
    Year,
    Month,
    Month_Name

ORDER BY
    Year,
    Month;


-- ============================================================
-- 20. YEARLY PATIENT VOLUME
-- ============================================================

SELECT

    Year,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Year

ORDER BY Year;


-- ============================================================
-- 21. DEPARTMENT + STATUS ANALYSIS
-- ============================================================

-- Understand patient status distribution
-- across different departments

SELECT

    Department,

    Status,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY
    Department,
    Status

ORDER BY
    Department,
    patient_count DESC;


-- ============================================================
-- 22. DEPARTMENT + ADMISSION TYPE
-- ============================================================

SELECT

    Department,

    Admission_Type,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY
    Department,
    Admission_Type

ORDER BY
    Department,
    patient_count DESC;


-- ============================================================
-- 23. CITY + DEPARTMENT ANALYSIS
-- ============================================================

-- Understand which departments receive more patients
-- from different cities

SELECT

    City,

    Department,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY
    City,
    Department

ORDER BY
    City,
    patient_count DESC;


-- ============================================================
-- 24. HIGH-VOLUME DEPARTMENTS USING HAVING
-- ============================================================

-- Find departments having more than 1,200 patients

SELECT

    Department,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Department

HAVING COUNT(*) > 1200

ORDER BY patient_count DESC;


-- ============================================================
-- 25. DEPARTMENTS WITH ABOVE-AVERAGE WAITING TIME
-- ============================================================

-- First calculate average waiting time for each department.
-- Then compare it with the overall hospital average.

WITH department_wait AS (

    SELECT

        Department,

        AVG(Waiting_Time_Min) AS avg_wait

    FROM hospital_operations

    GROUP BY Department

)

SELECT

    Department,

    ROUND(avg_wait, 2) AS avg_waiting_time

FROM department_wait

WHERE avg_wait > (

    SELECT AVG(Waiting_Time_Min)

    FROM hospital_operations

)

ORDER BY avg_waiting_time DESC;


-- ============================================================
-- 26. RANK DEPARTMENTS BY PATIENT VOLUME
-- ============================================================

-- RANK assigns a ranking to each department
-- based on patient volume.

SELECT

    Department,

    COUNT(*) AS patient_count,

    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS department_rank

FROM hospital_operations

GROUP BY Department

ORDER BY department_rank;


-- ============================================================
-- 27. DENSE RANK DEPARTMENTS
-- ============================================================

-- DENSE_RANK is similar to RANK,
-- but does not leave gaps after ties.

SELECT

    Department,

    COUNT(*) AS patient_count,

    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS department_rank

FROM hospital_operations

GROUP BY Department

ORDER BY department_rank;


-- ============================================================
-- 28. MONTH-OVER-MONTH PATIENT VOLUME
-- ============================================================

-- LAG allows us to compare the current month
-- with the previous month.

WITH monthly_data AS (

    SELECT

        Year,

        Month,

        Month_Name,

        COUNT(*) AS patient_count

    FROM hospital_operations

    GROUP BY
        Year,
        Month,
        Month_Name

)

SELECT

    Year,

    Month,

    Month_Name,

    patient_count,

    LAG(patient_count) OVER (
        ORDER BY Year, Month
    ) AS previous_month_patients

FROM monthly_data

ORDER BY
    Year,
    Month;


-- ============================================================
-- 29. MONTH-OVER-MONTH CHANGE
-- ============================================================

WITH monthly_data AS (

    SELECT

        Year,

        Month,

        Month_Name,

        COUNT(*) AS patient_count

    FROM hospital_operations

    GROUP BY
        Year,
        Month,
        Month_Name

),

monthly_comparison AS (

    SELECT

        Year,

        Month,

        Month_Name,

        patient_count,

        LAG(patient_count) OVER (
            ORDER BY Year, Month
        ) AS previous_month_patients

    FROM monthly_data

)

SELECT

    Year,

    Month,

    Month_Name,

    patient_count,

    previous_month_patients,

    patient_count - previous_month_patients
        AS month_over_month_change

FROM monthly_comparison

ORDER BY
    Year,
    Month;


-- ============================================================
-- 30. MONTH-OVER-MONTH PERCENTAGE CHANGE
-- ============================================================

WITH monthly_data AS (

    SELECT

        Year,

        Month,

        Month_Name,

        COUNT(*) AS patient_count

    FROM hospital_operations

    GROUP BY
        Year,
        Month,
        Month_Name

),

monthly_comparison AS (

    SELECT

        Year,

        Month,

        Month_Name,

        patient_count,

        LAG(patient_count) OVER (
            ORDER BY Year, Month
        ) AS previous_month_patients

    FROM monthly_data

)

SELECT

    Year,

    Month,

    Month_Name,

    patient_count,

    previous_month_patients,

    ROUND(

        (
            (patient_count - previous_month_patients)
            / previous_month_patients
        ) * 100,

        2

    ) AS mom_percentage_change

FROM monthly_comparison

ORDER BY
    Year,
    Month;


-- ============================================================
-- 31. DEPARTMENTS WITH HIGH WAITING TIME
-- ============================================================

-- Find departments where average waiting time
-- is greater than 30 minutes.

SELECT

    Department,

    ROUND(
        AVG(Waiting_Time_Min),
        2
    ) AS avg_waiting_time

FROM hospital_operations

GROUP BY Department

HAVING AVG(Waiting_Time_Min) > 30

ORDER BY avg_waiting_time DESC;


-- ============================================================
-- 32. PATIENTS WAITING MORE THAN 45 MINUTES
-- ============================================================

SELECT

    Department,

    COUNT(*) AS patients_waiting_over_45_min

FROM hospital_operations

WHERE Waiting_Time_Min > 45

GROUP BY Department

ORDER BY patients_waiting_over_45_min DESC;


-- ============================================================
-- 33. COMPLETE DEPARTMENT PERFORMANCE ANALYSIS
-- ============================================================

SELECT

    Department,

    COUNT(*) AS patient_count,

    ROUND(
        AVG(Waiting_Time_Min),
        2
    ) AS avg_waiting_time,

    ROUND(
        AVG(Consultation_Time_Min),
        2
    ) AS avg_consultation_time,

    ROUND(
        AVG(Length_of_Stay_Days),
        2
    ) AS avg_length_of_stay

FROM hospital_operations

GROUP BY Department

ORDER BY patient_count DESC;


-- ============================================================
-- 34. OVERALL ADMISSION RATE
-- ============================================================

SELECT

    ROUND(

        (
            SUM(Status = 'Admitted')
            / COUNT(*)
        ) * 100,

        2

    ) AS admission_rate_percentage

FROM hospital_operations;


-- ============================================================
-- 35. OVERALL TRANSFER RATE
-- ============================================================

SELECT

    ROUND(

        (
            SUM(Status = 'Transferred')
            / COUNT(*)
        ) * 100,

        2

    ) AS transfer_rate_percentage

FROM hospital_operations;


-- ============================================================
-- 36. OVERALL DISCHARGE RATE
-- ============================================================

SELECT

    ROUND(

        (
            SUM(Status = 'Discharged')
            / COUNT(*)
        ) * 100,

        2

    ) AS discharge_rate_percentage

FROM hospital_operations;


-- ============================================================
-- 37. DEPARTMENT-WISE ADMISSION RATE
-- ============================================================

SELECT

    Department,

    COUNT(*) AS total_patients,

    SUM(Status = 'Admitted')
        AS admitted_patients,

    ROUND(

        (
            SUM(Status = 'Admitted')
            / COUNT(*)
        ) * 100,

        2

    ) AS admission_rate_percentage

FROM hospital_operations

GROUP BY Department

ORDER BY admission_rate_percentage DESC;


-- ============================================================
-- 38. CITY-WISE WAITING TIME
-- ============================================================

SELECT

    City,

    COUNT(*) AS patient_count,

    ROUND(
        AVG(Waiting_Time_Min),
        2
    ) AS avg_waiting_time

FROM hospital_operations

GROUP BY City

ORDER BY avg_waiting_time DESC;


-- ============================================================
-- 39. ADMISSION TYPE + STATUS
-- ============================================================

SELECT

    Admission_Type,

    Status,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY
    Admission_Type,
    Status

ORDER BY
    Admission_Type,
    patient_count DESC;


-- ============================================================
-- 40. AGE GROUP + STATUS
-- ============================================================

SELECT

    Age_Group,

    Status,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY
    Age_Group,
    Status

ORDER BY
    Age_Group,
    patient_count DESC;


-- ============================================================
-- 41. FIND HIGHEST WAITING-TIME DEPARTMENT
-- ============================================================

SELECT

    Department,

    ROUND(
        AVG(Waiting_Time_Min),
        2
    ) AS avg_waiting_time

FROM hospital_operations

GROUP BY Department

ORDER BY avg_waiting_time DESC

LIMIT 1;


-- ============================================================
-- 42. FIND HIGHEST-VOLUME DEPARTMENT
-- ============================================================

SELECT

    Department,

    COUNT(*) AS patient_count

FROM hospital_operations

GROUP BY Department

ORDER BY patient_count DESC

LIMIT 1;


-- ============================================================
-- 43. FINAL MANAGEMENT SUMMARY
-- ============================================================

-- This query produces the main KPIs
-- that can later be displayed in Power BI.

SELECT

    COUNT(DISTINCT Patient_ID)
        AS total_patients,

    COUNT(DISTINCT Appointment_ID)
        AS total_appointments,

    ROUND(
        AVG(Waiting_Time_Min),
        2
    ) AS avg_waiting_time,

    ROUND(
        AVG(Consultation_Time_Min),
        2
    ) AS avg_consultation_time,

    ROUND(
        AVG(Length_of_Stay_Days),
        2
    ) AS avg_length_of_stay,

    SUM(Status = 'Admitted')
        AS total_admissions,

    SUM(Status = 'Discharged')
        AS total_discharges,

    SUM(Status = 'Transferred')
        AS total_transfers

FROM hospital_operations;