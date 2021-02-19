CREATE TABLE [dbo].[UserCRUD] (
    [UserID]       INT NULL,
    [PermissionID] INT IDENTITY (1, 1) NOT NULL,
    [FunctionID]   INT NULL,
    [C]            BIT NULL,
    [R]            BIT NULL,
    [U]            BIT NULL,
    [D]            BIT NULL,
    CONSTRAINT [PK_UserCRUD] PRIMARY KEY CLUSTERED ([PermissionID] ASC)
);


GO

