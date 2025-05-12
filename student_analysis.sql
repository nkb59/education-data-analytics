
-- 1. Count of students in the database
SELECT COUNT(*) AS total_students FROM Student;

-- 2. Distribution of students by gender
SELECT gender, COUNT(*) AS count 
FROM Student 
GROUP BY gender 
ORDER BY count DESC;

-- 3. Find students with GPA above 3.0
SELECT student_id, gender, gpa, grade_class 
FROM Student 
WHERE gpa > 3.0 
ORDER BY gpa DESC;

-- 4. List students with their ethnicity names
SELECT s.student_id, s.gender, e.ethnicity_name, s.gpa
FROM Student s
JOIN Ethnicity e ON s.ethnicity_id = e.ethnicity_id
ORDER BY s.student_id;

-- 5. Count of students by grade class
SELECT grade_class, COUNT(*) AS student_count
FROM Student
GROUP BY grade_class
ORDER BY grade_class;

-- 6. Average GPA by parental education level
SELECT p.education_level, AVG(s.gpa) AS average_gpa, COUNT(*) AS student_count
FROM Student s
JOIN ParentalEducationLevel p ON s.parental_education_id = p.education_id
GROUP BY p.education_level
ORDER BY average_gpa DESC;

-- 7. Impact of study time on GPA
SELECT 
    CASE 
        WHEN study_time_weekly < 5 THEN 'Low (< 5 hrs)'
        WHEN study_time_weekly >= 5 AND study_time_weekly < 10 THEN 'Medium (5-10 hrs)'
        WHEN study_time_weekly >= 10 AND study_time_weekly < 15 THEN 'High (10-15 hrs)'
        ELSE 'Very High (15+ hrs)'
    END AS study_time_category,
    COUNT(*) AS student_count,
    AVG(gpa) AS average_gpa,
    MIN(gpa) AS min_gpa,
    MAX(gpa) AS max_gpa
FROM Student
GROUP BY study_time_category
ORDER BY AVG(study_time_weekly);

-- 8. Relationship between absences and GPA
SELECT 
    CASE 
        WHEN absences = 0 THEN 'No Absences'
        WHEN absences BETWEEN 1 AND 5 THEN '1-5'
        WHEN absences BETWEEN 6 AND 10 THEN '6-10'
        WHEN absences BETWEEN 11 AND 15 THEN '11-15'
        WHEN absences BETWEEN 16 AND 20 THEN '16-20'
        ELSE '20+'
    END AS absence_category,
    COUNT(*) AS student_count,
    AVG(gpa) AS average_gpa
FROM Student
GROUP BY absence_category
ORDER BY 
    CASE absence_category
        WHEN 'No Absences' THEN 1
        WHEN '1-5' THEN 2
        WHEN '6-10' THEN 3
        WHEN '11-15' THEN 4
        WHEN '16-20' THEN 5
        ELSE 6
    END;

-- 9. Effect of tutoring and parental support on GPA
SELECT 
    CASE 
        WHEN tutoring = 1 THEN 'Receives Tutoring'
        ELSE 'No Tutoring'
    END AS tutoring_status,
    parental_support,
    COUNT(*) AS student_count,
    AVG(gpa) AS average_gpa
FROM Student
GROUP BY tutoring_status, parental_support
ORDER BY average_gpa DESC;

-- 10. Course enrollment details with student and course information
SELECT e.enrollment_id, s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_code, c.course_name, e.semester, e.academic_year, e.grade
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id
ORDER BY e.academic_year, e.semester, s.last_name, s.first_name;

-- 11. Window Functions: Rank students by GPA within each department
SELECT 
    s.student_id, 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    d.department_name,
    s.gpa,
    RANK() OVER (PARTITION BY d.department_id ORDER BY s.gpa DESC) AS dept_rank
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON e.course_id = c.course_id
JOIN Department d ON c.department_id = d.department_id
GROUP BY s.student_id, student_name, d.department_id, d.department_name, s.gpa
ORDER BY d.department_name, dept_rank;

-- 13. List all students who have received tutoring
SELECT * FROM StudyHabit WHERE Tutoring = 1;

-- 14. Find the average GPA of male students
SELECT AVG(GPA) AS Average_GPA 
FROM AcademicPerformance 
JOIN Student ON AcademicPerformance.StudentID = Student.StudentID 
WHERE Gender = 'Male';

-- 15. Find the average study time per week for students grouped by parental education level
SELECT AVG(StudyTimeWeekly) AS Avg_StudyTime_Weekly, ParentalEducation 
FROM StudyHabit 
JOIN ParentalInvolvement ON StudyHabit.StudentID = ParentalInvolvement.StudentID 
GROUP BY ParentalEducation;

-- 16. Find all pairs of students with same ParentalEducation level and GPA diff < 0.5
SELECT s1.StudentID AS StudentID1, ap1.GPA AS GPA1, s2.StudentID AS StudentID2, ap2.GPA AS GPA2, p1.ParentalEducation 
FROM AcademicPerformance ap1 
JOIN ParentalInvolvement p1 ON ap1.StudentID = p1.StudentID 
JOIN AcademicPerformance ap2 ON ap1.StudentID < ap2.StudentID 
JOIN ParentalInvolvement p2 ON ap2.StudentID = p2.StudentID 
JOIN Student s1 ON ap1.StudentID = s1.StudentID 
JOIN Student s2 ON ap2.StudentID = s2.StudentID 
WHERE p1.ParentalEducation = p2.ParentalEducation AND ABS(ap1.GPA - ap2.GPA) < 0.5;

-- 17. Create a trigger to log a warning when a student has more than 15 absences
CREATE TABLE AbsenceWarnings (
    StudentID INT,
    Absences INT,
    WarningDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$ 
CREATE TRIGGER log_absence_warning 
AFTER INSERT ON StudyHabit 
FOR EACH ROW 
BEGIN 
    IF NEW.Absences > 15 THEN 
        INSERT INTO AbsenceWarnings (StudentID, Absences) 
        VALUES (NEW.StudentID, NEW.Absences); 
    END IF; 
END$$ 
DELIMITER ;

-- 18. Find students involved in two or more extracurricular activities
SELECT StudentID,
       (Extracurricular + Sports + Music + Volunteering) AS TotalActivities
FROM ExtracurricularActivities
WHERE (Extracurricular + Sports + Music + Volunteering) >= 2;

-- 19. Which gender has a higher proportion of students receiving tutoring?
SELECT Gender, COUNT(*) AS Tutored_Count
FROM Student s
JOIN StudyHabit sh ON s.StudentID = sh.StudentID
WHERE sh.Tutoring = 1
GROUP BY Gender
ORDER BY Tutored_Count DESC;

-- 20. Which parental support level is associated with the highest average GPA?
SELECT ParentalSupport, AVG(GPA) AS Avg_GPA
FROM ParentalInvolvement pi
JOIN AcademicPerformance ap ON pi.StudentID = ap.StudentID
GROUP BY ParentalSupport
ORDER BY Avg_GPA DESC;

-- 21. Categorize students by GPA into performance tiers
SELECT StudentID, GPA,
CASE 
    WHEN GPA >= 3.5 THEN 'Excellent'
    WHEN GPA >= 3.0 THEN 'Good'
    WHEN GPA >= 2.0 THEN 'Average'
    ELSE 'Poor' 
END AS PerformanceCategory
FROM AcademicPerformance;

-- 22. Rank Students by GPA and Study Time Combined 
SELECT 
  s.StudentID,
  ap.GPA,
  sh.StudyTimeWeekly,
  ROUND(ap.GPA + (sh.StudyTimeWeekly * 0.1), 2) AS composite_score
FROM Student s
JOIN AcademicPerformance ap ON s.StudentID = ap.StudentID
JOIN StudyHabit sh ON s.StudentID = sh.StudentID
ORDER BY composite_score DESC
LIMIT 10;

-- 23. Compare GPA Distribution Between Tutored and Non-Tutored Students
SELECT 
  CASE 
    WHEN sh.Tutoring = 1 THEN 'Tutored'
    ELSE 'Not Tutored'
  END AS tutoring_group,
  COUNT(*) AS student_count,
  ROUND(AVG(ap.GPA), 2) AS avg_gpa,
  ROUND(STDDEV(ap.GPA), 2) AS gpa_stddev,
  MIN(ap.GPA) AS min_gpa,
  MAX(ap.GPA) AS max_gpa
FROM StudyHabit sh
JOIN AcademicPerformance ap ON sh.StudentID = ap.StudentID
GROUP BY tutoring_group
ORDER BY avg_gpa DESC;

-- 24. Students with high study time but low GPA
SELECT 
  s.StudentID,
  sh.StudyTimeWeekly,
  ap.GPA,
  ROUND(ap.GPA / NULLIF(sh.StudyTimeWeekly, 0), 2) AS gpa_efficiency
FROM Student s
JOIN StudyHabit sh ON s.StudentID = sh.StudentID
JOIN AcademicPerformance ap ON s.StudentID = ap.StudentID
WHERE sh.StudyTimeWeekly >= 10 AND ap.GPA < 2.5
ORDER BY gpa_efficiency ASC;

-- 25. Students with low parental support but GPA above group average
SELECT 
  s.StudentID,
  ap.GPA,
  pi.ParentalSupport,
  group_stats.avg_gpa AS group_avg_gpa
FROM Student s
JOIN ParentalInvolvement pi ON s.StudentID = pi.StudentID
JOIN AcademicPerformance ap ON s.StudentID = ap.StudentID
JOIN (
  SELECT pi.ParentalSupport, AVG(ap.GPA) AS avg_gpa
  FROM ParentalInvolvement pi
  JOIN AcademicPerformance ap ON pi.StudentID = ap.StudentID
  GROUP BY pi.ParentalSupport
) group_stats ON pi.ParentalSupport = group_stats.ParentalSupport
WHERE pi.ParentalSupport = 'Low' AND ap.GPA > group_stats.avg_gpa
ORDER BY ap.GPA DESC;

-- 26. Pairs of students with same parental education, similar GPA, but different activity profiles
SELECT 
  s1.StudentID AS Student1,
  s2.StudentID AS Student2,
  pi1.ParentalEducation,
  ap1.GPA AS GPA1,
  ap2.GPA AS GPA2,
  ROUND(ABS(ap1.GPA - ap2.GPA), 2) AS GPA_Difference,
  CONCAT(
    'S1: E', ea1.Extracurricular, ' S', ea1.Sports, 
    ' M', ea1.Music, ' V', ea1.Volunteering,
    ' | S2: E', ea2.Extracurricular, ' S', ea2.Sports, 
    ' M', ea2.Music, ' V', ea2.Volunteering
  ) AS ActivityComparison
FROM Student s1
JOIN Student s2 ON s1.StudentID < s2.StudentID
JOIN ParentalInvolvement pi1 ON s1.StudentID = pi1.StudentID
JOIN ParentalInvolvement pi2 ON s2.StudentID = pi2.StudentID
  AND pi1.ParentalEducation = pi2.ParentalEducation
JOIN AcademicPerformance ap1 ON s1.StudentID = ap1.StudentID
JOIN AcademicPerformance ap2 ON s2.StudentID = ap2.StudentID
  AND ABS(ap1.GPA - ap2.GPA) <= 0.2
JOIN ExtracurricularActivities ea1 ON s1.StudentID = ea1.StudentID
JOIN ExtracurricularActivities ea2 ON s2.StudentID = ea2.StudentID
WHERE 
  (ea1.Extracurricular <> ea2.Extracurricular OR
   ea1.Sports <> ea2.Sports OR
   ea1.Music <> ea2.Music OR
   ea1.Volunteering <> ea2.Volunteering)
ORDER BY GPA_Difference;
