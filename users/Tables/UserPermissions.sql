CREATE TABLE [users].[UserPermissions] (
    [ID]         INT      IDENTITY (1, 1) NOT NULL,
    [FunctionID] INT      NULL,
    [EntityID]   INT      NULL,
    [C]          INT      NULL,
    [R]          INT      NULL,
    [U]          INT      NULL,
    [D]          INT      NULL,
    [Y]          INT      NULL,
    [AddID]      INT      NULL,
    [AddDate]    DATETIME NULL,
    [ChangeID]   INT      NULL,
    [ChangeDate] DATETIME NULL,
    [Status]     INT      CONSTRAINT [DF_UserPermissions_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_UserPermissions] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

