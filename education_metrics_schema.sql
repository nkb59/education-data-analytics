-- Student Table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY NOT NULL UNIQUE,
    Age INT,
    Gender VARCHAR(20),
    Ethnicity VARCHAR(50)
);

-- StudyHabit Table
CREATE TABLE StudyHabit (
    HabitID INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    StudentID INT NOT NULL UNIQUE,
    StudyTimeWeekly FLOAT,
    Absences INT,
    Tutoring INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- ParentalInvolvement Table
CREATE TABLE ParentalInvolvement (
    InvolvementID INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    StudentID INT NOT NULL UNIQUE,
    ParentalSupport VARCHAR(20),
    ParentalEducation VARCHAR(50),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- ExtracurricularActivities Table
CREATE TABLE ExtracurricularActivities (
    ActivityID INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    StudentID INT NOT NULL UNIQUE,
    Extracurricular INT,
    Sports INT,
    Music INT,
    Volunteering INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);

-- AcademicPerformance Table
CREATE TABLE AcademicPerformance (
    PerformanceID INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    StudentID INT NOT NULL UNIQUE,
    GPA FLOAT,
    GradeClass VARCHAR(5),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);
