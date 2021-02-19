
CREATE VIEW [dbo].[rptCrystalSPAList]
AS
SELECT        s.SubPayAppId, ii.OwnerPayAppNumber, s.entityid, CASE WHEN s.payappstatusid = - 1 THEN 'Y' ELSE 'N' END AS isdeleted, ps.PayAppStatus AS APPSTATUS, 
	isnull(s.payamount, 0) AS amount, isnull(s.PayAmount, 0) - isnull(s.RetainageAmount,0) AS netpay, 
                         SubPayAppSeq AS SUBPAYAPPSEQUENCE, s.payappstatusid, ps.payappstatus, isnull(s.RetainageAmount, 0) AS RetainageAmount, s.modifiedNet, isnull
                             ((SELECT        '' + STUFF
                                                              ((SELECT DISTINCT '' + zst.PaymentStatus + ','
                                                                  FROM            accounting.SubPayAppDetail zd JOIN
                                                                                           WebLookup.PaymentStatus zst ON zd.PaymentStatus = zst.PaymentStatusID
                                                                  WHERE        zd.SubPayAppID = s.SubPayAppID FOR xml path(''), type ).value('.', 'varchar(max)'), 1, 0, '') + ''), '') AS checkStatuses, isnull(s.retainagepayout, 0) AS retainagepayout, s.OPAComments, s.apptype, 
                         s.projectid, ii.invoiceid
FROM            accounting.SubPayApp s LEFT JOIN
                         tblInvoice ii ON ii.invoiceid = s.invoiceid JOIN
                         tblPWALog l ON l.PWALogID = s.PWALogID AND l.ProjectID = s.projectid JOIN
                         Contacts.Entity e ON e.EntityID = l.EntityID JOIN
                         tvalPWAStatus ss ON ss.PWAStatusID = l.PWAStatusID LEFT JOIN
                         WebLookup.payappstatus ps ON s.payappstatusid = ps.payappstatusid LEFT JOIN
                             (SELECT        sum(amount) AS amtTtl, subpayappid
                               FROM            accounting.SubPayAppDetail
                               WHERE        amount IS NOT NULL
                               GROUP BY subpayappid) AS addtl ON addtl.subpayappid = s.subpayappid
WHERE        1 = 1 AND ps.PayAppStatus != 'Deleted'

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rptCrystalSPAList';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[11] 2[29] 3) )"
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
      Begin ColumnWidths = 17
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'rptCrystalSPAList';


GO

