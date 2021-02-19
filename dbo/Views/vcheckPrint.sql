CREATE VIEW dbo.vcheckPrint
AS
SELECT        d .checknumber, d .IssueDate, p1.lastname AS payableto, p2.LastName AS payableto2, d .amount, '** ' + dbo.fnIntegerToWords(d .amount) + ' *****' AS amt_in_words, '' AS memo, p1.LastName AS vendorname, 
                         s.vendorinvoiceno AS vendorinvoice, CASE WHEN s.apptype = 2 THEN 'Final' ELSE 'Partial' END AS paymenttype, isnull(p.ProjectNum, '') + '.' + isnull(cast(l.PWALogNumber AS varchar(100)), '') 
                         + '.' + isnull(cast(s.SubPayAppSeq AS varchar(100)), '') AS cimapayid, p.ProjectName AS projectname, isnull(p.ProjectStreet, '') + ' ' + isnull(p.ProjectCity, '') + ' ' + isnull(p.ProjectState, '') + ' ' + isnull(p.ProjectZip, '') 
                         AS projectaddress, a.Address1 AS sendtoline1, a.Address2 AS sendtoline2, isnull(a.city + ', ', '') + isnull(a.StateAbbr + ' ', '') + isnull(a.ZipCodeText, '') AS sendtoline3, l.PWALogNumber, isnull(d .checkguid, '') AS checkguid, 
                         d .SubPayAppDetailID, d .checkMemo
FROM            accounting.SubPayAppDetail d JOIN
                         accounting.SubPayApp s ON s.SubPayAppID = d .SubPayAppID JOIN
                         tblPWALog l ON l.PWALogID = s.PWALogID JOIN
                         tblProject p ON p.projectid = s.ProjectID JOIN
                         Contacts.Entity p1 ON p1.EntityID = s.EntityID LEFT JOIN
                         Contacts.Entity p2 ON p2.EntityID = d .SupplierEntityID LEFT JOIN
                             (SELECT        a.address1, a.Address2, a.Zip, a.City, a.state StateAbbr, cast(a.Zip as varchar(10)) as ZipCodeText, a.EntityID, rank() OVER (PARTITION BY Entityid
                               ORDER BY pay DESC, MainOffice DESC, contact DESC, tax DESC) AS rnk
FROM            Contacts.Address a                          
						 ) a ON a.EntityID = s.EntityID AND a.rnk = 1

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
      Begin ColumnWidths = 10
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vcheckPrint';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vcheckPrint';


GO

