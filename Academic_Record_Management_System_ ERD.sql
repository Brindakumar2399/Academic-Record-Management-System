-- ========================================
-- Academic Record Management System ERD
-- ========================================

-- Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    DepartmentChairman VARCHAR(100)
);

-- Instructors
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Status VARCHAR(50),
    HireDate DATE,
    AnnualSalary DECIMAL(10,2),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    DepartmentID INT,
    InstructorID INT,
    CourseNumber VARCHAR(20),
    CourseDescription TEXT,
    CourseUnits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    EnrollmentDate DATE,
    GraduationDate DATE
);

-- Tuition
CREATE TABLE Tuition (
    TuitionID INT PRIMARY KEY,
    PartTimeCost DECIMAL(10,2),
    FullTimeCost DECIMAL(10,2),
    PerUnitCost DECIMAL(10,2)
);

-- Associative Entity: StudentCourses
CREATE TABLE StudentCourses (
    StudentCourseID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- ========================================
-- Book Download Subsystem
-- ========================================

-- Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

-- Books
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    BookName VARCHAR(255)
);

-- Downloads (Many-to-Many relationship between Users and Books)
CREATE TABLE Downloads (
    DownloadID INT PRIMARY KEY,
    UserID INT,
    BookID INT,
    Filename VARCHAR(255),
    DownloadDateTime DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
