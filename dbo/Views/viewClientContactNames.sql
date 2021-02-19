

CREATE VIEW viewClientContactNames AS
SELECT ContactId, ClientId,
CASE WHEN Salutation IS NOT NULL AND FirstName IS NOT NULL  AND LastName is not null
     THEN Salutation + ' ' + Firstname + ' ' + LastName
     WHEN Salutation IS NULL AND FirstName IS NOT NULL  AND LastName is not null
     THEN Firstname + ' ' + LastName
     WHEN Salutation IS NOT NULL AND FirstName IS NULL  AND LastName is not null
     THEN Salutation + ' ' + LastName
     ELSE FirstName
END AS ContactName
FROM tblClientContact;

GO

