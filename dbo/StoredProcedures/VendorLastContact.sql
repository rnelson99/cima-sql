-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.VendorLastContact
AS
BEGIN
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	IF OBJECT_ID('tempdb..#toUpdate') IS NOT NULL DROP TABLE #toUpdate

	;with cte as (
	select VendorEntityID as EntityID, TransactionDate as dt, 0 as AttributeTbl
	from tblExpense where VendorEntityID is not null
	union select entityid, PWALogDateIssued , 0 as AttributeTbl
	from tblPWALog where entityid is not null
	union select distinct l.EntityID, ProjectStartDate, 0 as AttributeTbl
	from tblProject p
	join tblPWALog l on l.ProjectID = p.ProjectID and l.EntityID is not null
	where ProjectStartDate is not null
	union select EntityID, attribute, 1 as AttributeTbl
	from Contacts.Attributes 
	where attributetype = 'EntityLastContact' and isnull(attribute,'') != '' and status = 1
	)

	Select EntityID, max(dt) as LastContactDate
	into #Results
	from cte
	group by EntityID

	select r.EntityID, r.LastContactDate, a.attribute, case when a.attribute is null then 1 when r.LastContactDate > a.attribute then 1 else 0 end as UpdateValue
	into #toUpdate
	from #Results r
	left join Contacts.Attributes a on a.EntityID = r.EntityID and a.status = 1 and a.attributetype = 'EntityLastContact'

	Update Contacts.Attributes set status = 0, changeid = 0, changedate = getdate() where entityid in (Select EntityID from #toUpdate where UpdateValue = 1) and status = 1 and attributetype = 'EntityLastContact'

	Insert into Contacts.Attributes (EntityID, attribute, status, attributetype, AddDate, AddID)
	Select EntityID, LastContactDate, 1, 'EntityLastContact', getdate(), 0
	from #toUpdate
	where UpdateValue = 1

END

GO

