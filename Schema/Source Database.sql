PRINT 'This scripts creates the Database and defines the schema for the source data'

-- Drop the database if it already exists so we can build and rebuild whenever the script is run
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'SQLMapping')
BEGIN
    ALTER DATABASE SQLMapping SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE SQLMapping
END

-- Create the database with custom options
CREATE DATABASE SQLMapping
COLLATE Latin1_General_100_CI_AS_SC_UTF8

-- Use the database
USE SQLMapping

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Portfolio')
BEGIN
    EXEC('CREATE SCHEMA Portfolio AUTHORIZATION dbo')
END


DROP TABLE IF EXISTS Portfolio.Job_Seekers
DROP TABLE IF EXISTS Portfolio.Candidates
DROP TABLE IF EXISTS Portfolio.Position
DROP TABLE IF EXISTS Portfolio.Consultants

-- Create table: Consultants
CREATE TABLE Portfolio.Consultants (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Fullname VARCHAR(255),
    [Role] VARCHAR(100)
)
GO

-- Create table: Candidates
CREATE TABLE Portfolio.Candidates (
    CandidateID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50),
	Email NVARCHAR(255),
	[Address] NVARCHAR(MAX),
    DOB DATE,
    Gender VARCHAR(50),
    Candidate_OwnerID INT,
    Notes NVARCHAR(MAX),
    Active BIT,
    FOREIGN KEY (Candidate_OwnerID) REFERENCES Portfolio.Consultants(ID)
)
GO

-- Create table: Position
CREATE TABLE Portfolio.Position (
    PositionID INT PRIMARY KEY,
    Position_Name VARCHAR(255),
    [Role] VARCHAR(100),
    Client VARCHAR(255),
    Worktype VARCHAR(100),
    Contact_ID INT,
    Job_Owner INT,
    [Start_Date] NVARCHAR(100),
    End_Date NVARCHAR(100),
    [Source] VARCHAR(255),
    [Location] VARCHAR(255),
    Active BIT,
    FOREIGN KEY (Job_Owner) REFERENCES Portfolio.Consultants(ID)
)
GO


-- Create table: Job_Seekers
CREATE TABLE Portfolio.Job_Seekers (
    JobSeekerID INT PRIMARY KEY,
    JobID INT,
    ProspectID INT,
    ClientID INT,
    Job_Role VARCHAR(100),
    [Start_Date] DATE,
    End_Date DATE,
    [Status] VARCHAR(100),
    OwnerID INT,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (OwnerID) REFERENCES Portfolio.Consultants(ID)
)
GO


---------------------------------------------------------------------------
---------------------------------------------------------------------------