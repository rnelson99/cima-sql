
/* order by e.LastName, e.FirstName, PWALogTypeConverted, l.pwalognumber, l.PWALogAmount*/
CREATE VIEW [dbo].[rptCrystalPWALog]
AS
SELECT        l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, l.PWALogTypeID, l.PWALogNumber, ISNULL(l.PWALogAmount, 0) AS PWALogAmount, l.PWALogDateIssued, l.PWAStatusID, s.PWAStatusName, l.PWALockStatus, 
                         l.ParentPWAID, l.SubShallProvide, l.PWALogLastModified, l.PWAObsolete, l.PWALogFullPathAndFileName, l.PONumber, l.EstimateOfCompletedWork, l.EstimateOfStoredMaterial, l.EstimateOfPercentComplete, 
                         l.NextPayAppType, l.HoldRetainage, l.UseGlobalComplete, l.Payor, l.ConstructionDivCode_INFO, l.PWALogTypeID AS PWALogTypeConverted, CASE WHEN l.PWAStatusID IN (5, 7) THEN 1 ELSE 0 END AS pwaApproved, 
                         CASE WHEN l.PWAStatusID IN (1, 2, 3, 4) THEN 1 ELSE 0 END AS pwaPending, CASE WHEN l.PWAStatusID IN (6) THEN 1 ELSE 0 END AS pwaRejected, wp.workPerformed AS workperformed,
                             (SELECT        COUNT(*) AS Expr1
                               FROM            Documents.Documents
                               WHERE        (ReferenceType = 43) AND (ReferenceID = l.PWALogID)) AS documentcount, '' AS PWALogDetailDescription, l.IsDeleted, CASE WHEN isnull(vAtRisk.ct, 0) > 0 AND l.PWAStatusID IN (4, 5, 7) AND l.pwalogtypeid IN (2,
                          4) THEN 1 ELSE 0 END AS pwaAtRisk
FROM            dbo.tblPWALog AS l INNER JOIN
                         Contacts.Entity AS e ON e.EntityID = l.EntityID INNER JOIN
                         dbo.tvalPWAStatus AS s ON s.PWAStatusID = l.PWAStatusID LEFT OUTER JOIN
                         project.CompanyWorkPerformed AS wp ON wp.entityid = e.EntityID AND wp.projectid = l.ProjectID LEFT OUTER JOIN
                         dbo.viewPWAsAtRisk AS vAtRisk ON vAtRisk.PWALogID = l.PWALogID
WHERE        (l.IsDeleted = 'N')

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
         Begin Table = "l"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 326
               Bottom = 136
               Right = 532
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 570
               Bottom = 136
               Right = 810
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "wp"
            Begin Extent = 
               Top = 6
               Left = 848
               Bottom = 136
               Right = 1019
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vAtRisk"
            Begin Extent = 
               Top = 6
               Left = 1057
               Bottom = 102
               Right = 1227
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
         O', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rptCrystalPWALog';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'utput = 720
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rptCrystalPWALog';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rptCrystalPWALog';


GO

