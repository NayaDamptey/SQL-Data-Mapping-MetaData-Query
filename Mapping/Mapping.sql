USE [TargetDB]

SET IDENTITY_INSERT portfolio.[Status] OFF
SET IDENTITY_INSERT portfolio.[Sources] OFF
SET IDENTITY_INSERT portfolio.[Job_Candidates] OFF
GO
	
PRINT 'Now Insert into the status table'
GO
TRUNCATE TABLE Portfolio.[Status] 
INSERT INTO Portfolio.[Status] (Status_Name) 
SELECT DISTINCT [Status]
FROM [SQLMapping].Portfolio.Job_Seekers
GO


PRINT 'Now Insert into the Sources table'
GO
TRUNCATE TABLE Portfolio.[source] 
INSERT INTO Portfolio.Sources (Job_Candidates)
SELECT DISTINCT [source]
FROM [SQLMapping].Portfolio.Position
GO


PRINT 'Now Insert into the target Job Candidates table'
GO
TRUNCATE TABLE Portfolio.Job_Candidates 
INSERT INTO Portfolio.Job_Candidates 
		 (OccupationID
		 , CandidateID
		 , CompanyID
		 , PlacementFullName
		 , Notes
		 , Occupation
		 , UserID
		 , UserName
		 , [Start_Date]
		 , End_Date
		 , StatusID
		 , SourceID
		 )
SELECT 
    js.JobID				AS OccupationID
    ,js.ProspectID			AS CandidateID
    ,js.ClientID			AS CompanyID
    ,''					AS PlacementFullName -- This will be updated later
    ,js.Notes				AS Notes
    ,js. Job_Role			AS Occupation
    ,js.OwnerID				AS UserID
    ,c.Fullname				AS UserName
    ,js.[Start_Date]			AS [Start_Date]
    , js.End_Date			AS End_Date
    ,NULL				AS StatusID
    ,NULL				AS SourceID
FROM [SQLMapping].Portfolio.Job_Seekers js
LEFT JOIN [SQLMapping].Portfolio.Consultants c ON js.OwnerID =  c.ID
GO


PRINT 'Update placement fullnames from the source candidate table'
GO
UPDATE jc
SET PlacementFullName = CONCAT(ISNULL(c.First_Name,''), ' ', ISNULL(c.Middle_Name,''), ' ', ISNULL(c.Last_Name,''))
FROM Portfolio.Job_Candidates jc
JOIN [SQLMapping].Portfolio.Candidates c ON c.candidateID = jc.candidateID
GO


PRINT 'Update placement StatusIDs'
GO
UPDATE jc
SET StatusID = st.[statusID]
FROM Portfolio.Job_Candidates jc
JOIN [SQLMapping].Portfolio.Job_Seekers js ON js.[ProspectID] = jc.CandidateID AND js.[JobID] = jc.OccupationID
JOIN [TargetDB].Portfolio.[Status] st ON js.[status]  COLLATE Latin1_General_CI_AS  = st.[status_Name] 
GO


PRINT 'Update placement SourceIDs'
GO
UPDATE jc
SET SourceID = st.[sourceID]
FROM Portfolio.Job_Candidates jc
JOIN [SQLMapping].Portfolio.Job_Seekers js ON js.[ProspectID] = jc.CandidateID AND js.[JobID] = jc.OccupationID
JOIN [SQLMapping].Portfolio.Position p ON p.PositionID =  js.[JobID] 
JOIN [TargetDB].Portfolio.[Sources] st ON p.[Source]  COLLATE Latin1_General_CI_AS  = st.[sourceFrom] 
GO
