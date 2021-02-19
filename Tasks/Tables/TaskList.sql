CREATE TABLE [Tasks].[TaskList] (
    [TaskID]                   INT                IDENTITY (1, 1) NOT NULL,
    [ProjectID]                INT                NULL,
    [Importance]               INT                NULL,
    [Urgency]                  INT                NULL,
    [HiddenTill]               DATETIME           NULL,
    [SoftDue]                  DATETIME           NULL,
    [HardDue]                  DATETIME           NULL,
    [AddID]                    INT                NULL,
    [AddDate]                  DATETIME           NULL,
    [Summary]                  VARCHAR (255)      NULL,
    [LongDescription]          VARCHAR (MAX)      NULL,
    [AddressID]                INT                NULL,
    [Visibility]               INT                NULL,
    [ParentID]                 INT                NULL,
    [status]                   INT                CONSTRAINT [DF__TaskList__status__642DD430] DEFAULT ((1)) NULL,
    [TaskType]                 INT                NULL,
    [ChangeID]                 INT                NULL,
    [ChangeDate]               DATETIME           NULL,
    [CoreTask]                 BIT                CONSTRAINT [DF__TaskList__CoreTa__7EE1CA6C] DEFAULT ((1)) NULL,
    [Address]                  VARCHAR (255)      NULL,
    [PrivateTask]              BIT                CONSTRAINT [DF__TaskList__Privat__086B34A6] DEFAULT ((0)) NULL,
    [PersonalTask]             BIT                CONSTRAINT [DF__TaskList__Person__095F58DF] DEFAULT ((0)) NULL,
    [HiddenTask]               BIT                CONSTRAINT [DF__TaskList__Hidden__0A537D18] DEFAULT ((0)) NULL,
    [VendorID]                 INT                NULL,
    [HoldPayment]              INT                NULL,
    [HoldReason]               VARCHAR (1000)     NULL,
    [HoldBilling]              INT                NULL,
    [HoldBy]                   INT                NULL,
    [HoldDate]                 DATETIME           NULL,
    [HoldReleasedBy]           INT                NULL,
    [HoldReleasedDate]         DATETIME           NULL,
    [PWAppID]                  VARCHAR (100)      NULL,
    [Room]                     VARCHAR (50)       NULL,
    [Lvl]                      INT                NULL,
    [NoLocations]              VARCHAR (50)       NULL,
    [GridLines]                VARCHAR (50)       NULL,
    [LocateSiteX]              INT                NULL,
    [LocateSiteY]              INT                NULL,
    [LocateBldgX]              INT                NULL,
    [LocateBldgY]              INT                NULL,
    [SharedTask]               BIT                CONSTRAINT [DF__TaskList__Shared__0F183235] DEFAULT ((0)) NULL,
    [RepeatTask]               BIT                CONSTRAINT [DF__TaskList__Repeat__100C566E] DEFAULT ((0)) NULL,
    [RepeatTaskID]             INT                CONSTRAINT [DF__TaskList__Repeat__11007AA7] DEFAULT ((0)) NULL,
    [RepeatEvery]              INT                CONSTRAINT [DF__TaskList__Repeat__11F49EE0] DEFAULT ((0)) NULL,
    [RepeatInterval]           INT                CONSTRAINT [DF__TaskList__Repeat__12E8C319] DEFAULT ((0)) NULL,
    [RepeatUntil]              DATETIME           NULL,
    [RepeatKeepReminders]      INT                CONSTRAINT [DF__TaskList__Repeat__13DCE752] DEFAULT ((0)) NULL,
    [RepeatChildTasks]         INT                CONSTRAINT [DF__TaskList__Repeat__14D10B8B] DEFAULT ((0)) NULL,
    [RepeatUntilType]          INT                CONSTRAINT [DF__TaskList__Repeat__15C52FC4] DEFAULT ((0)) NULL,
    [RepeatUntilNumberOfTimes] INT                CONSTRAINT [DF__TaskList__Repeat__16B953FD] DEFAULT ((0)) NULL,
    [TaskTreeOrder]            INT                CONSTRAINT [DF__TaskList__TaskTr__1D66518C] DEFAULT ((0)) NULL,
    [areasection]              VARCHAR (50)       NULL,
    [BugStatus]                INT                NULL,
    [SubContracts]             VARCHAR (200)      NULL,
    [AppointmentType]          INT                NULL,
    [StartDate]                DATETIME           NULL,
    [EndDate]                  DATETIME           NULL,
    [AllDay]                   BIT                NULL,
    [TimeFlexible]             BIT                NULL,
    [DriveNoTraffic]           INT                NULL,
    [DriveTraffic]             INT                NULL,
    [DriveTimeToAppt]          BIT                NULL,
    [BufferTime]               INT                NULL,
    [dbGUID]                   VARCHAR (40)       NULL,
    [ChangeDateUTC]            DATETIME           NULL,
    [LocateSite]               VARCHAR (1000)     NULL,
    [LocateBldg]               VARCHAR (1000)     NULL,
    [ChangeDateUTC2]           DATETIMEOFFSET (7) NULL,
    [CalendarTimeUTC]          BIT                DEFAULT ((0)) NULL,
    [whoIsCovering]            INT                NULL,
    [WhoIsRequesting]          INT                NULL,
    [ParentGUID]               VARCHAR (50)       NULL,
    [PunchVerify]              INT                DEFAULT ((0)) NULL,
    [ToBeVerified]             INT                NULL,
    [VerifyID]                 INT                NULL,
    [VerifyDateTime]           DATETIME           NULL,
    [isDeleted]                INT                DEFAULT ((0)) NULL,
    [ListItemNum]              INT                NULL,
    [MiscVar1]                 VARCHAR (100)      NULL,
    [PunchListStatus]          INT                CONSTRAINT [DF_TaskList_PunchListStatus] DEFAULT ((420)) NULL,
    [BugAssignment]            INT                NULL,
    [BugAssignmentCC]          INT                NULL,
    [tmpInt]                   INT                NULL,
    [CloseID]                  INT                NULL,
    [CloseDate]                DATETIME           NULL,
    [ViewID]                   INT                NULL,
    [ViewDate]                 DATETIME           NULL,
    [CloneFromID]              INT                NULL,
    [TaskCloned]               INT                NULL,
    [ClientID]                 INT                DEFAULT ((0)) NULL,
    [verified]                 INT                NULL,
    [verifiedDateTime]         DATETIME           NULL,
    [customSorter]             INT                DEFAULT ((0)) NULL,
    [WebAppUpdated]            INT                DEFAULT ((0)) NULL,
    [mobilePunch]              INT                NULL,
    [UpcomingWorkload]         INT                NULL,
    [PercentComplete]          FLOAT (53)         NULL,
    [DoAfterTaskID]            INT                NULL,
    [vendorWarning]            INT                NULL,
    [vendorWarningAllProjects] INT                NULL,
    [notifiedDeveloper]        INT                DEFAULT ((0)) NULL,
    CONSTRAINT [PK_TaskList] PRIMARY KEY CLUSTERED ([TaskID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [Status_Index]
    ON [Tasks].[TaskList]([status] ASC)
    INCLUDE([TaskID], [ProjectID]);


GO

CREATE NONCLUSTERED INDEX [dbGUID_Index]
    ON [Tasks].[TaskList]([dbGUID] ASC)
    INCLUDE([TaskID], [ParentID], [status]);


GO

CREATE NONCLUSTERED INDEX [ProjectID]
    ON [Tasks].[TaskList]([ProjectID] ASC)
    INCLUDE([TaskID], [TaskType]);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Tasks].[taskList_Trigger]
   ON  [Tasks].[TaskList] 
   AFTER Insert,Update,Delete
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	

	--update Tasks.TaskList set Summary = 'Task: ' + cast(taskid as varchar(100)) where isnull(ltrim(rtrim(summary)), '') = ''


    Update tasks.tasklist set ChangeDate = getdate(), ChangeDateUTC = getdate()
			where TaskID in (Select taskid from inserted)

	update Tasks.TaskList set status = 0 where BugStatus = 0 and TaskType in (24,25) and status = 1 and TaskID in (Select taskid from inserted)
END

GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create TRIGGER Tasks.TaskTriggerInsert
   ON  tasks.tasklist
   AFTER Insert
AS 
BEGIN
	
	SET NOCOUNT ON;

	Insert into tasks.TaskChange (TaskID,modifieddate)
	Select TaskID, getdate()
	from inserted
	
END

GO

-- =============================================
-- Author:		Chris Hubbard
-- Create date: 7/25/2019
-- Description:	This is going to capture changes 
-- =============================================
create TRIGGER Tasks.TaskTriggerUpdate
   ON  Tasks.TaskList
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	
    
	update tasks.TaskChange set modifieddate = getdate() where taskid in (Select taskid from inserted)
END

GO

