CREATE TABLE [Contacts].[Forms] (
    [FormID]     INT      IDENTITY (1, 1) NOT NULL,
    [EntityID]   INT      NULL,
    [FormType]   INT      NULL,
    [Executed]   DATETIME NULL,
    [Filed]      INT      NULL,
    [Expires]    DATETIME NULL,
    [Status]     INT      NULL,
    [AddID]      INT      NULL,
    [AddDate]    DATETIME NULL,
    [ChangeID]   INT      NULL,
    [ChangeDate] DATETIME NULL,
    [DocumentID] INT      NULL,
    CONSTRAINT [PK_Forms] PRIMARY KEY CLUSTERED ([FormID] ASC)
);


GO

