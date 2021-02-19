CREATE TABLE [Contacts].[Deprecated.ClientSubDirectPay] (
    [Id]             INT      IDENTITY (1, 1) NOT NULL,
    [ClientEntityId] INT      NOT NULL,
    [VendorEntityId] INT      NOT NULL,
    [EffectiveDate]  DATETIME NULL,
    [EndDate]        DATETIME NULL,
    [Client1099]     INT      NULL,
    [Status]         INT      DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblClientSubDirectPay] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

