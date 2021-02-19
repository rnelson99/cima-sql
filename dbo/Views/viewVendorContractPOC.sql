
CREATE VIEW viewVendorContractPOC
AS
SELECT a.VendorId, a.FirstName, a.LastName,MobilePhone, EMail, Title
FROM tblVendorContact a  WHERE primaryContactContracts = 1

GO

