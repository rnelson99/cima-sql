CREATE TABLE [dbo].[tblProjectSpec] (
    [UserFld1]             NVARCHAR (10)  NULL,
    [SpecID]               INT            IDENTITY (1, 1) NOT NULL,
    [ConstructionDivision] NVARCHAR (10)  NULL,
    [sItem]                VARCHAR (50)   NULL,
    [Instructions]         NVARCHAR (MAX) NULL,
    [File1]                NVARCHAR (255) NULL,
    [File2]                NVARCHAR (255) NULL,
    [CreatedBy]            NVARCHAR (50)  NULL,
    [DateTimeStamp]        DATETIME       NULL,
    [ProjectID]            INT            NULL,
    CONSTRAINT [SpecID] PRIMARY KEY CLUSTERED ([SpecID] ASC)
);


GO

