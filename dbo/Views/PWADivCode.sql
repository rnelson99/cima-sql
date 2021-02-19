
/****** Object:  View [dbo].[PWADivCode]    Script Date: 11/8/2014 4:30:52 PM ******/
CREATE VIEW [dbo].[PWADivCode] AS
SELECT 
      a.[ProjectID]
      ,a.[MasterConstDivCodeID]
      ,a.[ConstructionDivCode_INFO]
  FROM tblPWADetailFunding a JOIN tblProject b ON a.projectid=b.projectid

GO

