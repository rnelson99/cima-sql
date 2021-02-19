CREATE TABLE [dbo].[tblProjectNotes] (
    [ProjectNoteID] INT           NOT NULL,
    [ProjectID]     INT           NULL,
    [AddId]         INT           NULL,
    [AddDate]       DATETIME      NULL,
    [Notes]         VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblProjectNotes] PRIMARY KEY CLUSTERED ([ProjectNoteID] ASC)
);


GO

