CREATE TABLE [Contacts].[Deprecated.GroupUsers] (
    [GroupUserID]     INT IDENTITY (1, 1) NOT NULL,
    [GroupID]         INT NULL,
    [EntityID]        INT NULL,
    [GroupUserStatus] INT CONSTRAINT [DF_GroupUsers_GroupUserStatus] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_GroupUsers] PRIMARY KEY CLUSTERED ([GroupUserID] ASC)
);


GO

