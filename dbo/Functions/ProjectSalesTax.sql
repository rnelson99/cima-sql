
-- ================================================================================================================================
-- Author:		Lolt
-- Mod date: 29-Oct-2014
-- Description:	Compute Project SalesTaxRate from tblProjectSalesTax
-- Mod date: 19-Nov-2014
-- Return 0 if CIMAChargingSalesTax not set
-- Modified date: 27-Jun-2015 (Butz) - Eliminate CIMAChargingSalesTax and use tblProjectTableInstead. Case 216 - Sales Tax Issues
-- ================================================================================================================================
CREATE FUNCTION [dbo].[ProjectSalesTax] 
(
	@projectId int
)
RETURNS decimal(18,4)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,4)
	--DECLARE @ChargingSalesTax bit
	--SELECT @ChargingSalesTax = CIMAChargingSalesTax FROM tblProject WHERE ProjectId= @projectId
	--IF @ChargingSalesTax=1
		SELECT @Result = SUM(ISNULL(SalesTaxRate,0)) FROM tblProjectSalesTax WHERE ProjectId =@projectId
	--ELSE
	--	SET @Result=0
	-- Insure we don't have null result from tblProjectSalesTax
	IF @result = NULL
		SET @Result=0
	RETURN @Result
	
END

GO

