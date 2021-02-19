CREATE TABLE [Documents].[DefaultRouting] (
    [DefaultRoutingID] INT      IDENTITY (1, 1) NOT NULL,
    [DocumentType]     INT      NULL,
    [SecDocumentType]  INT      NULL,
    [EntityID]         INT      NULL,
    [Status]           INT      NULL,
    [AddID]            INT      NULL,
    [AddDate]          DATETIME NULL,
    [ChangeID]         INT      NULL,
    [ChangeDate]       DATETIME NULL,
    CONSTRAINT [PK_DefaultRouting] PRIMARY KEY CLUSTERED ([DefaultRoutingID] ASC)
);


GO

