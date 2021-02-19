
CREATE PROCEDURE dbo.KeepTablesClean
	
AS
BEGIN
	SET NOCOUNT ON;

    
	Update Contacts.ContactLink set Addr = 0
	Update Contacts.ContactLink set Addr = 1 where LinkType in (select id from WebLookup.LookUpCodes where LookupType = 'AddressType') 


END

GO

