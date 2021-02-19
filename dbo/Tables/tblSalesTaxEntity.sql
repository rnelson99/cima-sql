CREATE TABLE [dbo].[tblSalesTaxEntity] (
    [LocalCode]     VARCHAR (12)    NOT NULL,
    [Jurisdiction]  VARCHAR (255)   NULL,
    [TaxRate]       DECIMAL (18, 6) NOT NULL,
    [EffectiveDate] DATETIME        DEFAULT (getdate()) NOT NULL,
    [status]        INT             DEFAULT ((1)) NULL,
    [AddID]         INT             NULL,
    [AddDate]       DATETIME        NULL,
    [ChangeID]      INT             NULL,
    [ChangeDate]    DATETIME        NULL,
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblSalesTaxEntity] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

