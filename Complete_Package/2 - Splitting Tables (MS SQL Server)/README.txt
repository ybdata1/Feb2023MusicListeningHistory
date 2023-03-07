For step 2, I imported my 2 csv files from the previous step into MS SQL Server. The goal
of this step was to split my ListenHistory file (which contained my fact data) into 3 
additional files:
	1 - Genre_Dim
	2 - Song_Dim
	3 - Fact_Dim

You can find the sql code for splitting the data in "Splitting Tables.sql"

I exported the resulting tables into csv files using MS SQL Server's Export Data tool. I 
placed these files in the folder for the next step: Additional pandas cleaning.