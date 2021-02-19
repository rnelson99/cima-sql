CREATE TABLE [Contacts].[Deprecated.EDocumentApproval] (
    [EDocumentID] INT      IDENTITY (1, 1) NOT NULL,
    [EntityID]    INT      NULL,
    [SubEntityID] INT      NULL,
    [MaxLimit]    INT      NULL,
    [Security]    INT      NULL,
    [Status]      INT      NULL,
    [AddDate]     DATETIME NULL,
    [AddID]       INT      NULL,
    [ChangeDate]  DATETIME NULL,
    [ChangeID]    INT      NULL,
    CONSTRAINT [PK_EDocumentApproval] PRIMARY KEY CLUSTERED ([EDocumentID] ASC)
);


GO

