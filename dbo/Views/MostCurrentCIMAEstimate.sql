/****** Object:  View [dbo].[MostCurrentCIMAEstimate]    Script Date: 11/8/2014 5:31:02 PM ******/
CREATE VIEW [dbo].[MostCurrentCIMAEstimate] AS
SELECT DISTINCT a.ProjectId, a.EstimateAmount FROM dbo.tblEstimateCIMA a
WHERE a.EstimateDate =
(SELECT Max(EstimateDate) FROM dbo.tblEstimateCIMA
   WHERE ProjectId = a.ProjectId)

GO

