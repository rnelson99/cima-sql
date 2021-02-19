

CREATE VIEW viewClientAddresses AS
SELECT LocationId, ClientId,
LocationCompany + ', ' + LocationStreet + ', ' + LocationCity
 AS LocationAddress
FROM tblClientLocation;

GO

