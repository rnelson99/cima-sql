CREATE TABLE [Contacts].[EntityType] (
    [EntityTypeID] INT      IDENTITY (1, 1) NOT NULL,
    [EntityID]     INT      NULL,
    [Type]         INT      NULL,
    [AddDate]      DATETIME NULL,
    [AddID]        INT      NULL,
    [ChangeDate]   DATETIME NULL,
    [ChangeID]     INT      NULL,
    [Status]       INT      NULL,
    [var1]         INT      NULL,
    CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED ([EntityTypeID] ASC)
);


GO

