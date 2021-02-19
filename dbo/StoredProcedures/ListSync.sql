

--exec dbo.ListSync 26,1,0,'aaa', 2

CREATE PROCEDURE [dbo].[ListSync]
	@UserID int, @RunQuery int = 1, @ProcCalled int = 0, @ProcGUID varchar(50), @ListType int = 0, @PunchListGUID varchar(100) = ''
AS
BEGIN
	SET NOCOUNT ON;
		
		IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

/*
where t.tasktype = 2 
and t.status = 0 
and isnull(t.punchverify,0) = 0 
and isnull(t.parentid,0) > 0
*/


Update Tasks.TaskList set status = -1 
	where ParentID in (Select distinct taskid from Tasks.TaskList where status = -1) 
	and status > -1

update Tasks.TaskList set status = 0, ChangeDate = getdate()
	where 
		taskid in (
					select distinct t.taskid
					from Tasks.TaskList t
					join (select taskid, ParentID from tasks.TaskList where tasktype in (2,3) and isnull(parentid,0) > 0 and status = 0) tt on tt.ParentID = t.taskid 	
			)
	and 
		taskid not in (
					select distinct t.taskid
					from Tasks.TaskList t
					join (select taskid, ParentID from tasks.TaskList where tasktype in (2,3) and isnull(parentid,0) > 0 and status = 1) tt on tt.ParentID = t.taskid 			
			)
	and TaskType = 2 
	and isnull(parentid,0) = 0 
	and status = 1



;with cte as (
			select t.dbGUID, t.status, t.ChangeDateUTC, cter.ct, t.AddID, isnull(cter2.ct,0) as ct2, a.EntityID, t.TaskType, 1 as ThisIsUsersTask, t.TaskID,
					case when t.SoftDue is null and t.HardDue is null then 1 when t.SoftDue < getdate() or t.HardDue < getdate() then 2 else 3 end as TaskSorter,
					t.SoftDue, t.HardDue, isnull(t.PunchVerify,0) as PunchVerify, isnull(ps1.EntityID,0) as PM, isnull(ps2.EntityID,0) as Sup, t.VerifyID, t.isDeleted
				from tasks.TaskList t
				left join tblProject p on p.projectid = t.projectid
				left join Contacts.Entity E on E.EntityID = t.addid
				left join tasks.assigned a on a.taskid = t.taskid and a.entityid = @UserID
				left join (select count(*) as ct, taskid from tasks.assigned where EntityID != @userid group by taskid) cter2 on cter2.TaskID = t.taskid
				left join (select count(*) as ct, taskid from tasks.assigned group by taskid) cter on cter.TaskID = t.taskid
				left join Contacts.Entity E1 on E1.EntityID = a.EntityID
				left join tblProjectStaff ps1 on ps1.ProjectID = t.ProjectID and ps1.StaffRole = 'PM' and isnull(ps1.PunchVerify,0) = 1
				left join tblProjectStaff ps2 on ps2.ProjectID = t.ProjectID and ps2.StaffRole = 'Super' and isnull(ps2.PunchVerify,0) = 1
			)

		Select * into #Results from cte 
		where 1=1 and (
				entityid = @UserID
					or
				(addid = @UserID )--ct2 = 0 and 
					or
				pm = @UserID
					or
				Sup = @UserID
					or 
				VerifyID = @UserID
					or
				taskid in (select taskid from Tasks.BugIssues where AssignedTo = @userid and status not in (5,6,7,8))
			)
		order by TaskSorter, SoftDue, HardDue

		if @ListType = 1
			begin 
				Delete from #Results where TaskType != 1
			end
		if @ListType = 2
			begin 
				Delete from #Results where TaskType not in (2,3)
					if len(@PunchListGUID) > 1
						begin
							Delete from #Results 
							where 1=1
							and TaskID not in (
												select taskid from Proview.Tasks.TaskList 
												where ParentGUID = @PunchListGUID
												or dbGUID = @PunchListGUID
											)
						end
			end

		if exists (select count(*) as ct, dbguid,ProcGUID 		from 		proviewTemp.dbo.ListSync	where ProcGUID = @ProcGUID	group by DBGUID,ProcGUID		having count(*) > 1)
			begin
				select 0 as ReturnCode, 'Warning: Failed Master Key Test. You sent duplicate DBGUID(s)' as ReturnMessage, @ProcCalled
			end
		else
			begin
				--This will return back the GUIDs that I need because I do not have them
				select l.dbguid, c.isDeleted as IsDeleted, 1 as ReturnCode, 'Good' as ReturnMessage, @ProcCalled as ProcCalled,'DontHave' as Msg2, l.ModifiedDate as LastModifiedDateIOS,c.ChangeDateUTC, DATEDIFf(SECOND, l.ModifiedDate,c.ChangeDateUTC) as DtDiff, 3 as Sorter, TaskSorter as TEMP_Sorter, SoftDue as Temp_Soft, HardDue as Temp_Hard, c.TaskID as temp_TaskID, TaskType as temp_TaskType
				from proviewTemp.dbo.ListSync L
				left join #Results c on c.dbguid = l.DBGUID  
				where c.dbGUID is null
					and l.ProcGUID = @ProcGUID
				--This will return back the GUID's that they need because they don't have them
				union 
				select c.dbguid, c.isDeleted as IsDeleted, 1 as ReturnCode, 'Good' as ReturnMessage, @ProcCalled,'AppDoesntHave', l.ModifiedDate,c.ChangeDateUTC ,DATEDIFf(SECOND, l.ModifiedDate,c.ChangeDateUTC), 1 as Sorter, TaskSorter, SoftDue, HardDue, c.TaskID as temp_TaskID, TaskType as temp_TaskType
				from #Results c
				left join proviewTemp.dbo.ListSync L on c.dbguid = l.DBGUID and l.ProcGUID = @ProcGUID
				where l.dbGUID is null and c.status = 1 and TaskType in (1,2,3) and ThisIsUsersTask = 1
				--These are the GUID's that do not have the same modified date
				union select c.dbguid, c.isDeleted as IsDeleted, 1 as ReturnCode, 'Good' as ReturnMessage, @ProcCalled,'DiffModified', l.ModifiedDate,c.ChangeDateUTC, DATEDIFf(SECOND, l.ModifiedDate,c.ChangeDateUTC), 2 as Sorter, TaskSorter, SoftDue, HardDue, c.TaskID as temp_TaskID, TaskType as temp_TaskType
				from #Results c
				join proviewTemp.dbo.ListSync L on c.dbguid = l.DBGUID 
					and l.ProcGUID = @ProcGUID
					and 
						(
							DATEDIFf(SECOND, l.ModifiedDate,c.ChangeDateUTC) > 5
								or
							DATEDIFf(SECOND, l.ModifiedDate,c.ChangeDateUTC) < -5
						)
				Union select c.dbGUID, c.isDeleted as IsDeleted, 1, 'Good', @ProcCalled, 'PunchVerify',getdate(), getdate(), 0, 4 as Sorter, 99 as TaskSorter, getdate() as SoftDue, getdate() as HardDue, c.TaskID as temp_TaskID, TaskType as temp_TaskType
				from #Results c
				where c.VerifyID = @userid and c.status = 0 and isnull(c.PunchVerify,0) = 0 

				Order by Sorter, TaskSorter, SoftDue, HardDue
			end

			
		IF OBJECT_ID('tempdb..#Results') IS NOT NULL
			DROP TABLE #Results
    
END

GO

