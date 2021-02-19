
CREATE VIEW dbo.viewPWADetailFundingFirstConstDivCode AS
	WITH Funding(FirstPWADetailFundingID, PWALogID) AS
		(
			SELECT MIN(PWADetailFundingID) AS FirstPWADetailFundingID, PWALogID
			FROM tblPWADetailFunding
			WHERE RequiredAmount>0
			GROUP BY PWALogID
		)
	SELECT tblPWADetailFunding.PWALogID
	, tblPWALog.ProjectID
	, tblPWADetailFunding.MasterConstDivCodeID AS FirstOfMasterConstDivCodeID
	, tblPWALog.VendorID
	FROM tblPWALog INNER JOIN tblPWADetailFunding ON tblPWALog.PWALogID=tblPWADetailFunding.PWALogID
		INNER JOIN Funding ON tblPWADetailFunding.PWADetailFundingID=Funding.FirstPWADetailFundingID
	WHERE tblPWALog.IsDeleted='N'

GO

