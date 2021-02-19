
-- =============================================
-- Author:		L Proegler
-- Create date: 12-Jun-2014
-- Description:	Migrate ClientData to Proview client tables
-- =============================================
CREATE PROCEDURE MigrateClientData
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @clientShortName varchar(65)
	DECLARE @clientFedId varchar(20)
	DECLARE @clientLegalName varchar(55)
	DECLARE @clientSince datetime
	DECLARE @clientStatus varchar(15)
	DECLARE @clientWebSite varchar(75)
	DECLARE @locationMainPhone varchar(25)
	DECLARE @locationMainFax varchar(25)
	DECLARE @locationStreet varchar (55)
	DECLARE @locationStreet2 varchar(55)
	DECLARE @locationCity varchar(45)
	DECLARE @locationState varchar(3)
	DECLARE @locationzip varchar(10)
	DECLARE @clientLastUpdated datetime
	DECLARE @salutation varchar(4)
	DECLARE @firstname varchar(45)
	DECLARE @lastname varchar(45)
	DECLARE @officephone varchar(25)
	DECLARE @email varchar(150)
	DECLARE @clientId int
	DECLARE @LastUpdated datetime
	DECLARE client_cursor CURSOR FOR
	SELECT DISTINCT a.[ClientID],a.[ClientFedID],a.[ClientCompany],a.[ClientSince],a.[Status]
      ,a.[ClientURL],a.[ClientMainPhone],a.[ClientMainFax],a.[ClientStreet],a.[ClientStreet2]
      ,a.[ClientCity],a.[ClientState],a.[ClientZip],a.[LastUpdated],a.[ClientMainSalt]
      ,a.[ClientFName],a.[ClientLName],a.ClientPhone,a.ClientEMail FROM cimaSQL_Client a JOIN cimaSQL_Project b
      ON a.clientid = b.clientid JOIN cimapm_tblProject c ON b.projectid=c.billquickprojectid
	  WHERE c.projecttype = 'commercial'
	OPEN client_cursor
	FETCH NEXT FROM client_cursor INTO @clientShortName,@clientFedId,@clientLegalName, @clientSince, @clientStatus,
	  @clientWebSite,@locationMainPhone,@locationMainFax,@locationStreet, @locationStreet2,
	  @locationCity, @locationState, @locationzip,@clientLastUpdated,@salutation,
	  @firstname, @lastname, @officephone, @email
	SET @LastUpdated=getdate()
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--  Create record in tblClient
	    INSERT INTO dbo.tblClient(ClientShortname, Clientname, ClientFedId, ClientSince,
	    ClientStatus, ClientLastUpdated, ClientWebsite,WaiverRequiredforMaterialOnly) 
	    VALUES (@clientShortName,@clientLegalName, @clientFedId,@clientSince, @clientStatus,
			@LastUpdated, @clientWebSite, 0);
		-- Get ClientId from record inserted
		SELECT @clientId = @@IDENTITY;
		--  Insert record in tblClientLocation
		INSERT INTO dbo.tblClientLocation (ClientId, LocationCompany, LocationStreet, LocationStreet2,
		    LocationCity, LocationState, Zip, LocationMainPhone, LocationMainFax)
		VALUES (@clientId,@clientLegalName,@locationStreet, @locationStreet2,
		    @locationCity, @locationState, @locationZip,@locationMainPhone,@locationMainFax);
		--  Insert record in tblClientContact
		INSERT INTO dbo.tblClientContact(ClientId, Salutation, FirstName, LastName,OfficePhone, EMail)
		VALUES (@clientid, @salutation, @firstname, @lastname, @officephone, @email);
        -- get next record to process	
		FETCH NEXT FROM client_cursor INTO @clientShortName,@clientFedId,@clientLegalName, @clientSince, @clientStatus,
		  @clientWebSite,@locationMainPhone,@locationMainFax,@locationStreet, @locationStreet2,
		  @locationCity, @locationState, @locationzip,@clientLastUpdated,@salutation,
		  @firstname, @lastname, @officephone, @email
	END;
	CLOSE client_cursor
	DEALLOCATE client_cursor	
END

GO

