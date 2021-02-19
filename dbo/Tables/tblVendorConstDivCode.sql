CREATE TABLE [dbo].[tblVendorConstDivCode] (
    [VendorConstDivCodeID] INT            IDENTITY (1, 1) NOT NULL,
    [VendorID]             INT            NULL,
    [MasterConstDivCodeID] INT            NOT NULL,
    [EntityID]             INT            NULL,
    [Limitations]          VARCHAR (1000) NULL,
    [Status]               INT            NULL,
    [AddID]                INT            NULL,
    [AddDate]              DATETIME       NULL,
    [ChangeID]             INT            NULL,
    [ChangeDate]           DATETIME       NULL,
    CONSTRAINT [VendorWorkItemID] PRIMARY KEY CLUSTERED ([VendorConstDivCodeID] ASC)
);


GO

