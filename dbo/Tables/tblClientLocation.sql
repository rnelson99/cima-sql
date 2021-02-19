CREATE TABLE [dbo].[tblClientLocation] (
    [LocationId]        INT          IDENTITY (1, 1) NOT NULL,
    [ClientId]          INT          NOT NULL,
    [DefaultLocation]   BIT          DEFAULT ((0)) NOT NULL,
    [LocationCompany]   VARCHAR (95) NULL,
    [LocationStreet]    VARCHAR (55) NULL,
    [LocationStreet2]   VARCHAR (55) NULL,
    [LocationCity]      VARCHAR (45) NULL,
    [LocationState]     VARCHAR (3)  NULL,
    [Zip]               VARCHAR (10) NULL,
    [LocationMainPhone] VARCHAR (25) NULL,
    [LocationMainFax]   VARCHAR (25) NULL,
    CONSTRAINT [tblClientLocation_PK] PRIMARY KEY NONCLUSTERED ([LocationId] ASC)
);


GO

