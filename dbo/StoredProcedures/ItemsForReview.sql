-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[ItemsForReview]
	@userid int,
	@grouping int = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#ReviewNeeded') IS NOT NULL DROP TABLE #ReviewNeeded

	create table #ReviewNeeded (approver1 int, approver2 int, approver3 int, varMisc1 varchar(100), varMisc2 varchar(100), dbID int, sTable varchar(100), reviewtype varchar(100), addid int, adddate datetime, needapprover1 int, needapprover2 int, needapprover3 int)

	if @userid = 1 or @userid = 26
	begin
		Insert into #ReviewNeeded (approver1, approver2, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate, needapprover1, needapprover2, needapprover3)
		select approver1, approver2, ProjectNum, ProjectName, projectid, 'tblProject', 'New Project', addid, adddate,
			case when approver1 is null and (@userid = 1 or @userid = 26) then 1 else 0 end as needapprover1,
			case when approver2 is null and (@userid = 5 or @userid = 26) then 1 else 0 end as needapprover2,
			0
		from tblProject 
		where approver1 is null
	end

	if @userid = 5
	begin
		Insert into #ReviewNeeded (approver1, approver2, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate, needapprover1, needapprover2, needapprover3)
		select approver1, approver2, ProjectNum, ProjectName, projectid, 'tblProject', 'New Project', addid, adddate,
			case when approver1 is null and (@userid = 1 or @userid = 26) then 1 else 0 end as needapprover1,
			case when approver2 is null and (@userid = 5 or @userid = 26) then 1 else 0 end as needapprover2,
			0
		from tblProject 
		where approver2 is null
	end	

	if @userid = 5
	begin
		Insert into #ReviewNeeded (approver1, approver3, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate, needapprover1, needapprover2, needapprover3)
		select approver1, approver3, ProjectNum, ProjectName, projectid, 'tblProject', 'New Project', addid, adddate,
			case when approver1 is null and (@userid = 1 or @userid = 26) then 1 else 0 end as needapprover1,
			case when approver2 is null and (@userid = 5 or @userid = 26) then 1 else 0 end as needapprover2,
			0
		from tblProject 
		where approver3 is null
	end	

	if @userid = 1 or @userid = 26
	begin
		Insert into #ReviewNeeded (approver1, approver2, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate, needapprover1, needapprover2, needapprover3)
		Select	case when isnull(a1.AttributeID,0) = 0 then 0 else 1 end as Approver1,
			case when isnull(a2.AttributeID,0) = 0 then 0 else 1 end as Approver2,
			isnull(e.lastname,''), '', e.entityid, 'ClientEntity', 'New Client',
			e.addid, e.adddate,
			1,0,0
		from Contacts.Entity e
		join Contacts.EntityType et on et.EntityID = e.EntityID and et.Type = 20 and et.Status = 1
		left join Contacts.Attributes a1 on a1.EntityID = e.EntityID and a1.attributetype = 'clientApprover1' and a1.status = 1
		left join Contacts.Attributes a2 on a2.EntityID = e.EntityID and a2.attributetype = 'clientApprover2' and a2.status = 1
		where case when isnull(a1.AttributeID,0) = 0 then 0 else 1 end = 0
		and e.EntityID > 4426 and e.status = 1
	end

	if @userid = 5
	begin
		Insert into #ReviewNeeded (approver1, approver2, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate, needapprover1, needapprover2, needapprover3)
		Select	case when isnull(a1.AttributeID,0) = 0 then 0 else 1 end as Approver1,
			case when isnull(a2.AttributeID,0) = 0 then 0 else 1 end as Approver2,
			isnull(e.lastname,''), '', e.entityid, 'ClientEntity', 'New Client',
			e.addid, e.adddate,
			0,1,0
		from Contacts.Entity e
		join Contacts.EntityType et on et.EntityID = e.EntityID and et.Type = 20 and et.Status = 1
		left join Contacts.Attributes a1 on a1.EntityID = e.EntityID and a1.attributetype = 'clientApprover1' and a1.status = 1
		left join Contacts.Attributes a2 on a2.EntityID = e.EntityID and a2.attributetype = 'clientApprover2' and a2.status = 1
		where case when isnull(a2.AttributeID,0) = 0 then 0 else 1 end = 0
		and e.EntityID > 4426  and e.status = 1
	end
	if @userid = 6
	begin
		Insert into #ReviewNeeded (approver1, approver2, approver3, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate, needapprover1, needapprover2, needapprover3)
		Select	case when isnull(a1.AttributeID,0) = 0 then 0 else 1 end as Approver1,
			case when isnull(a2.AttributeID,0) = 0 then 0 else 1 end as Approver2,
			case when isnull(a2.AttributeID,0) = 0 then 0 else 1 end as Approver3,
			isnull(e.lastname,''), '', e.entityid, 'ClientEntity', 'New Client'
			, e.addid, e.adddate,
			0,0,1
		from Contacts.Entity e
		join Contacts.EntityType et on et.EntityID = e.EntityID and et.Type = 20 and et.Status = 1
		left join Contacts.Attributes a1 on a1.EntityID = e.EntityID and a1.attributetype = 'clientApprover1' and a1.status = 1
		left join Contacts.Attributes a2 on a2.EntityID = e.EntityID and a2.attributetype = 'clientApprover2' and a2.status = 1
		left join Contacts.Attributes a3 on a3.EntityID = e.EntityID and a3.attributetype = 'clientApprover3' and a3.status = 1
		where case when isnull(a2.AttributeID,0) = 0 then 0 else 1 end = 0
		and e.EntityID > 4426  and e.status = 1
	end 


	if exists (select top 1 id from users.UserPermissions where FunctionID in (1,30) and EntityID = @userid)
	begin
		--need to get the pwa items pending approval
		Insert into #ReviewNeeded (approver1, approver2, approver3, varMisc1, varMisc2, dbID, sTable, reviewtype, addid, adddate)
		Select @userid, 0, 0, Reason, 'Pay App Status Change', ID, 'tblSubPayAppStatusChange', 'Pay App Status Change', addid, adddate
		from tblSubPayAppStatusChange
		where SubPayAppID in (Select subpayappid from accounting.SubPayApp)
		and ApprovalNeeded = 1
	end

	delete from #ReviewNeeded where needapprover1 = 0 and needapprover2 = 0 and needapprover3 = 0

	if @grouping = 0
	begin
		Select r.*, isnull(e.FirstName,'') as firstname, left(isnull(e.LastName,''),1) as lastname
		from #ReviewNeeded r
		left join Contacts.Entity e on e.EntityID = r.addid
	end
	if @grouping = 1
	begin
		Select distinct reviewtype from #ReviewNeeded
	end
END

--exec dbo.ItemsForReview 26,0

GO

