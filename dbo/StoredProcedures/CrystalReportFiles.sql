-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE dbo.CrystalReportFiles
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- declare @files table (ID int IDENTITY, FileName varchar(100))
		IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
		create table #tmp (id int IDENTITY, filename varchar(100))

		insert into #tmp execute xp_cmdshell 'dir E:\crystalReports /b'

		alter table #tmp add processed int 

		-- select * from #tmp where FileName like '%.rpt%'

		update l
		set l.status = 1
		from [WebLookup].[CrystalReportList] l
		join #tmp t on t.filename = l.filename

		
		Insert into WebLookup.CrystalReportList (filename)
		select t.filename
		from #tmp t
		left join WebLookup.CrystalReportList l on t.filename = l.filename
		where t.filename like '%.rpt%' and l.id is null

END

GO

