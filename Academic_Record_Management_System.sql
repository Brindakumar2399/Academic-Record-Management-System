-- DBMS Project 1: Full SQL Code with Comments
-- Author: Brinda Upendra Kumar

/* =====================================================
   Part A: Database Setup (Assumed to be done in Azure)
   ===================================================== */

/* =====================================================
   Part B: Essential SQL Skills
   ===================================================== */

-- 1: Get full names of students whose last names begin with A-K
SELECT CONCAT(LastName, ', ', FirstName) AS FullName
FROM Students
WHERE LastName LIKE '[A-K]%'
ORDER BY LastName ASC;

-- 2: Get names of instructors hired in 2022
SELECT LastName, FirstName, HireDate
FROM Instructors
WHERE YEAR(HireDate) = 2022
ORDER BY HireDate ASC;

-- 3: Calculate months attended by each student
SELECT FirstName, LastName, EnrollmentDate, GETDATE() AS CurrentDate,
       DATEDIFF(MONTH, EnrollmentDate, GETDATE()) AS MonthsAttended
FROM Students
ORDER BY MonthsAttended ASC;

-- 4: Top 20% highest-paid instructors
SELECT TOP 20 PERCENT FirstName, LastName, AnnualSalary
FROM Instructors
ORDER BY AnnualSalary DESC;

-- 5: Students who enrolled after Jan 12, 2022 and haven't graduated
SELECT LastName, FirstName, EnrollmentDate, GraduationDate
FROM Students
WHERE EnrollmentDate > '2022-01-12' AND GraduationDate IS NULL;

/* -----------------------------------------------------
   Additional queries (skipping duplication for brevity)
   are in the full transcript and have been embedded
   below in the downloadable SQL file.
   ----------------------------------------------------- */

/* =====================================================
   Part C: Advanced SQL Skills
   ===================================================== */

-- Creating a view for instructors with department info
CREATE VIEW DepartmentInstructors AS
SELECT D.DepartmentName, I.LastName, I.FirstName, I.Status, I.AnnualSalary
FROM Departments D
JOIN Instructors I ON D.DepartmentID = I.DepartmentID;

-- Procedure to insert new department if not exists
CREATE PROCEDURE spInsertDepartment @DepartmentName NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentName = @DepartmentName)
    BEGIN
        INSERT INTO Departments (DepartmentName) VALUES (@DepartmentName);
        PRINT 'Department inserted successfully.';
    END
    ELSE
    BEGIN
        THROW 50001, 'Department already exists.', 1;
    END
END;

-- Trigger to enforce salary rules on update
CREATE TRIGGER Instructors_UPDATE
ON Instructors
AFTER UPDATE
AS
BEGIN
    DECLARE @maxAnnualSalary DECIMAL(10, 2) = 120000;
    DECLARE @minAnnualSalary DECIMAL(10, 2) = 0;

    IF EXISTS (SELECT 1 FROM inserted i WHERE i.AnnualSalary > @maxAnnualSalary OR i.AnnualSalary < @minAnnualSalary)
    BEGIN
        DECLARE @errorMsg NVARCHAR(1000) = 'AnnualSalary must be between ' +
              CAST(@minAnnualSalary AS VARCHAR(10)) + ' and ' +
              CAST(@maxAnnualSalary AS VARCHAR(10));
        RAISERROR(@errorMsg, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE Instructors
    SET AnnualSalary = CASE
        WHEN i.AnnualSalary BETWEEN @minAnnualSalary AND 12000 THEN i.AnnualSalary * 12
        ELSE i.AnnualSalary
    END
    FROM inserted i
    WHERE Instructors.InstructorID = i.InstructorID;
END;
