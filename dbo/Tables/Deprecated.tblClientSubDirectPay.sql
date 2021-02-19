CREATE TABLE [dbo].[Deprecated.tblClientSubDirectPay] (
    [Id]            INT      IDENTITY (1, 1) NOT NULL,
    [ClientId]      INT      NOT NULL,
    [VendorId]      INT      NOT NULL,
    [EffectiveDate] DATETIME NULL,
    [EndDate]       DATETIME NULL,
    CONSTRAINT [PK_tblClientSubDirectPay] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_tblClientSubDirectPay]
    ON [dbo].[Deprecated.tblClientSubDirectPay]([ClientId] ASC, [VendorId] ASC);


GO

