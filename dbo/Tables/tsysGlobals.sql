CREATE TABLE [dbo].[tsysGlobals] (
    [GlobalID]            INT             NOT NULL,
    [GlobalName]          NVARCHAR (75)   NULL,
    [GlobalWhereUsed]     NVARCHAR (255)  NULL,
    [GlobalValueText]     NVARCHAR (255)  NULL,
    [GlobalValueMemo]     VARCHAR (MAX)   NULL,
    [GlobalValueDateTime] DATETIME        NULL,
    [GlobalValueInt]      INT             NULL,
    [GlobalValueDecimal]  DECIMAL (18, 2) NULL,
    [GlobalValueCurrency] MONEY           NULL,
    [GlobalValueBoolean]  BIT             NOT NULL
);


GO

