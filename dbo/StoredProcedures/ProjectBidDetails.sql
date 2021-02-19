-- =============================================
-- Author:		Chris Hubbard - Custom System Solutions, LLC
-- Create date: 6/27/2016
-- Description:	this SPROC is used in projectbiddetails.cfm

-- =============================================
CREATE PROCEDURE [dbo].[ProjectBidDetails]
	@projectid int = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#ProjectSubID') IS NOT NULL DROP TABLE #ProjectSubID

	create table #ProjectSubID (ProjectSubContactID int, ProjectID int, VendorID int)

	insert into #ProjectSubID (ProjectSubContactID, ProjectID, VendorID)
	Select max(ProjectSubContactID), ProjectID, vendorid
	from tblProjectBidContact
	where projectid = @projectid
	group by ProjectID, vendorid

	select v.VendorID, v.Vendor, vc.FirstName, vc.LastName, vc.OfficePhone, vc.MobilePhone, vc.EMail, pc.AddDate, pc.AddID, pc.ContactType, pc.ContactResult,
		d.DivisionDescription, d.DivisionCode, pb.status as bidstatus, pb.bidding, pb.bidrec, pb.qualified, pb.drawings
	from tblVendor V
	join tblProjectBid PB on PB.VendorID = v.VendorID and pb.ProjectID = @projectid
	join tblConstDivCodes DC on pb.MasterConstDivCodeID = dc.CodeID
	join tblConstDiv D on d.DivisionID = dc.DivisionID
	left join tblVendorContact vc on vc.VendorId = v.VendorID and vc.primaryContactContracts = 1
	left join tblProjectBidContact PC on PC.ProjectID = pb.ProjectID and pc.vendorid = pb.VendorID
		and pc.ProjectSubContactID in (select ProjectSubContactID from #projectsubid)
	order by d.DivisionID, v.vendor
	
	--select * from tblProjectBid

	IF OBJECT_ID('tempdb..#ProjectSubID') IS NOT NULL DROP TABLE #ProjectSubID
END

GO

