
CREATE VIEW dbo.viewDuplicateExpenseReference AS

	SELECT CCReferenceNumber, ProViewAccountID
	FROM tblExpense
	WHERE NOT CCReferenceNumber IS NULL
	GROUP BY CCReferenceNumber, ProViewAccountID
	HAVING COUNT(CCReferenceNumber) > 1

GO

