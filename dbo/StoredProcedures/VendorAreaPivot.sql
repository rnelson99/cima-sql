
CREATE PROCEDURE [dbo].[VendorAreaPivot]
	--exec dbo.VendorAreaPivot
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE   @SQLQuery AS NVARCHAR(MAX)
	DECLARE   @PivotColumns AS NVARCHAR(MAX)
 
	SELECT   @PivotColumns= COALESCE(@PivotColumns + ',','') + QUOTENAME(AirportCode)
	FROM (SELECT DISTINCT AirportCode FROM AreaList) AS PivotExample
 
	IF OBJECT_ID('proviewtemp.dbo.VendorAreaTemp', 'U') IS NOT NULL 
	DROP TABLE proviewtemp.dbo.VendorAreaTemp;

	SET   @SQLQuery = 
		N'SELECT entityid as entityidArea, ' +   @PivotColumns + '
		into proviewtemp.dbo.VendorAreaTemp
		FROM view_VendorAreas 
		PIVOT( SUM(Status) 
			  FOR AirportCode IN (' + @PivotColumns + ')) AS P
	
		'
 
	EXEC sp_executesql @SQLQuery
END

GO

