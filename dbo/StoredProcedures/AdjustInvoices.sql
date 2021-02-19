
CREATE PROCEDURE dbo.AdjustInvoices
AS
DECLARE	@ProjectId int
DECLARE	@ProjectStartDate datetime
DECLARE	@BaseContract money
DECLARE ProjectCursor CURSOR FOR
SELECT ProjectId, ProjectStartDate, CIMA_Bid
FROM tblProject WHERE ProjectStartDate IS NOT NULL
    AND CIMA_Bid IS NOT NULL
OPEN ProjectCursor
FETCH NEXT FROM ProjectCursor
INTO @ProjectId, @ProjectStartDate, @BaseContract
WHILE @@FETCH_STATUS=0
BEGIN
	EXEC AdjustProjectInvoices @ProjectId, @ProjectStartDate, @BaseContract
	FETCH NEXT FROM ProjectCursor
	INTO @ProjectId, @ProjectStartDate, @BaseContract
END
CLOSE ProjectCursor;
DEALLOCATE ProjectCursor;

GO

