CREATE TABLE [dbo].[tblTimesheet] (
    [TimesheetID]               INT           IDENTITY (1, 1) NOT NULL,
    [UserSecurityID]            INT           NOT NULL,
    [TimesheetStatusID]         INT           NOT NULL,
    [TimesheetYear]             INT           NOT NULL,
    [TimesheetWeek]             INT           NOT NULL,
    [IsDeleted]                 VARCHAR (1)   CONSTRAINT [DF_tblTimesheet_IsDeleted] DEFAULT ('N') NULL,
    [CreatedOn]                 DATETIME      CONSTRAINT [DF_tblTimesheet_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]               VARCHAR (255) NULL,
    [ModifiedLast]              DATETIME      NULL,
    [UpdatedUser]               VARCHAR (255) NULL,
    [PayDate]                   DATETIME      NULL,
    [FirstSubmittedDateTime]    DATETIME      NULL,
    [FirstSubmittedUser]        VARCHAR (255) NULL,
    [LastSubmittedDateTime]     DATETIME      NULL,
    [LastSubmittedUser]         VARCHAR (255) NULL,
    [ApprovedDateTime]          DATETIME      NULL,
    [ApprovedUser]              VARCHAR (255) NULL,
    [FirstReportedPaidDateTime] DATETIME      NULL,
    [FirstReportedPaidUser]     VARCHAR (255) NULL,
    [LastReportedPaidDateTime]  DATETIME      NULL,
    [LastReportedPaidUser]      VARCHAR (255) NULL,
    [UserEntityID]              INT           NULL,
    CONSTRAINT [PK_tblTimesheet] PRIMARY KEY CLUSTERED ([TimesheetID] ASC)
);


GO


CREATE TRIGGER dbo.TimeSheetUpdate
   ON  dbo.tblTimesheet
   AFTER INSERT,Update, Delete
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	update s
		set s.UserEntityID = e.EntityID
	from tblTimesheet s
	join Contacts.Entity e on e.LegacyID = s.UserSecurityID and e.LegacyTable = 'User'
	where s.userEntityid is null

END

GO

