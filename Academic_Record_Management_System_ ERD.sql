-- ERD Schema Definition: MyBookDB

-- Drop the database if it exists
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'MyBookDB')
DROP DATABASE MyBookDB
GO

-- Create database and switch to it
CREATE DATABASE MyBookDB
GO
USE MyBookDB
GO

-- Users table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

-- Books table
CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255) UNIQUE
);

-- Downloads (associative entity for many-to-many)
CREATE TABLE Downloads (
    DownloadID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Filename VARCHAR(255),
    DownloadDate DATETIME2 DEFAULT GETDATE()
);

-- Indexes for performance
CREATE INDEX IX_Downloads_UserID ON Downloads(UserID);
CREATE INDEX IX_Downloads_BookID ON Downloads(BookID);
