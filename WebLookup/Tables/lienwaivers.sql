CREATE TABLE [WebLookup].[lienwaivers] (
    [lientemplateid]  INT           IDENTITY (1, 1) NOT NULL,
    [TemplateGroup]   VARCHAR (50)  NULL,
    [TemplateName]    VARCHAR (50)  NULL,
    [TemplateDetails] VARCHAR (MAX) NULL,
    [status]          INT           NULL,
    [adddate]         DATETIME      CONSTRAINT [DF_lienwaivers_adddate] DEFAULT (getdate()) NULL,
    [addid]           INT           NULL,
    [changedate]      DATETIME      NULL,
    [changeid]        INT           NULL,
    [defaultWaiver]   INT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_lienwaivers] PRIMARY KEY CLUSTERED ([lientemplateid] ASC)
);


GO

