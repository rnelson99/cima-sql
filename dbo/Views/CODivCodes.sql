
/****** Object:  View [dbo].[CODivCodes]    Script Date: 11/8/2014 4:30:34 PM ******/
CREATE VIEW [dbo].[CODivCodes]
as
SELECT       a.[ProjectID]
      ,a.[BillingStatus]
      ,b.MasterConstDivCodeID
      ,c.ConstructionDivCode
      ,c.AcctCat
  FROM [Proview_TestOnly].[dbo].[tblChangeOrder] a
  JOIN dbo.tblChangeOrderDetail b ON a.ChangeOrderID=b.ChangeOrderID
  JOIN dbo.tblConstDivCodes c ON b.MasterConstDivCodeID=c.codeid

GO

