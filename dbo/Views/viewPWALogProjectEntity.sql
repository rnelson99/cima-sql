
CREATE VIEW [dbo].[viewPWALogProjectEntity]
AS
		Select l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, l.PWALogTypeID, l.PWALogNumber, l.PWALogAmount, l.PWALogDateIssued, l.PWAStatusID, s.PWAStatusName,
			l.PWALockStatus, l.ParentPWAID, l.SubShallProvide, l.PWALogLastModified, l.PWAObsolete, l.PWALogFullPathAndFileName, l.PONumber,
			l.EstimateOfCompletedWork, l.EstimateOfStoredMaterial, l.EstimateOfPercentComplete, l.NextPayAppType, l.HoldRetainage,
			l.UseGlobalComplete, l.Payor, l.ConstructionDivCode_INFO, l.PWALogTypeID  as PWALogTypeConverted,
			case when l.PWAStatusID in (5,7) then 1 else 0 end as pwaApproved,
			case when l.PWAStatusID in (1,2,3,4) then 1 else 0 end as pwaPending,
			case when l.PWAStatusID in (6) then 1 else 0 end as pwaRejected,
			wp.workPerformed as workperformed
		from tblPWALog l
		join Contacts.Entity e on e.EntityID = l.EntityID
		join tvalPWAStatus s on s.PWAStatusID = l.PWAStatusID
		LEFT JOIN project.CompanyWorkPerformed wp on wp.entityid = e.entityid and wp.projectid = l.ProjectID
		where l.PWALogTypeID in (1,3)
		and l.IsDeleted = 'N'
		union Select l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, l.PWALogTypeID, l.PWALogNumber, l.PWALogAmount, l.PWALogDateIssued, l.PWAStatusID, s.PWAStatusName,
			l.PWALockStatus, l.ParentPWAID, l.SubShallProvide, l.PWALogLastModified, l.PWAObsolete, l.PWALogFullPathAndFileName, l.PONumber,
			l.EstimateOfCompletedWork, l.EstimateOfStoredMaterial, l.EstimateOfPercentComplete, l.NextPayAppType, l.HoldRetainage,
			l.UseGlobalComplete, l.Payor, l.ConstructionDivCode_INFO, case when l.PWALogTypeID in (1,3) then 1 else 2 end as PWALogTypeConverted,
			case when l.PWAStatusID in (5,7) then 1 else 0 end as pwaApproved,
			case when l.PWAStatusID in (1,2,3,4) then 1 else 0 end as pwaPending,
			case when l.PWAStatusID in (6) then 1 else 0 end as pwaRejected,
			wp.workPerformed as workperformed
		from tblPWALog l
		join Contacts.Entity e on e.EntityID = l.EntityID
		join tvalPWAStatus s on s.PWAStatusID = l.PWAStatusID
		LEFT JOIN project.CompanyWorkPerformed wp on wp.entityid = e.entityid and wp.projectid = l.ProjectID
		where l.PWALogTypeID in (2,4)
		and l.IsDeleted = 'N'

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewPWALogProjectEntity';


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
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 32
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'viewPWALogProjectEntity';


GO

