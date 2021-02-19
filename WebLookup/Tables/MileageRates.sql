CREATE TABLE [WebLookup].[MileageRates] (
    [id]   INT   IDENTITY (1, 1) NOT NULL,
    [yr]   INT   NULL,
    [rate] MONEY NULL,
    CONSTRAINT [PK_MileageRates] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

