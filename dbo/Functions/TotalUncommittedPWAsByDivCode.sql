--GetTotalUncommittedPWAsByDivCode(lngMasterConstDivCodeID)
--   GetApprovedAmountByDivCode(lngMasterConstDivCodeID) - GetAllCommittedPWAsByDivCode(lngMasterConstDivCodeID)
--	WHERE
--   GetApprovedAmountByDivCode
--	 = GetBudgetWithChangeOrders(lngMasterConstDivCodeID, curBaseBudgetAmount)
--		=curBaseBudgetAmount + Nz(DLookup("CIMACost", "ChangeOrderTotalCIMACost",
--	 + GetTotalApprovedPWAFundingRequests(lngMasterConstDivCodeID)
--		 sql = "ProjectId=" & glngCurrentProjectID & " AND MasterConstDivCodeID=" & lngMasterConstDivCodeID
--		 GetTotalApprovedPWAFundingRequests = Nz(DSum("TotalPWAFundingRequests", "TotalApprovedPWAFundingRequests", sql), 0)
--   - GetTotalBuyOuts(lngMasterConstDivCodeID)
--
--	 GetAllCommittedPWAsByDivCode(lngMasterConstDivCodeID)
--	 =  criteria = "ProjectId=" & glngCurrentProjectID & "AND MasterConstDivCodeID=" & lngMasterConstDivCodeID
--      GetAllCommittedPWAsByDivCode = Nz(DLookup("TotalCommittedPWAs", "CommittedPWATotal", criteria), 0)
-- =============================================
-- Author:		Lolt
-- Create date: 23-Jul-2014
-- Description:	Compute Project SalesTaxRate from tblProjectSalesTax
-- =============================================
CREATE FUNCTION [dbo].[TotalUncommittedPWAsByDivCode]
(
	@ProjectId int,
	@DivcodeId int
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result money
	DECLARE @BaseBudget money
	DECLARE @ChangeOrderCIMACosts money
	DECLARE @BudgetWithChangeOrders money
	DECLARE @TotalApprovedPWAFundingRequests money
	DECLARE @TotalBuyOuts money
	DECLARE @AllCommittedPWAsByDivCode money
	--		
	SELECT @BaseBudget = Sum(isnull(BaseBudgetAmount,0)) FROM tblBudget WHERE ProjectId =@projectId
		AND MasterConstDivCodeId = @DivCodeId;
		
	SELECT @ChangeOrderCIMACosts = Sum(isnull(b.CIMACost,0)) 
		FROM tblChangeOrder a LEFT JOIN tblChangeOrderDetail b
		ON b.ChangeOrderID = a.ChangeOrderId
	    WHERE a.ProjectId=@ProjectId AND b.MasterConstDivCodeId=@DivcodeId
	    AND a.BillingStatus IN ('Approved','Verbally Approved');
	    
	SELECT @BudgetWithChangeOrders = isnull(@BaseBudget,0) + isnull(@ChangeOrderCIMACosts,0)

	SELECT @TotalApprovedPWAFundingRequests = Sum(ISNULL(a.BudgetCostChangeAmount,0))
		FROM dbo.tblBudgetCostChangeLog a
		WHERE a.ProjectID=@ProjectId AND a.MasterConstDivCodeId=@DivcodeId
		AND Substring(a.BudgetCostChangeReason,1,16) = 'PWA Modification'

	SELECT @TotalBuyOuts=Sum(isnull(a.BudgetCostChangeAmount,0))
		FROM dbo.tblBudgetCostChangeLog a
		WHERE a.ProjectID=@ProjectId AND a.MasterConstDivCodeId=@DivcodeId
		AND a.BudgetCostChangeReason = 'Buy Out';

	SELECT @AllCommittedPWAsByDivCode = sum(ISNULL(b.RequiredAmount,0))
		FROM tblPWALog a JOIN tblPWAdetailfunding b on a.ProjectId=b.projectid
		AND a.PWALogId=b.PWALogId
		WHERE b.MasterConstDivCodeID=@DivcodeId AND a.ProjectId=@ProjectId
		AND a.PWAStatusId in (4,5,7)
		
	SET @Result= isnull(@BudgetWithChangeOrders,0) + isnull(@TotalApprovedPWAFundingRequests,0)
	    - isnull(@TotalBuyOuts,0) - isnull(@AllCommittedPWAsByDivCode,0);
	    
	RETURN @Result;
END

GO

