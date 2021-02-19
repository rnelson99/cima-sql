
/* Creted: 2016-03-27 - Butz - The query used in the MS Access report is getting "Query is too complex" error that is why this view was created.*/
CREATE VIEW [dbo].[viewSalesTaxReport]
AS
SELECT        dbo.tblProject.ProjectID, dbo.tblProject.ClientID, dbo.tblProject.CIMA_Status, dbo.tblProject.ProjectNum, dbo.tblProject.ProjectShortName, dbo.tblProject.ProjectCity, dbo.tblProject.ProjectState, dbo.tblProject.TaxingEntity, 
                         dbo.tblProject.CIMAChargingSalesTax, CAST(dbo.viewProjectSalesTax.SumOfSalesTaxRate AS DECIMAL(18, 6)) AS ProjectSalesTax, dbo.viewPaymentDetails.DatePay, dbo.tblInvoice.InvoiceDate, dbo.tblInvoice.InvoiceNumber, 
                         dbo.viewPaymentDetails.AmountApply, CASE WHEN CAST(viewProjectSalesTax.SumOfSalesTaxRate AS DECIMAL(18, 6)) 
                         > 0 THEN CAST(viewPaymentDetails.AmountApply / (1 + CAST(viewProjectSalesTax.SumOfSalesTaxRate AS DECIMAL(18, 6))) AS MONEY) ELSE 0 END AS Taxable, dbo.tlkpPaymentType.PaymentTypeDescription, 
                         CASE WHEN ISNULL(viewTaxingEntities.TaxingEntities, '') <> 'No Tax' THEN ISNULL(viewTaxingEntities.TaxingEntities, '') ELSE '' END AS ProjectTaxingEntities
FROM            dbo.tblProject LEFT OUTER JOIN
                         dbo.viewProjectSalesTax ON dbo.tblProject.ProjectID = dbo.viewProjectSalesTax.ProjectID INNER JOIN
                         dbo.tlkpPaymentType RIGHT OUTER JOIN
                         dbo.viewPaymentDetails ON dbo.tlkpPaymentType.PaymentTypeID = dbo.viewPaymentDetails.PaymentTypeID ON dbo.tblProject.ProjectID = dbo.viewPaymentDetails.ProjectID INNER JOIN
                         dbo.tblInvoice ON dbo.viewPaymentDetails.InvoiceID = dbo.tblInvoice.InvoiceID LEFT OUTER JOIN
                         dbo.viewTaxingEntities ON dbo.tblProject.ProjectID = dbo.viewTaxingEntities.ProjectID
WHERE        (NOT (dbo.viewPaymentDetails.AmountApply IS NULL)) AND (dbo.viewPaymentDetails.IsDeleted = 'N')

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[12] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblProject"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 202
               Right = 270
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "viewProjectSalesTax"
            Begin Extent = 
               Top = 75
               Left = 390
               Bottom = 228
               Right = 617
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tlkpPaymentType"
            Begin Extent = 
               Top = 197
               Left = 195
               Bottom = 293
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "viewPaymentDetails"
            Begin Extent = 
               Top = 167
               Left = 686
               Bottom = 334
               Right = 907
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "tblInvoice"
            Begin Extent = 
               Top = 245
               Left = 9
               Bottom = 375
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "viewTaxingEntities"
            Begin Extent = 
               Top = 31
               Left = 704
               Bottom = 127
               Right = 874
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewSalesTaxReport';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewSalesTaxReport';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'      Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2430
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewSalesTaxReport';


GO

