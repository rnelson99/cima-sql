CREATE TABLE [dbo].[tlkpVendorPricing] (
    [VendorPricing]     VARCHAR (255) NOT NULL,
    [VendorPricingSort] INT           NULL,
    CONSTRAINT [PK_tlkpVendorPricing] PRIMARY KEY CLUSTERED ([VendorPricing] ASC)
);


GO

