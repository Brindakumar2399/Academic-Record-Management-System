---------------------------------------------------
-- PART A: Database Setup
---------------------------------------------------
-- (Initial database setup steps were descriptive, no code)

---------------------------------------------------
-- PART B: Essential SQL Skills
---------------------------------------------------

-- 1. Select full names of students with last names A–K
SELECT  
    CONCAT(LastName, ', ', FirstName) AS FullName -- Format: LastName, FirstName
FROM Students
WHERE LastName LIKE '[A-K]%' -- Filter last names A–K
ORDER BY LastName ASC; -- Sort alphabetically

-- 2. Instructors hired in 2022
SELECT  
    LastName, FirstName, HireDate
FROM Instructors
WHERE YEAR(HireDate) = 2022 -- Hired in 2022
ORDER BY HireDate ASC;

-- 3. Students with months attended
SELECT  
    FirstName, LastName, EnrollmentDate,
    GETDATE() AS CurrentDate, -- Current system date
    DATEDIFF(MONTH, EnrollmentDate, GETDATE()) AS MonthsAttended
FROM Students
ORDER BY MonthsAttended ASC;

-- 4. Top 20% instructors by salary
SELECT TOP 20 PERCENT  
    FirstName, LastName, AnnualSalary
FROM Instructors
ORDER BY AnnualSalary DESC;

-- 6. Students enrolled after Jan 2022 without graduation date
SELECT  
    LastName, FirstName, EnrollmentDate, GraduationDate
FROM Students
WHERE EnrollmentDate > '2022-01-12'
  AND GraduationDate IS NULL;

-- 7. Tuition calculation
SELECT  
    FullTimeCost, PerUnitCost, 12 AS Units,
    PerUnitCost * 12 AS TotalPerUnitCost,
    FullTimeCost + (PerUnitCost * 12) AS TotalTuition
FROM Tuition;

-- 8. Instructors with their courses (or "No courses assigned")
SELECT  
    I.LastName, I.FirstName,
    COALESCE(C.CourseDescription, 'No courses assigned') AS CourseDescription
FROM Instructors I
LEFT JOIN Courses C ON I.InstructorID = C.InstructorID
ORDER BY I.LastName, I.FirstName;

-- 9. Graduated vs Undergrad students
SELECT 'GRADUATED' AS Status, FirstName, LastName, EnrollmentDate, GraduationDate
FROM Students
WHERE GraduationDate IS NOT NULL
UNION
SELECT 'UNDERGRAD' AS Status, FirstName, LastName, EnrollmentDate, GraduationDate
FROM Students
WHERE GraduationDate IS NULL
ORDER BY EnrollmentDate;

-- 10. Courses taught outside instructor’s department
SELECT  
    InstDept.DepartmentName AS InstructorDept,
    I.LastName, I.FirstName, C.CourseDescription,
    CourseDept.DepartmentName AS CourseDept
FROM Courses C
JOIN Instructors I ON C.InstructorID = I.InstructorID
JOIN Departments CourseDept ON C.DepartmentID = CourseDept.DepartmentID
JOIN Departments InstDept ON I.DepartmentID = InstDept.DepartmentID
WHERE CourseDept.DepartmentID != InstDept.DepartmentID;

-- 11. Department stats
SELECT  
    D.DepartmentName,
    COUNT(I.InstructorID) AS InstructorCount,
    MAX(I.AnnualSalary) AS HighestSalary
FROM Departments D
LEFT JOIN Instructors I ON D.DepartmentID = I.DepartmentID
GROUP BY D.DepartmentName
ORDER BY InstructorCount DESC;

-- 12. Instructor workload summary
SELECT  
    CONCAT_WS(' ', COALESCE(I.FirstName, ''), I.LastName) AS InstructorName,
    COUNT(C.CourseID) AS NumberOfCourses,
    SUM(C.CourseUnits) AS TotalCourseUnits
FROM Instructors I
JOIN Courses C ON I.InstructorID = C.InstructorID
GROUP BY CONCAT_WS(' ', COALESCE(I.FirstName, ''), I.LastName)
ORDER BY TotalCourseUnits DESC;

-- 13. Total course units per student
SELECT  
    S.StudentID, SUM(C.CourseUnits) AS TotalCourseUnits
FROM Students S
JOIN StudentCourses SC ON S.StudentID = SC.StudentID
JOIN Courses C ON SC.CourseID = C.CourseID
GROUP BY S.StudentID
ORDER BY TotalCourseUnits DESC;

-- 14. Courses taught by part-time instructors
SELECT  
    CONCAT(COALESCE(I.LastName, ''), ', ', COALESCE(I.FirstName, '')) AS InstructorName,
    COUNT(C.CourseID) AS TotalCourses
FROM Instructors I
JOIN Courses C ON I.InstructorID = C.InstructorID
WHERE I.Status = 'P'
GROUP BY I.LastName, I.FirstName WITH ROLLUP;

-- 15. Instructors with above-average salary
SELECT LastName, FirstName, AnnualSalary
FROM Instructors
WHERE AnnualSalary > (SELECT AVG(AnnualSalary) FROM Instructors)
ORDER BY AnnualSalary DESC;

-- 16. Instructors with no courses
SELECT LastName, FirstName
FROM Instructors I
WHERE NOT EXISTS (
    SELECT 1 FROM Courses C WHERE C.InstructorID = I.InstructorID
);

-- 17. Students taking more than one class
SELECT  
    S.LastName, S.FirstName,
    COUNT(SC.StudentID) AS NumberOfCourses
FROM Students S
JOIN StudentCourses SC ON S.StudentID = SC.StudentID
WHERE S.StudentID IN (
    SELECT StudentID FROM StudentCourses
    GROUP BY StudentID HAVING COUNT(*) > 1
)
GROUP BY S.LastName, S.FirstName
ORDER BY S.LastName, S.FirstName;

-- 18. Full-time students with tuition calculation (CTE)
WITH FullTimeStudents AS (
    SELECT SC.StudentID, SUM(C.CourseUnits) AS TotalUnits
    FROM StudentCourses SC
    JOIN Courses C ON SC.CourseID = C.CourseID
    GROUP BY SC.StudentID
    HAVING SUM(C.CourseUnits) > 9
)
SELECT FT.StudentID, FT.TotalUnits,
       T.FullTimeCost + (T.PerUnitCost * FT.TotalUnits) AS Tuition
FROM FullTimeStudents FT
CROSS JOIN Tuition T;

-- 19. Insert instructors
INSERT INTO Instructors
VALUES ('Benedict', 'Grace', 'P', 0, GETDATE(), 78000.00, 9),
       ('James', NULL, 'F', 1, GETDATE(), 46000.00, 9);

-- 20. Update salary for one instructor
UPDATE Instructors
SET AnnualSalary = 82000.00
WHERE LastName = 'Benedict' AND FirstName = 'Grace';

-- 21. Increase salaries in Education dept by 5%
UPDATE I
SET AnnualSalary = AnnualSalary * 1.05
FROM Instructors I
JOIN Departments D ON I.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Education';

-- 22. Create GradStudents table
CREATE TABLE GradStudents (
    StudentID INT PRIMARY KEY,
    LastName VARCHAR(25) NOT NULL,
    FirstName VARCHAR(25) NOT NULL,
    EnrollmentDate DATE NOT NULL,
    GraduationDate DATE NULL
);

-- 24. Monthly salary variations
SELECT  
    AnnualSalary / 12 AS MonthlySalary,
    CAST(AnnualSalary / 12 AS DECIMAL(10,1)) AS MonthlySalaryWithDecimal,
    CONVERT(INT, AnnualSalary / 12) AS MonthlySalaryAsInteger_Convert,
    CAST(AnnualSalary / 12 AS INT) AS MonthlySalaryAsInteger_Cast
FROM Instructors;

---------------------------------------------------
-- PART C: Advanced SQL Skills
---------------------------------------------------

-- 1. Tuition by status
WITH StudentCourseUnits AS (
    SELECT SC.StudentID, SUM(C.CourseUnits) AS TotalUnits
    FROM StudentCourses SC
    JOIN Courses C ON SC.CourseID = C.CourseID
    GROUP BY SC.StudentID
)
SELECT SCU.StudentID, SCU.TotalUnits,
       IIF(SCU.TotalUnits > 9, 'Fulltime', 'Parttime') AS StudentStatus,
       IIF(SCU.TotalUnits > 9, T.FullTimeCost, T.PartTimeCost) + (SCU.TotalUnits * T.PerUnitCost) AS TotalTuition
FROM StudentCourseUnits SCU
CROSS JOIN Tuition T;

-- 2. View: DepartmentInstructors
CREATE VIEW DepartmentInstructors AS
SELECT D.DepartmentName, I.LastName, I.FirstName, I.Status, I.AnnualSalary
FROM Departments D
JOIN Instructors I ON D.DepartmentID = I.DepartmentID;

-- 3. View: StudentCoursesMin
CREATE VIEW StudentCoursesMin AS
SELECT S.FirstName, S.LastName, C.CourseNumber, C.CourseDescription, C.CourseUnits
FROM Students S
JOIN StudentCourses SC ON S.StudentID = SC.StudentID
JOIN Courses C ON SC.CourseID = C.CourseID;

-- 4. Query from StudentCoursesMin
SELECT LastName, FirstName, CourseDescription
FROM StudentCoursesMin
WHERE CourseUnits = 3
ORDER BY LastName, FirstName;

-- 5. View: StudentCoursesSummary
CREATE VIEW StudentCoursesSummary AS
SELECT LastName, FirstName,
       COUNT(*) AS CourseCount,
       SUM(CourseUnits) AS UnitsTotal
FROM StudentCoursesMin
WHERE CourseUnits > 9
GROUP BY LastName, FirstName;

-- 6. Count undergraduates
DECLARE @UndergradCount INT;
SELECT @UndergradCount = COUNT(*)
FROM Students
WHERE GraduationDate IS NULL;
IF @UndergradCount >= 100
    PRINT 'The number of undergrad students is greater than or equal to 100';
ELSE
    PRINT 'The number of undergrad students is less than 100';

-- 7. Stored procedure: spInsertDepartment
CREATE PROCEDURE spInsertDepartment @DepartmentName NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentName = @DepartmentName)
        INSERT INTO Departments (DepartmentName) VALUES (@DepartmentName);
    ELSE
        THROW 50001, 'Department already exists.', 1;
END;

-- 8. Temporary table and salary adjustment
CREATE TABLE #ParttimeInstructors2020 (
    InstructorID INT, LastName NVARCHAR(50), FirstName NVARCHAR(50),
    Status CHAR(1), HireDate DATE, AnnualSalary DECIMAL(10,2)
);
INSERT INTO #ParttimeInstructors2020
SELECT InstructorID, LastName, FirstName, Status, HireDate, AnnualSalary
FROM Instructors
WHERE Status = 'P' AND YEAR(HireDate) = 2020;

DECLARE @AvgSalary DECIMAL(10,2);
SELECT @AvgSalary = AVG(AnnualSalary) FROM #ParttimeInstructors2020;
WHILE @AvgSalary < 40000
BEGIN
    UPDATE #ParttimeInstructors2020
    SET AnnualSalary = AnnualSalary + 50
    WHERE AnnualSalary < 41000;
    SELECT @AvgSalary = AVG(AnnualSalary) FROM #ParttimeInstructors2020;
END;

SELECT FirstName, LastName, AnnualSalary FROM #ParttimeInstructors2020;
DROP TABLE #ParttimeInstructors2020;

-- 9. Cursor example
DECLARE @CourseID INT, @StudentCount INT;
DECLARE courseCursor CURSOR FOR
SELECT CourseID, COUNT(StudentID) FROM StudentCourses GROUP BY CourseID;

OPEN courseCursor;
FETCH NEXT FROM courseCursor INTO @CourseID, @StudentCount;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF @StudentCount < 5
        PRINT 'Too few students in course ' + CAST(@CourseID AS NVARCHAR(10));
    ELSE IF @StudentCount > 10
        PRINT 'Too many students in course ' + CAST(@CourseID AS NVARCHAR(10));
    FETCH NEXT FROM courseCursor INTO @CourseID, @StudentCount;
END
CLOSE courseCursor;
DEALLOCATE courseCursor;

-- 10. Functions fnStudentUnits and fnTuition
IF OBJECT_ID('fnStudentUnits', 'FN') IS NOT NULL DROP FUNCTION fnStudentUnits;
GO
CREATE FUNCTION fnStudentUnits (@StudentID INT) RETURNS INT
AS BEGIN
    DECLARE @TotalUnits INT;
    SELECT @TotalUnits = SUM(c.CourseUnits)
    FROM StudentCourses sc
    JOIN Courses c ON sc.CourseID = c.CourseID
    WHERE StudentID = @StudentID;
    RETURN @TotalUnits;
END;
GO

IF OBJECT_ID('fnTuition', 'FN') IS NOT NULL DROP FUNCTION fnTuition;
GO
CREATE FUNCTION fnTuition (@StudentID INT) RETURNS DECIMAL(10,2)
AS BEGIN
    DECLARE @TotalUnits INT = dbo.fnStudentUnits(@StudentID);
    RETURN CASE
        WHEN @TotalUnits > 9 THEN (SELECT FullTimeCost FROM Tuition) + ((SELECT PerUnitCost FROM Tuition) * @TotalUnits)
        ELSE (SELECT PartTimeCost FROM Tuition) + ((SELECT PerUnitCost FROM Tuition) * @TotalUnits)
    END;
END;
GO

SELECT S.StudentID, dbo.fnStudentUnits(S.StudentID) AS TotalUnits,
       dbo.fnTuition(S.StudentID) AS Tuition
FROM Students S
JOIN StudentCourses SC ON S.StudentID = SC.StudentID
JOIN Courses C ON SC.CourseID = C.CourseID
WHERE C.CourseUnits > 0;

-- 11. Stored procedure: spInsertInstructor
CREATE PROCEDURE spInsertInstructor
    @LastName VARCHAR(50), @FirstName VARCHAR(50),
    @Status CHAR(1), @DepartmentChairman BIT,
    @AnnualSalary DECIMAL(10,2), @DepartmentID INT
AS
BEGIN
    IF @AnnualSalary < 0
        RAISERROR('AnnualSalary cannot be negative.', 16, 1);
    ELSE
        INSERT INTO Instructors (LastName, FirstName, Status, DepartmentChairman, AnnualSalary, DepartmentID, HireDate)
        VALUES (@LastName, @FirstName, @Status, @DepartmentChairman, @AnnualSalary, @DepartmentID, GETDATE());
END;
GO

-- 12. Trigger: validate salary
CREATE TRIGGER Instructors_UPDATE
ON Instructors
AFTER UPDATE
AS
BEGIN
    DECLARE @maxAnnualSalary DECIMAL(10,2) = 120000;
    DECLARE @minAnnualSalary DECIMAL(10,2) = 0;

    IF EXISTS (SELECT 1 FROM inserted WHERE AnnualSalary > @maxAnnualSalary OR AnnualSalary < @minAnnualSalary)
    BEGIN
        RAISERROR('AnnualSalary out of range.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
        UPDATE I
        SET AnnualSalary = CASE WHEN i.AnnualSalary BETWEEN @minAnnualSalary AND 12000
                                THEN i.AnnualSalary * 12 ELSE i.AnnualSalary END
        FROM Instructors I
        JOIN inserted i ON I.InstructorID = i.InstructorID;
END;

---------------------------------------------------
-- PART D: Database Design (Book DB Example)
---------------------------------------------------

-- 3. Create MyBookDB
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'MyBookDB')
    DROP DATABASE MyBookDB;
GO
CREATE DATABASE MyBookDB;
GO
USE MyBookDB;
GO

-- Tables
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255) UNIQUE
);

CREATE TABLE Downloads (
    DownloadID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Filename VARCHAR(255),
    DownloadDate DATETIME2 DEFAULT GETDATE()
);

-- Indexes
CREATE INDEX IX_Downloads_UserID ON Downloads(UserID);
CREATE INDEX IX_Downloads_BookID ON Downloads(BookID);

-- 4. Insert Users and Books
INSERT INTO Users (Email, FirstName, LastName)
VALUES ('user1@example.com', 'John', 'Doe'),
       ('user2@example.com', 'Jane', 'Smith');

INSERT INTO Books (Name)
VALUES ('The Lord of the Rings'), ('Pride and Prejudice');

INSERT INTO Downloads (UserID, BookID, Filename)
VALUES (1, 1, 'LOTR_ebook.pdf'),
       (2, 1, 'Pride_and_Prejudice.epub'),
       (2, 2, 'Pride_and_Prejudice_Audiobook.mp3');

-- Query join
SELECT u.Email, u.FirstName, u.LastName, b.Name, d.Filename, d.DownloadDate
FROM Users u
INNER JOIN Downloads d ON u.UserID = d.UserID
INNER JOIN Books b ON d.BookID = b.BookID
ORDER BY u.Email DESC, b.Name ASC;

-- 5. Alter table Books to add columns
ALTER TABLE Books
ADD Price DECIMAL(5,2) CONSTRAINT DF_Book_DefaultPrice DEFAULT (59.50),
    AddedDate DATETIME2 DEFAULT GETDATE();

-- 6. Modify Users Email column length
ALTER TABLE Users DROP CONSTRAINT UQ__Users__A9D10534D66D8623;
ALTER TABLE Users ALTER COLUMN Email VARCHAR(25);
ALTER TABLE Users ADD CONSTRAINT UQ__Users__A9D10534D66D8623 UNIQUE (Email);

-- 7. Unique constraint + update fail test
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);
UPDATE Users SET Email = 'user1@example.com' WHERE UserID = 2;
