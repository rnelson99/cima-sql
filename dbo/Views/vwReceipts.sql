
CREATE VIEW vwReceipts AS SELECT
    tblConstDivCodes.AcctItemDescription,
    tblExpense.CCAmount,
    tblExpense.ExpenseID,
    tblExpense.ExpReason,
    tblExpense.ReceiptPath,
    tblExpense.TransactionDate,
    tblExpense.VendorCC,
    tblExpense.VendorID,
    tblExpenseReport.UserEntityID,
    tblProject.ProjectName,
    Contacts.Entity.FirstName + ' ' + LEFT( Contacts.Entity.LastName, 1 ) + '.' AS UserFullName
FROM
    tblExpense
    LEFT JOIN   tblConstDivCodes    ON tblExpense.CodeID                = tblConstDivCodes.CodeID
    LEFT JOIN   tblExpenseReport    ON tblExpense.ExpenseReportID       = tblExpenseReport.ExpenseReportID
    LEFT JOIN   tblProject          ON tblExpense.ProjectID             = tblProject.ProjectID
    LEFT JOIN   Contacts.Entity     ON tblExpenseReport.UserEntityID    = Contacts.Entity.EntityID
WHERE
    (
        ( tblExpense.ReceiptPath IS NOT NULL )
        AND ( tblExpense.VendorCC IS NULL )
        AND ( tblExpense.CCReferenceNumber IS NULL )
        AND ( tblExpense.IsUserCreated = 'N' )
    ) OR (
        ( tblExpense.VendorCC IS NOT NULL )
        AND ( tblExpense.CCReferenceNumber IS NOT NULL )
        AND ( tblExpense.VendorID IS NULL )
    )

GO

