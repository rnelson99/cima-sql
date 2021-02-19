
CREATE PROCEDURE dbo.webAPICallLog
	
AS
BEGIN
	
	SET NOCOUNT ON;
	truncate table logdatabase.dbo.csvAPICallLog

		BULK INSERT logdatabase.dbo.csvAPICallLog
		FROM 'c:\temp\cflog\cflog.txt'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',  --CSV field delimiter
			ROWTERMINATOR = '\n',   --Use to shift the control to next row
			TABLOCK
		)

		select l.*, e.FirstName, e.LastName, isnull(e.firstname,'') + ' ' + isnull(left(e.lastname,1),'') as username,
			isnull(e.firstname,'') + ' ' + isnull(left(e.lastname,1),'') + ' ' + isnull(l.[proc],'') as searchfield
		from logdatabase.dbo.csvAPICallLog l
		left join Contacts.Entity e on e.EntityID = l.userid
		order by apistartdatetime
END

GO

