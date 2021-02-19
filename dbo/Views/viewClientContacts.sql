CREATE VIEW viewClientContacts AS

	SELECT		ClientID, dbo.ClientBidContactId(ClientID) AS PrimaryContactBidId, dbo.ClientBillingContactId(ClientID) AS PrimaryBillingContactId, dbo.ClientContractsContactId(ClientID, 0) 
				AS PrimaryContractsContactId, dbo.ClientWaiversContactId(ClientID) AS PrimaryWaiversContactId
	FROM		dbo.tblClient

GO

