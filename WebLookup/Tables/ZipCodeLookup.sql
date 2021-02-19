CREATE TABLE [WebLookup].[ZipCodeLookup] (
    [ZipCode]     INT           NOT NULL,
    [ZipCodeText] VARCHAR (15)  NULL,
    [City]        VARCHAR (100) NULL,
    [State]       VARCHAR (100) NULL,
    [StateAbbr]   VARCHAR (10)  NULL,
    [County]      VARCHAR (100) NULL,
    CONSTRAINT [PK_zipCodes_1] PRIMARY KEY CLUSTERED ([ZipCode] ASC)
);


GO

