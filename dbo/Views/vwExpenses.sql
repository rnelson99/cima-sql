

CREATE VIEW vwExpenses AS SELECT
    tblConstDivCodes.AcctItemDescription,
    tblExpense.CCAmount,
    tblExpense.ExpenseID,
    tblExpense.ExpReason,
    tblExpense.SalesTaxID,
    tblExpense.TransactionDate,
    tblExpense.VendorCC,
    tblExpense.VendorID,
    tblExpenseReport.ExpenseReportStatus,
    tblExpenseReport.UserEntityID,
    tblProject.ProjectName,
    tblProViewAccount.ProViewAccountName,
    tblVendor.Vendor,
    tblVendor2.Vendor                                                               AS AutoMatchVendor,
    tblVendor2.VendorID                                                             AS AutoMatchVendorID,
    tblVendor3.Vendor                                                               AS SmartMatchVendor,
    tblVendor3.VendorID                                                             AS SmartMatchVendorID,
    tvalSalesTax.SalesTaxDescription,
    tvalSalesTax2.SalesTaxDescription                                               AS AutoMatchSalesTaxDescription,
    tvalSalesTax2.SalesTaxID                                                        AS AutoMatchSalesTaxID,
    tvalSalesTax3.SalesTaxDescription                                               AS VendorSalesTaxDescription,
    tvalSalesTax3.SalesTaxID                                                        AS VendorSalesTaxID,
    Contacts.Entity.FirstName + ' ' + LEFT( Contacts.Entity.LastName, 1 ) + '.'     AS UserFullName
FROM
    tblExpense
    LEFT JOIN   tblExpenseAutoMatch                         ON  tblExpense.VendorCC                         = tblExpenseAutoMatch.SourceFieldValue
                                                            AND tblExpenseAutoMatch.SourceFieldName         = 'VendorCC'
                                                            AND tblExpenseAutoMatch.MatchFieldName          = 'VendorID'
                                                            AND tblExpenseAutoMatch.ExpenseAutoMatchType    = 'CC'
    LEFT JOIN   tblExpenseAutoMatch tblExpenseAutoMatch2    ON  tblExpense.VendorID                         = tblExpenseAutoMatch2.SourceFieldValue
                                                            AND tblExpenseAutoMatch2.SourceFieldName        = 'VendorID'
                                                            AND tblExpenseAutoMatch2.MatchFieldName         = 'SalesTaxID'
                                                            AND tblExpenseAutoMatch2.ExpenseAutoMatchType   = 'PV'
    LEFT JOIN   tblExpenseReport                            ON  tblExpense.ExpenseReportID                  = tblExpenseReport.ExpenseReportID
    LEFT JOIN   tblConstDivCodes                            ON  tblExpense.CodeID                           = tblConstDivCodes.CodeID
    LEFT JOIN   tblProject                                  ON  tblExpense.ProjectID                        = tblProject.ProjectID
    LEFT JOIN   tblProViewAccount                           ON  tblExpense.ProViewAccountID                 = tblProViewAccount.ProViewAccountID
    LEFT JOIN   tblVendor                                   ON  tblExpense.VendorID                         = tblVendor.VendorID
    LEFT JOIN   tblVendor           tblVendor2              ON  tblExpenseAutoMatch.MatchFieldValue         = tblVendor2.VendorID
    LEFT JOIN   tvalSalesTax                                ON  tblExpense.SalesTaxID                       = tvalSalesTax.SalesTaxID
    LEFT JOIN   tvalSalesTax        tvalSalesTax2           ON  tblExpenseAutoMatch2.MatchFieldValue        = tvalSalesTax2.SalesTaxID
    LEFT JOIN   tvalSalesTax        tvalSalesTax3           ON  tblVendor.SalesTaxID                        = tvalSalesTax3.SalesTaxID
    LEFT JOIN   Contacts.Entity                             ON  tblExpenseReport.UserEntityID               = Contacts.Entity.EntityID
    CROSS APPLY (
                    SELECT
                        TOP 1 *
                    FROM
                        tblVendor
                    WHERE
                        CHARINDEX(
                            REPLACE( REPLACE( tblVendor.Vendor, ' ', '' ), '-', '' ),
                            REPLACE( REPLACE( tblExpense.VendorCC, ' ', '' ), '-', '' )
                        ) > 0
                    ORDER BY
                        dbo.levenshtein( tblExpense.VendorCC, tblVendor.Vendor )
                ) tblVendor3
WHERE
    ( ReceiptPath IS NULL )
    OR (
        ( ReceiptPath IS NOT NULL )
        AND ( IsUserCreated = 'Y' )
    )

GO

