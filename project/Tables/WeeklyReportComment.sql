CREATE TABLE [project].[WeeklyReportComment] (
    [CommentID]       INT            IDENTITY (1, 1) NOT NULL,
    [WeeklyReportID]  INT            NULL,
    [Comment]         VARCHAR (1000) NULL,
    [AddID]           INT            NULL,
    [AddDate]         DATETIME       NULL,
    [ChangeID]        INT            NULL,
    [ChangeDate]      DATETIME       NULL,
    [Status]          INT            DEFAULT ((1)) NULL,
    [OutstandingItem] INT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_WeeklyReportComment] PRIMARY KEY CLUSTERED ([CommentID] ASC)
);


GO

