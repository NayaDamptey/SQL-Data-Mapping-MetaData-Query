
USE TargetDB

DROP TABLE portfolio.[Status]
PRINT 'Create Status table'
CREATE TABLE portfolio.[Status] (
    StatusID INT PRIMARY KEY IDENTITY(1,1),
    Status_Name VARCHAR(50)
)


DROP TABLE portfolio.[Sources]
PRINT 'Create Sources table'
CREATE TABLE portfolio.Sources (
    SourceID INT PRIMARY KEY IDENTITY(1,1),
    SourceFrom VARCHAR(50)
)


DROP TABLE portfolio.[Job_Candidates]
PRINT 'Create Job_Candidates table'
CREATE TABLE portfolio.Job_Candidates (
    PlacementID INT PRIMARY KEY IDENTITY(1,1),
    OccupationID INT,
    CandidateID INT,
    CompanyID INT,
    PlacementFullName NVARCHAR(255),
    Notes NVARCHAR(MAX),
    Occupation VARCHAR(50),
    UserID INT,
    UserName NVARCHAR(255),
    [Start_Date] DATE,
    [End_Date] DATE,
    StatusID INT,
    SourceID INT,
    FOREIGN KEY (StatusID) REFERENCES portfolio.[Status](StatusID),
    FOREIGN KEY (SourceID) REFERENCES portfolio.[Sources] (SourceID)
)
GO

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
