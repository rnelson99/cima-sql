CREATE TABLE [project].[Notes] (
    [NoteID]     INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]  INT           NOT NULL,
    [Message]    VARCHAR (255) NULL,
    [AddID]      INT           NOT NULL,
    [AddDate]    DATETIME      DEFAULT (getdate()) NULL,
    [ChangeID]   INT           NULL,
    [ChangeDate] DATETIME      NULL,
    [Deleted]    DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([NoteID] ASC)
);


GO

