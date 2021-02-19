CREATE VIEW dbo.view_Proview_Web_Change_Order_Totals
AS
WITH cte AS (SELECT        c.ChangeOrderID, d.ttlPrice, c.GCOHP, CASE WHEN c.GCOHP = 1 THEN (c.GCOHPPercent / 100) * d .ttlPrice ELSE 0 END AS gcohpAmount, c.GCOHPPercent, s.ttlTaxRate AS taxrate, c.Status, 
                                                      c.BillingStatus, d.ttlCIMACost, c.ProjectID
                             FROM            dbo.tblChangeOrder AS c INNER JOIN
                                                          (SELECT        SUM(ISNULL(Qty, 0) * ISNULL(UnitPrice, 0)) AS ttlPrice, ChangeOrderID, SUM(ISNULL(Qty, 0) * ISNULL(CIMACost, 0)) AS ttlCIMACost
                                                            FROM            dbo.tblChangeOrderDetail
                                                            GROUP BY ChangeOrderID) AS d ON d.ChangeOrderID = c.ChangeOrderID LEFT OUTER JOIN
                                                          (SELECT        COUNT(*) AS ct, t.projectID, s_1.ttlTaxRate
                                                            FROM            project.salesTaxDetermination AS t INNER JOIN
                                                                                          (SELECT        SUM(SalesTaxRate) AS ttlTaxRate, ProjectID
                                                                                            FROM            dbo.tblProjectSalesTax
                                                                                            WHERE        (ISNULL(SalesTaxRate, 0) > 0)
                                                                                            GROUP BY ProjectID) AS s_1 ON s_1.ProjectID = t.projectID
                                                            WHERE        (t.saleTax = 1)
                                                            GROUP BY t.projectID, s_1.ttlTaxRate) AS s ON s.projectID = c.ProjectID AND s.ct > 0)
    SELECT        ChangeOrderID, ttlPrice, GCOHP, gcohpAmount, GCOHPPercent, taxrate, ISNULL(gcohpAmount, 0) + ISNULL(ttlPrice, 0) AS totalPriceWithGCOHP, (gcohpAmount + ttlPrice) * taxrate AS SalesTaxAmount, Status, 
                              BillingStatus, ttlCIMACost, ProjectID
     FROM            cte AS cte_1

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_Proview_Web_Change_Order_Totals';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "cte_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 209
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
         Width = 1500
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
         Table = 1170
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_Proview_Web_Change_Order_Totals';


GO

