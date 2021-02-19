CREATE VIEW dbo.viewFirstSubcontractWorkItem AS

	SELECT MIN(pwadc.PWADetailCostID) AS PWADetailCostID, pwal.PWALogID, pwal.ProjectID, pwadc.ItemName, pwal.PWALogTypeID
	FROM (tblPWALog pwal
		INNER JOIN tblPWADetailCost pwadc ON pwal.PWALogID=pwadc.PWALogID)
		INNER JOIN (
			SELECT MIN(PWADetailCostID) AS PWADetailCostID, PWALogID
			FROM tblPWADetailCost
			GROUP BY PWALogID
		) pwadcsub ON pwadc.PWADetailCostID=pwadcsub.PWADetailCostID
	--WHERE (pwal.ProjectID=533) AND (pwal.PWALogTypeID IN (2,4))
	GROUP BY pwal.PWALogID, pwal.ProjectID, pwadc.ItemName, pwal.PWALogTypeID

GO

