import pandas as pd

# ============================================================
# STEP 2: DATA CLEANING + EXPLORATORY DATA ANALYSIS
# Hospital Operations & Patient Flow Analytics
# ============================================================


# ------------------------------------------------------------
# 1. LOAD DATASET
# ------------------------------------------------------------

file_path = "hospital_operations_data.csv"

df = pd.read_csv(file_path)

print("\n========== DATA LOADED ==========")
print("Dataset Shape:", df.shape)

print("\nFirst 5 Rows:")
print(df.head())


# ------------------------------------------------------------
# 2. BASIC INFORMATION
# ------------------------------------------------------------

print("\n========== COLUMN INFORMATION ==========")

print("\nColumns:")
print(df.columns.tolist())

print("\nData Types:")
print(df.dtypes)

print("\nDataset Information:")
df.info()


# ------------------------------------------------------------
# 3. CHECK MISSING VALUES
# ------------------------------------------------------------

print("\n========== MISSING VALUES ==========")

missing_values = df.isnull().sum()

print(missing_values)

print("\nTotal Missing Values:", df.isnull().sum().sum())


# ------------------------------------------------------------
# 4. CHECK DUPLICATES
# ------------------------------------------------------------

print("\n========== DUPLICATES ==========")

duplicate_count = df.duplicated().sum()

print("Duplicate Rows:", duplicate_count)


# ------------------------------------------------------------
# 5. CONVERT DATE COLUMN
# ------------------------------------------------------------

df["Appointment_Date"] = pd.to_datetime(
    df["Appointment_Date"],
    errors="coerce"
)

print("\n========== DATE CONVERSION ==========")

print(df["Appointment_Date"].dtype)


# ------------------------------------------------------------
# 6. HANDLE DUPLICATES
# ------------------------------------------------------------

df = df.drop_duplicates()

print("\nAfter Removing Duplicates:")
print("Rows:", len(df))


# ------------------------------------------------------------
# 7. HANDLE MISSING VALUES
# ------------------------------------------------------------

# Fill missing City with most frequent city
df["City"] = df["City"].fillna(df["City"].mode()[0])

# Fill missing Payment_Mode with most frequent payment mode
df["Payment_Mode"] = df["Payment_Mode"].fillna(
    df["Payment_Mode"].mode()[0]
)

print("\n========== MISSING VALUES AFTER CLEANING ==========")

print(df.isnull().sum())


# ------------------------------------------------------------
# 8. CREATE AGE GROUP
# ------------------------------------------------------------

def create_age_group(age):

    if age <= 17:
        return "0-17"

    elif age <= 35:
        return "18-35"

    elif age <= 50:
        return "36-50"

    elif age <= 65:
        return "51-65"

    else:
        return "66+"


df["Age_Group"] = df["Patient_Age"].apply(create_age_group)


# ------------------------------------------------------------
# 9. CREATE YEAR
# ------------------------------------------------------------

df["Year"] = df["Appointment_Date"].dt.year


# ------------------------------------------------------------
# 10. CREATE MONTH NUMBER
# ------------------------------------------------------------

df["Month"] = df["Appointment_Date"].dt.month


# ------------------------------------------------------------
# 11. CREATE MONTH NAME
# ------------------------------------------------------------

df["Month_Name"] = df["Appointment_Date"].dt.month_name()


# ------------------------------------------------------------
# 12. FINAL DATASET CHECK
# ------------------------------------------------------------

print("\n========== FINAL DATASET ==========")

print("Final Shape:", df.shape)

print("\nFinal Columns:")
print(df.columns.tolist())

print("\nRemaining Missing Values:")
print(df.isnull().sum().sum())

print("\nRemaining Duplicates:")
print(df.duplicated().sum())


# ============================================================
# EXPLORATORY DATA ANALYSIS
# ============================================================


# ------------------------------------------------------------
# 13. TOTAL PATIENTS
# ------------------------------------------------------------

total_patients = df["Patient_ID"].nunique()

print("\n========== KPI SUMMARY ==========")

print("Total Patients:", total_patients)


# ------------------------------------------------------------
# 14. TOTAL APPOINTMENTS
# ------------------------------------------------------------

total_appointments = df["Appointment_ID"].nunique()

print("Total Appointments:", total_appointments)


# ------------------------------------------------------------
# 15. AVERAGE WAITING TIME
# ------------------------------------------------------------

average_waiting_time = df["Waiting_Time_Min"].mean()

print(
    "Average Waiting Time:",
    round(average_waiting_time, 2),
    "minutes"
)


# ------------------------------------------------------------
# 16. AVERAGE CONSULTATION TIME
# ------------------------------------------------------------

average_consultation_time = df["Consultation_Time_Min"].mean()

print(
    "Average Consultation Time:",
    round(average_consultation_time, 2),
    "minutes"
)


# ------------------------------------------------------------
# 17. PATIENT STATUS
# ------------------------------------------------------------

print("\n========== PATIENT STATUS ==========")

status_count = df["Status"].value_counts()

print(status_count)


# ------------------------------------------------------------
# 18. PATIENTS BY DEPARTMENT
# ------------------------------------------------------------

print("\n========== PATIENTS BY DEPARTMENT ==========")

department_count = (
    df["Department"]
    .value_counts()
)

print(department_count)


# ------------------------------------------------------------
# 19. AVERAGE WAITING TIME BY DEPARTMENT
# ------------------------------------------------------------

print("\n========== WAITING TIME BY DEPARTMENT ==========")

department_waiting = (
    df.groupby("Department")["Waiting_Time_Min"]
    .mean()
    .sort_values(ascending=False)
)

print(department_waiting.round(2))


# ------------------------------------------------------------
# 20. PATIENTS BY CITY
# ------------------------------------------------------------

print("\n========== PATIENTS BY CITY ==========")

city_count = df["City"].value_counts()

print(city_count)


# ------------------------------------------------------------
# 21. PATIENTS BY ADMISSION TYPE
# ------------------------------------------------------------

print("\n========== ADMISSION TYPE ==========")

admission_type_count = (
    df["Admission_Type"]
    .value_counts()
)

print(admission_type_count)


# ------------------------------------------------------------
# 22. AVERAGE LENGTH OF STAY BY DEPARTMENT
# ------------------------------------------------------------

print("\n========== LENGTH OF STAY BY DEPARTMENT ==========")

length_of_stay = (
    df.groupby("Department")["Length_of_Stay_Days"]
    .mean()
    .sort_values(ascending=False)
)

print(length_of_stay.round(2))


# ------------------------------------------------------------
# 23. PATIENTS BY AGE GROUP
# ------------------------------------------------------------

print("\n========== PATIENTS BY AGE GROUP ==========")

age_group_count = (
    df["Age_Group"]
    .value_counts()
)

print(age_group_count)


# ------------------------------------------------------------
# 24. PATIENTS BY DAY OF WEEK
# ------------------------------------------------------------

print("\n========== PATIENTS BY DAY OF WEEK ==========")

day_count = (
    df["Day_of_Week"]
    .value_counts()
)

print(day_count)


# ------------------------------------------------------------
# 25. MONTHLY PATIENT VOLUME
# ------------------------------------------------------------

print("\n========== MONTHLY PATIENT VOLUME ==========")

monthly_patients = (
    df.groupby(
        ["Year", "Month"]
    )
    .size()
    .reset_index(name="Patient_Count")
)

print(monthly_patients)


# ------------------------------------------------------------
# 26. DEPARTMENT + STATUS ANALYSIS
# ------------------------------------------------------------

print("\n========== DEPARTMENT STATUS ANALYSIS ==========")

department_status = pd.crosstab(
    df["Department"],
    df["Status"]
)

print(department_status)


# ------------------------------------------------------------
# 27. PAYMENT MODE ANALYSIS
# ------------------------------------------------------------

print("\n========== PAYMENT MODE ==========")

payment_mode = df["Payment_Mode"].value_counts()

print(payment_mode)


# ------------------------------------------------------------
# 28. SAVE CLEANED DATASET
# ------------------------------------------------------------

output_file = "hospital_operations_cleaned.csv"

df.to_csv(
    output_file,
    index=False
)

print("\n========== FILE SAVED ==========")

print(
    f"Cleaned dataset saved as: {output_file}"
)


# ------------------------------------------------------------
# 29. FINAL SUMMARY
# ------------------------------------------------------------

print("\n========================================")
print("STEP 2 COMPLETED SUCCESSFULLY")
print("========================================")

print("Original Rows      :", 10020)
print("Final Rows         :", len(df))
print("Columns            :", len(df.columns))
print("Missing Values     :", df.isnull().sum().sum())
print("Duplicate Rows     :", df.duplicated().sum())

print("\nAverage Waiting Time:",
      round(df["Waiting_Time_Min"].mean(), 2),
      "minutes")

print("Average Consultation Time:",
      round(df["Consultation_Time_Min"].mean(), 2),
      "minutes")

print("\nCleaned file:")
print(output_file)