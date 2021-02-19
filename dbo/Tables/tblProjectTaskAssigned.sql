CREATE TABLE [dbo].[tblProjectTaskAssigned] (
    [ProjectTaskAssignedID] INT  NULL,
    [ProjectTaskID]         INT  NULL,
    [ProjectID]             INT  NULL,
    [UserTo]                INT  NULL,
    [UserFrom]              INT  NULL,
    [UserDue]               DATE NULL,
    [UserStatus]            INT  NULL,
    [RemindUser]            BIT  DEFAULT ((1)) NULL
);


GO

