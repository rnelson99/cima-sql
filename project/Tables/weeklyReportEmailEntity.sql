CREATE TABLE [project].[weeklyReportEmailEntity] (
    [id]          INT      IDENTITY (1, 1) NOT NULL,
    [entityid]    INT      NULL,
    [addid]       INT      NULL,
    [adddate]     DATETIME NULL,
    [status]      INT      NULL,
    [changeid]    INT      NULL,
    [changedate]  DATETIME NULL,
    [emailtype]   INT      NULL,
    [projectid]   INT      NULL,
    [sendToGroup] INT      NULL,
    CONSTRAINT [PK_weeklyReportEmailEntity] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

