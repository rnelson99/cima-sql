
/****** Object:  UserDefinedFunction [dbo].[BudgetApprovedAmount]    Script Date: 10/08/2014 21:22:04 ******/
-- =============================================
-- Author:		Lolt
-- Create date: 23-Jul-2014
-- Description:	Compute Budget ApprovedAmount
-- =============================================
CREATE FUNCTION [dbo].[BudgetApprovedAmount] 
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
	DECLARE @BudgetWithCO as money
	SELECT @BudgetWithCO = dbo.BudgetWithChangeOrders(ProjectID,MasterConstDivCodeID,BaseBudgetAmount)
	   FROM tblBudget 
	   WHERE ProjectId =@projectId AND MasterConstDivCodeID=@MasterConstDivCodeID;
	-- Approved budget transactions
	SELECT @Result = SUM(CASE WHEN BudgetCostChangeReason LIKE 'PWA Modification%'
	   THEN ISNULL(BudgetCostChangeAmount,0)
	   ELSE -1 * ISNULL(BudgetCostChangeAmount,0) END) 
	FROM  tblBudgetCostChangeLog
	WHERE ProjectId =@projectId AND MasterConstDivCodeID=@MasterConstDivCodeID
	IF @Result IS NULL
		SET @Result=@BudgetWithCO
	ELSE
		SET @Result = @BudgetWithCO + @Result
	RETURN @Result
END

GO

