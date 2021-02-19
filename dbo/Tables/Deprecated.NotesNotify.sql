CREATE TABLE [dbo].[Deprecated.NotesNotify] (
    [NotifyID]   INT      IDENTITY (1, 1) NOT NULL,
    [NoteID]     INT      NULL,
    [EntityID]   INT      NULL,
    [AddID]      INT      NULL,
    [AddDate]    DATETIME NULL,
    [ChangeID]   INT      NULL,
    [ChangeDate] DATETIME NULL,
    [Status]     INT      NULL,
    CONSTRAINT [PK_NotesNotify] PRIMARY KEY CLUSTERED ([NotifyID] ASC)
);


GO

