USE SQLMapping

/*
 Overview:
The overall goal of this project is to migrate placement data from the source database to the target database. 
However, the migration process is complicated by schema differences between the two databases. 
This necessitate a thorough analysis and careful mapping to ensure that data is migrated accurately and without integrity issues.

SQL Script Goal:
For this script, the objective is to identify the specific column or table within the source database that contains the UserName data, 
which needs to be mapped and populated into the corresponding field within the target database.
Based on the provided project diagram, mappings indicate that the UserName data is stored in the Consultant table in the source database.
However, in scenarios where there is limited familiarity with the source schema,
it becomes imperative to first conduct a thorough analysis to identify the exact location of the full name of consultants within the source system.

This investigation is crucial to ensure the correct identification and mapping of the UserName field,
ultimately ensuring the accuracy of data migration to the appropriate field in the target system's placement table.

Investigation Strategy:
To address this issue, the stored procedure created below will be executed to identify tables or columns that are likely to contain username data. 
The procedure searches for relevant columns by looking for common keywords typically associated with user information.
It will focus on table and column names that are indicative of user-related fields, ensuring accurate mapping of the source to target.

**BONUS**  If you already know the expected number of rows, there is a third procedure to identify fields in a source that match your record ccount expectations.
By checking the column and table names and the number of records expected, you can quickly identify the fields that are most likely relevant for accurate mapping.
*/

DROP PROCEDURE Portfolio.FindDBTablesByName

PRINT 'Create a stored procedure that finds tables by name patterns'
CREATE PROCEDURE portfolio.FindDBTablesByName
    @TableNamePattern NVARCHAR(255)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL = '
    SELECT  
        sc.TABLE_NAME AS [Table Name],
        sc.TABLE_SCHEMA AS [Schema],
        sc.COLUMN_NAME AS [Column Name],
        CASE 
            WHEN sc.DATA_TYPE IN (''varchar'', ''nvarchar'') AND sc.CHARACTER_MAXIMUM_LENGTH <> -1 
                THEN sc.DATA_TYPE + '' ('' + CAST(sc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(20)) + '')''
            WHEN sc.DATA_TYPE IN (''varchar'', ''nvarchar'') AND sc.CHARACTER_MAXIMUM_LENGTH = -1
                THEN sc.DATA_TYPE + ''(MAX)''
            ELSE sc.DATA_TYPE 
        END AS [Data Type],
        sc.ORDINAL_POSITION AS [Column Number],
        si.rows AS [Number of Rows]
    FROM INFORMATION_SCHEMA.COLUMNS sc
    LEFT JOIN sys.sysobjects so ON sc.TABLE_NAME = so.name AND so.xtype = ''U''
    INNER JOIN sys.sysindexes si ON so.id = si.id AND si.indid IN (0, 1) AND si.rows <> 0
    WHERE sc.TABLE_NAME LIKE @TableNamePattern
    '

    EXEC sp_executesql @SQL, N'@TableNamePattern NVARCHAR(255)', @TableNamePattern
END


EXEC Portfolio.FindDBTablesByName @TableNamePattern = '%Consul%'



--The nect bit of code will also search the DB schema for column names
DROP PROCEDURE Portfolio.FindDBColumnsByName

PRINT 'Create a stored procedure that finds columns by name patterns'
CREATE PROCEDURE portfolio.FindDBColumnsByName
    @ColumnNamePattern NVARCHAR(255)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL = '
    SELECT  
        sc.TABLE_NAME AS [Table Name],
        sc.TABLE_SCHEMA AS [Schema],
        sc.COLUMN_NAME AS [Column Name],
        CASE 
            WHEN sc.DATA_TYPE IN (''varchar'', ''nvarchar'') AND sc.CHARACTER_MAXIMUM_LENGTH <> -1 
                THEN sc.DATA_TYPE + '' ('' + CAST(sc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(20)) + '')''
            WHEN sc.DATA_TYPE IN (''varchar'', ''nvarchar'') AND sc.CHARACTER_MAXIMUM_LENGTH = -1
                THEN sc.DATA_TYPE + ''(MAX)''
            ELSE sc.DATA_TYPE 
        END AS [Data Type],
        sc.ORDINAL_POSITION AS [Column Number],
        si.rows AS [Number of Rows]
    FROM INFORMATION_SCHEMA.COLUMNS sc
    LEFT JOIN sys.sysobjects so ON sc.TABLE_NAME = so.name AND so.xtype = ''U''
    INNER JOIN sys.sysindexes si ON so.id = si.id AND si.indid IN (0, 1) AND si.rows <> 0
    WHERE sc.COLUMN_NAME LIKE @ColumnNamePattern
    '

    EXEC sp_executesql @SQL, N'@ColumnNamePattern NVARCHAR(255)', @ColumnNamePattern
END


EXEC Portfolio.FindDBColumnsByName @ColumnNamePattern = '%Name%'


-------BONUS--------

DROP PROCEDURE IF EXISTS Portfolio.FindDBTandCByRowCount

PRINT 'This a combined strategy od the stored procedures created above to find tables and columns by name patterns and filter by row count for better accuracy'

CREATE PROCEDURE portfolio.FindDBTandCByRowCount
    @TableNamePattern NVARCHAR(255),
    @ColumnNamePattern NVARCHAR(255),
    @MaxRows INT
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    SELECT  
        sc.TABLE_NAME AS [Table Name],
        sc.TABLE_SCHEMA AS [Schema],
        sc.COLUMN_NAME AS [Column Name],
        CASE 
            WHEN sc.DATA_TYPE IN (''varchar'', ''nvarchar'') AND sc.CHARACTER_MAXIMUM_LENGTH <> -1 
                THEN sc.DATA_TYPE + '' ('' + CAST(sc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(20)) + '')''
            WHEN sc.DATA_TYPE IN (''varchar'', ''nvarchar'') AND sc.CHARACTER_MAXIMUM_LENGTH = -1
                THEN sc.DATA_TYPE + ''(MAX)''
            ELSE sc.DATA_TYPE 
        END AS [Data Type],
        sc.ORDINAL_POSITION AS [Column Number],
        si.rows AS [Number of Rows]
    FROM INFORMATION_SCHEMA.COLUMNS sc
    LEFT JOIN sys.sysobjects so ON sc.TABLE_NAME = so.name AND so.xtype = ''U''
    INNER JOIN sys.sysindexes si ON so.id = si.id AND si.indid IN (0, 1) AND si.rows < @MaxRows
    WHERE sc.TABLE_NAME LIKE @TableNamePattern
    AND sc.COLUMN_NAME LIKE @ColumnNamePattern
    '

    -- Executing the dynamic SQL with the parameters
    EXEC sp_executesql @SQL, 
        N'@TableNamePattern NVARCHAR(255), @ColumnNamePattern NVARCHAR(255), @MaxRows INT', 
        @TableNamePattern, @ColumnNamePattern, @MaxRows
END

EXEC Portfolio.FindDBTandCByRowCount 
    @TableNamePattern = '%Consul%', 
    @ColumnNamePattern = '%Name%', 
    @MaxRows = 20
