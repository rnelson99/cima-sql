
/****** Object:  UserDefinedFunction [dbo].[BudgetWithChangeOrders]    Script Date: 10/08/2014 21:22:04 ******/
-- =============================================
-- Author:		Lolt
-- Create date: 23-Jul-2014
-- Description:	Compute Budget with ChangeOrders
-- =============================================
CREATE FUNCTION [dbo].[BudgetWithChangeOrders] 
(
	@ProjectId int,
	@MasterConstDivCodeID int,
	@BaseBudget money
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result money
	SELECT @Result = 
	SUM(ISNULL(CostInclTax,0)) 
	FROM ChangeOrderTotalCIMACost
	WHERE ProjectId =@projectId AND MasterConstDivCodeID=@MasterConstDivCodeID
	IF @Result IS NULL
		SET @Result = @BaseBudget
	ELSE
		SET @Result = @BaseBudget + @Result
	RETURN @Result
END

GO

