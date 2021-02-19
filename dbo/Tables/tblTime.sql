CREATE TABLE [dbo].[tblTime] (
    [TimeID]          INT            IDENTITY (1, 1) NOT NULL,
    [TimesheetID]     INT            NOT NULL,
    [ProjectID]       INT            NULL,
    [ActivityID]      INT            NULL,
    [TimeDescription] VARCHAR (255)  NULL,
    [HoursDay1]       DECIMAL (4, 2) NULL,
    [HoursDay2]       DECIMAL (4, 2) NULL,
    [HoursDay3]       DECIMAL (4, 2) NULL,
    [HoursDay4]       DECIMAL (4, 2) NULL,
    [HoursDay5]       DECIMAL (4, 2) NULL,
    [HoursDay6]       DECIMAL (4, 2) NULL,
    [HoursDay7]       DECIMAL (4, 2) NULL,
    [CreatedOn]       DATETIME       CONSTRAINT [DF_tblTime_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]     VARCHAR (255)  NULL,
    [ModifiedLast]    DATETIME       NULL,
    [UpdatedUser]     VARCHAR (255)  NULL,
    [IsDeleted]       VARCHAR (1)    CONSTRAINT [DF_tblTime_Deleted] DEFAULT ('N') NULL,
    [UserEntityID]    INT            NULL,
    CONSTRAINT [PK_tblTime] PRIMARY KEY CLUSTERED ([TimeID] ASC)
);


GO

