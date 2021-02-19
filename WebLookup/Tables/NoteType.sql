CREATE TABLE [WebLookup].[NoteType] (
    [NoteTypeID]  INT           NULL,
    [NoteType]    VARCHAR (100) NULL,
    [ProjectNote] INT           DEFAULT ((1)) NULL,
    [VendorNote]  INT           DEFAULT ((1)) NULL,
    [ClientNote]  INT           DEFAULT ((1)) NULL
);


GO

