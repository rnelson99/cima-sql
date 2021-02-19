CREATE TABLE [dbo].[tblClientLienWaiver] (
    [Id]                               INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]                         INT           NOT NULL,
    [PartialConditionalRequired]       BIT           DEFAULT ((0)) NOT NULL,
    [PartialUnconditionalRequired]     BIT           DEFAULT ((0)) NOT NULL,
    [FinalConditionalRequired]         BIT           DEFAULT ((0)) NOT NULL,
    [FinalUnconditionalRequired]       BIT           DEFAULT ((0)) NOT NULL,
    [LienTrackerRequired]              BIT           DEFAULT ((0)) NOT NULL,
    [PartialConditionalCustom]         VARCHAR (8)   DEFAULT ('N/A') NULL,
    [PartialUnconditionalCustom]       VARCHAR (8)   DEFAULT ('N/A') NULL,
    [FinalConditionalCustom]           VARCHAR (8)   DEFAULT ('N/A') NULL,
    [FinalUnconditionalCustom]         VARCHAR (8)   DEFAULT ('N/A') NULL,
    [LienTrackerCustom]                VARCHAR (8)   DEFAULT ('N/A') NULL,
    [PartialConditionalTemplatePath]   VARCHAR (255) NULL,
    [PartialUnconditionalTemplatePath] VARCHAR (255) NULL,
    [FinalConditionalTemplatePath]     VARCHAR (255) NULL,
    [FinalUnconditionalTemplatePath]   VARCHAR (255) NULL,
    [LienTrackerTemplatePath]          VARCHAR (255) NULL,
    CONSTRAINT [tblClientLienWaiver_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

