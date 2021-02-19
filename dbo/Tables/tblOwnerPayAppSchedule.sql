CREATE TABLE [dbo].[tblOwnerPayAppSchedule] (
    [Id]           INT         IDENTITY (1, 1) NOT NULL,
    [ProjectId]    INT         NOT NULL,
    [PayAppNumber] INT         NOT NULL,
    [Date]         DATETIME    NOT NULL,
    [Comment]      NCHAR (255) NULL,
    CONSTRAINT [PK_tblOwnerPayAppSchedule] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

