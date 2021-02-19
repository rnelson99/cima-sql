CREATE TABLE [users].[UserPushOverAPI] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [EntityID]     INT           NULL,
    [PushOverUser] VARCHAR (100) NULL,
    [Status]       INT           NULL,
    CONSTRAINT [PK_UserPushOverAPI] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

