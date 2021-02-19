


CREATE VIEW [dbo].[sfrmSubcontractSubs]
AS

with ApprovedPWAChanges(ParentId, LogTypeId,  ChangesAmount)
AS (SELECT ParentPWAID, PWALogTypeId, Sum(PWALogAmount)
    FROM tblPWALog WHERE ParentPWAId IS NOT NULL AND PWALogTypeId IN (2,4)
    AND PWAStatusId >= 4
    GROUP BY ParentPWAID, PWALogTypeId)
SELECT [PWALogID]
      ,[ProjectID]
      ,tblPWALog.[VendorID]
      ,tblVendor.Vendor
      ,[ClientID]
      ,[PWALogTypeID]
      ,[PWALogNumber]
      ,[PWALogAmount]
      ,[PWALogDateIssued]
      ,[PWAStatusID]
      ,[PWALockStatus]
      ,[ParentPWAID]
      ,[SubShallProvide]
      ,[PWALogLastModified]
      ,[PWAObsolete]
      ,[PWALogFullPathAndFileName]
      ,[PONumber]
      ,[EstimateOfCompletedWork]
      ,[EstimateOfStoredMaterial]
      ,[EstimateOfPercentComplete]
      ,[NextPayAppType]
      ,[HoldRetainage]
,(PWALogAmount + ISNULL(ChangesAmount,0)) as ApprovedAmount
FROM tblPWALog  JOIN tblVendor on tblPWALog.VendorId  = tblVendor.VendorId 
LEFT JOIN ApprovedPWAChanges ON tblPWALog.PWALogId=ApprovedPWAChanges.PArentId
WHERE tblPWALog.PWALogTypeId IN (1,3)

GO

