
/*GROUP BY pwalog.EntityID*/
CREATE VIEW [dbo].[viewVendorListFigures]
AS
SELECT DISTINCT 
                         pwalog.EntityID, ISNULL(l1.Contract, 0) - ISNULL(backlog.PayAmount, 0) AS Backlog, ISNULL(l1.Contract, 0) AS ApprovedContract, ISNULL(l2.PayAmount, 0) AS Incomplete, 0 AS PendingSCO, ISNULL(ap.PayAmount, 0) AS AP, 
                         0 AS Late, ISNULL(paid.PayAmount, 0) AS PayAmount, ISNULL(inProcess.PayAmount, 0) AS InProcess, ISNULL(PWP.PayAmount, 0) AS PWP
FROM            dbo.tblPWALog AS pwalog LEFT OUTER JOIN
                             (SELECT        SUM(PWALogAmount) AS Contract, EntityID
                               FROM            dbo.tblPWALog
                               WHERE        (PWAStatusID IN (5, 7)) AND (IsDeleted = 'N') AND (ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject
                                                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
                               GROUP BY EntityID) AS l1 ON l1.EntityID = pwalog.EntityID LEFT OUTER JOIN
                             (SELECT        SUM(s.PayAmount) AS TtlPay, SUM(s.PayAmount) - SUM(s.RetainageAmount) AS PayAmount, l.EntityID
                               FROM            dbo.tblPWALog AS l INNER JOIN
                                                         accounting.SubPayApp AS s ON s.PWALogID = l.PWALogID AND s.PayAppStatusID <> - 1
                               WHERE        (l.IsDeleted = 'N') AND (s.PayAppStatusID IN (1)) AND (l.ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject AS tblProject_6
                                                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
                               GROUP BY l.EntityID) AS l2 ON l2.EntityID = pwalog.EntityID LEFT OUTER JOIN
                             (SELECT        SUM(s.PayAmount) AS TtlPay, SUM(s.PayAmount) - SUM(s.RetainageAmount) AS PayAmount, l.EntityID
                               FROM            dbo.tblPWALog AS l INNER JOIN
                                                         accounting.SubPayApp AS s ON s.PWALogID = l.PWALogID AND s.PayAppStatusID <> - 1
                               WHERE        (l.IsDeleted = 'N') AND (s.PayAppStatusID NOT IN (9)) AND (l.ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject AS tblProject_5
                                                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
                               GROUP BY l.EntityID) AS backlog ON backlog.EntityID = pwalog.EntityID LEFT OUTER JOIN
                             (SELECT        SUM(s.PayAmount) AS TtlPay, SUM(s.PayAmount) - SUM(s.RetainageAmount) AS PayAmount, l.EntityID
                               FROM            dbo.tblPWALog AS l INNER JOIN
                                                         accounting.SubPayApp AS s ON s.PWALogID = l.PWALogID AND s.PayAppStatusID <> - 1
                               WHERE        (l.IsDeleted = 'N') AND (s.PayAppStatusID IN (6)) AND (l.ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject AS tblProject_4
                                                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
                               GROUP BY l.EntityID) AS ap ON ap.EntityID = pwalog.EntityID LEFT OUTER JOIN
                             (SELECT        SUM(s.PayAmount) AS TtlPay, SUM(s.PayAmount) - SUM(s.RetainageAmount) AS PayAmount, l.EntityID
                               FROM            dbo.tblPWALog AS l INNER JOIN
                                                         accounting.SubPayApp AS s ON s.PWALogID = l.PWALogID AND s.PayAppStatusID <> - 1
                               WHERE        (l.IsDeleted = 'N') AND (s.PayAppStatusID = 8) AND (l.ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject AS tblProject_3
                                                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
                               GROUP BY l.EntityID) AS paid ON paid.EntityID = pwalog.EntityID LEFT OUTER JOIN
                             (SELECT        SUM(s.PayAmount) AS TtlPay, SUM(s.PayAmount) - SUM(s.RetainageAmount) AS PayAmount, l.EntityID
                               FROM            dbo.tblPWALog AS l INNER JOIN
                                                         accounting.SubPayApp AS s ON s.PWALogID = l.PWALogID AND s.PayAppStatusID <> - 1
                               WHERE        (l.IsDeleted = 'N') AND (s.PayAppStatusID = 2)
                               GROUP BY l.EntityID) AS inProcess ON inProcess.EntityID = pwalog.EntityID LEFT OUTER JOIN
                             (SELECT        SUM(s.PayAmount) AS TtlPay, SUM(s.PayAmount) - SUM(s.RetainageAmount) AS PayAmount, l.EntityID
                               FROM            dbo.tblPWALog AS l INNER JOIN
                                                         accounting.SubPayApp AS s ON s.PWALogID = l.PWALogID AND s.PayAppStatusID <> - 1
                               WHERE        (l.IsDeleted = 'N') AND (s.PayAppStatusID IN (5, 4)) AND (l.ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject AS tblProject_2
                                                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
                               GROUP BY l.EntityID) AS PWP ON PWP.EntityID = pwalog.EntityID
WHERE        (pwalog.ProjectID IN
                             (SELECT        ProjectID
                               FROM            dbo.tblProject AS tblProject_1
                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout')))) AND (pwalog.IsDeleted = 'N')

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewVendorListFigures';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[13] 2[28] 3) )"
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
         Begin Table = "pwalog"
            Begin Extent = 
               Top = 6
               Left = 324
               Bottom = 288
               Right = 590
            End
            DisplayFlags = 280
            TopColumn = 14
         End
         Begin Table = "l1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l2"
            Begin Extent = 
               Top = 6
               Left = 628
               Bottom = 119
               Right = 798
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "backlog"
            Begin Extent = 
               Top = 6
               Left = 836
               Bottom = 119
               Right = 1006
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ap"
            Begin Extent = 
               Top = 6
               Left = 1044
               Bottom = 119
               Right = 1214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "paid"
            Begin Extent = 
               Top = 102
               Left = 38
               Bottom = 215
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "inProcess"
            Begin Extent = 
               Top = 120
               Left = 628
               Bottom = 233
               Right = 798
            End
            DisplayFlags = 280
            TopCo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewVendorListFigures';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'lumn = 0
         End
         Begin Table = "PWP"
            Begin Extent = 
               Top = 120
               Left = 836
               Bottom = 233
               Right = 1006
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
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewVendorListFigures';


GO

