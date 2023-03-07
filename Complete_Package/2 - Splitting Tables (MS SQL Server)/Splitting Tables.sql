USE ListenHistoryProject
GO
/*
	1. Find Total PKs vs Unique PKs. 
	As Expected, this query returns the same count for both.
	This confirms the ListenHistory_Fact table meets 1NF.
*/
SELECT 
	COUNT(Listen_History_PK) AS Total_Rows,
	COUNT(DISTINCT Listen_History_PK) AS Distinct_Rows
	FROM ListenHistory_Fact;

/*
	2. Determine which columns can be converted to FKs/separate dimension tables.
*/
SELECT TOP(20) * FROM ListenHistory_Fact;
/*
	Upon inspecting the first 20 rows, we can see logical duplicates in Artist, Album, Duration, Genre
	Subgenre, Tempo_BPM, Key_Signature, and Album_Release_Date. We can also make the inferrence that
	duplicates occur in the Song_Name & Feature_Artists column as well (unless I never listened to the same song twice,
	which is highly unlikely).

	3. Create Song_Dim
		Song_Dim - Song_Name, Artist, Feature_Artists, Album, Duration, Subgenre, Tempo_BPM,
					Key_Signature, Album_Release_Date
*/
SELECT	Song_Name, 
		Artist, 
		Feature_Artists, 
		Album, 
		Duration, 
		Subgenre, 
		Tempo_BPM,
		Key_Signature, 
		Album_Release_Date
INTO TMP
FROM ListenHistory_Fact;
-- (902 rows affected)

-- This temprorary table is the precursor to our Song_Dim Table
SELECT * 
FROM TMP;

-- Now we'll remove the duplicates and insert into a new Song_Dim table
SELECT DISTINCT *
INTO Song_Dim
FROM TMP;

SELECT * FROM Song_Dim;
/* 
	A few of our album names didn't load into the new table correctly (probably due to special characters).
	Since I'm using MS SQL Server Management Studio, I could just edit these values using the edit table tool,
	but I'll write out the SQL code to do so below.
*/
ALTER TABLE Song_Dim
ALTER COLUMN Album nvarchar(50);

UPDATE Song_Dim
SET Album = 'Let''s Start Here'
WHERE Album = 'Let’s Start Here';

UPDATE Song_Dim
SET Album = 'Up 2 M�'
WHERE Album = 'Up 2 Më';

/*
	4. Repeat process for Genre_Dim and Subgenre_Dim
*/
SELECT	Genre,
		Subgenre
INTO TMP2
FROM ListenHistory_Fact;

SELECT DISTINCT *
INTO Subgenre_Dim
FROM TMP2;

SELECT * FROM Subgenre_Dim;

SELECT	Genre
INTO TMP3
FROM ListenHistory_Fact;

SELECT DISTINCT *
INTO Genre_Dim
FROM TMP3;

/* 
	5. Drop all TMP tables
*/
DROP TABLE TMP;
DROP TABLE TMP2;
DROP TABLE TMP3;

/*
	From here, we'll export all of our tables to CSVs and head back to Jupyter Notebook for some additional steps.
*/