-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[JobStatusCheck]
	
AS
BEGIN
	
	SET NOCOUNT ON;
	truncate table logDatabase.dbo.jobstatus
Insert into logDatabase.dbo.jobstatus (totalRecordCount, process, threshold)
SELECT count(*) as totalRecordCount, 'Is Photo Thumbnail' as process, 25 as threshold
--into logdatabase.dbo.jobstatus
	FROM Documents.Documents
	where 1=1
	and documentid > 17274
	and
		(
		isphoto is null
			or
		FileNameOnly is null
		)
	and FileName is not null
union select count(*), 'Get Image Date Time', 30
	from Documents.Documents where IsPhoto = 1 and DateTimeTaken is null and len(isnull(FileNameOnly,'')) > 5 and isnull(deletedByUser,0) = 0
union select count(*), 'PDF Thumbnail Create',30
	from Documents.Documents
	where filename like '%.pdf%' and isnull(haveDocThumbnail,0) = 0
union select count(*), 'Task Reminders', 5
from tasks.reminders r
	join tasks.TaskList t on t.taskid = r.taskid and t.status = 1
	left join contacts.entity e on e.entityid = r.addid
	left join tblProject p on p.projectid = t.projectid
	where r.status = 1
	and cast(r.reminddate as date) <= cast(getdate() as date)
union select count(*), 'Send Pending Pushover', 5
from Tasks.BugIssues i
				join Tasks.TaskList t on t.TaskID = i.taskid and t.tasktype = 1
				left join Contacts.Entity e on e.EntityID = i.addid
				where DATEDIFF(SECOND,i.adddate,getdate()) > 300
				and i.newPushOver = 0
				and i.addid != i.assignedTo
				and i.changeid is null
	/*
	union select count(*), 'Photo Location', 5
	from Documents.Documents
    where MobileUpload = 1 and isnull(ReferenceID,0) = 0
    and DATEDIFF(D,adddate, getdate()) < 30
    and Latitude is not null
    and filename is not null
    and isnull(blackListedPhoto,0) = 0
	and isnull(deletedByUser,0) = 0

	select cast(cast(getdate() as date) as varchar(100))
	select LastWeatherPull, CIMA_Status from tblProject where CIMA_Status = 'Active' and isnull(smallproject,0) = 0 and isnull(LatitudeLongitude,'') != ''
	*/
union select 
	case when datepart(hour, getdate()) < 15 then 0 else count(*) end, 'Pull Weather History', 0
from tblproject
  where CIMA_Status in ('Active') 
  and isnull(smallProject,0) = 0
  and isnull(LastWeatherPull,'') != cast(cast(getdate()-1 as date) as varchar(100))
  and isnull(LatitudeLongitude,'') != ''
union select count(*), 'Make Sure Photos are Deleted', 5
 from Documents.Documents
    where deletedByUser = 1
    and (
        ReferenceID = 0
            or 
        datediff(D, adddate, getdate()) < 15
    )
	and summary != 'file not found'
union select count(*), 'Get EXIF Data - Lucee', 5
from Documents.Documents 
    where ReferenceID = 0
    and IsPhoto = 1
    and MobileUpload = 1
    and year(adddate) >= 2019
    and filename is not null
    and Latitude is null
    and isnull(noGPS,0) = 0
	and isnull(deletedByUser,0) = 0
	and status = 1
	and adddate > getdate() - 5


select * from logDatabase.dbo.jobstatus    where totalrecordcount > threshold 
    
END

GO

