CREATE TABLE [dbo].[tblVendorSupplier] (
    [VendorSupplierID]    INT            IDENTITY (1, 1) NOT NULL,
    [VendorID]            INT            NOT NULL,
    [EffectiveDate]       DATETIME       NULL,
    [EndDate]             DATETIME       NULL,
    [JointCheckAgreement] NVARCHAR (255) NULL,
    [SupplierID]          INT            NULL,
    CONSTRAINT [PK_tblVendorSupplier] PRIMARY KEY CLUSTERED ([VendorSupplierID] ASC)
);


GO

