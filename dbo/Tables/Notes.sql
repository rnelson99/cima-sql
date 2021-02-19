CREATE TABLE [dbo].[Notes] (
    [NoteID]        INT           IDENTITY (1, 1) NOT NULL,
    [ReferenceID]   INT           NULL,
    [ReferenceType] INT           NULL,
    [AddID]         INT           NULL,
    [AddDate]       DATETIME      NULL,
    [Note]          VARCHAR (MAX) NULL,
    [NoteType]      INT           DEFAULT ((1)) NULL,
    [ParentNoteID]  INT           DEFAULT ((0)) NULL,
    [AssignID]      INT           DEFAULT ((0)) NULL,
    [tempGUID]      VARCHAR (50)  NULL,
    [NoteGUID]      VARCHAR (50)  NULL,
    [isDelete]      INT           DEFAULT ((0)) NULL,
    [ChangeID]      INT           NULL,
    [ChangeDate]    DATETIME      NULL,
    [isIssue]       INT           DEFAULT ((0)) NULL,
    [Summary]       VARCHAR (100) NULL,
    [isEdited]      INT           NULL,
    [notified]      INT           NULL,
    CONSTRAINT [PK_Notes] PRIMARY KEY CLUSTERED ([NoteID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190601-081909]
    ON [dbo].[Notes]([ReferenceID] ASC, [ReferenceType] ASC)
    INCLUDE([NoteID]);


GO

