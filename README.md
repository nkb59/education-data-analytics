# education-data-analytics

📊 Educational Metrics SQL & Visualization Project
This project explores and analyzes an educational dataset using SQL for data modeling, querying, and analytical insights. It focuses on student performance, study habits, parental involvement, and extracurricular activities to uncover patterns and relationships that impact academic outcomes.

🔍 Project Objectives
Design a normalized relational database to store student-related educational metrics.

Populate and analyze data using complex SQL queries.

Derive insights related to GPA, study time, parental support, absences, and more.

Use statistical measures and conditional logic to categorize and rank students.

Identify at-risk students and uncover underperforming patterns despite high effort.

Prepare data for visualization tools (e.g., Tableau, Power BI) to present insights.

🧱 Database Structure
The project includes the following key tables:

Student: Demographics including age, gender, and ethnicity.

StudyHabit: Weekly study time, absences, and tutoring data.

ParentalInvolvement: Parental education level and support.

ExtracurricularActivities: Participation in activities such as sports, music, and volunteering.

AcademicPerformance: GPA and class performance data.

Plus supporting tables like AbsenceWarnings and optional course/department info.

📈 Analytical Highlights
GPA trends by gender, parental education, and tutoring.

Effects of study time and absences on performance.

Ranking students by GPA and effort.

Identifying students with mismatched effort vs. outcomes.

Use of triggers to automate warnings for excessive absences.

Pairwise analysis of students with similar GPAs but different activity profiles.

📁 Files Included
schema.sql: SQL scripts for creating database tables.

student_analysis.sql: A collection of over 20 insightful SQL queries.

(Optional) Visualizations or dashboards (if added later).

🛠️ Tools Used
SQL (MySQL/PostgreSQL compatible)

(Optional) Tableau / Power BI / Jupyter Notebook for visualization
