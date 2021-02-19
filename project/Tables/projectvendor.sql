CREATE TABLE [project].[projectvendor] (
    [projectid]      INT   NULL,
    [entityid]       INT   NULL,
    [ShowOnTracker]  INT   CONSTRAINT [DF__projectve__ShowO__080C0D4A] DEFAULT ((1)) NULL,
    [id]             INT   IDENTITY (1, 1) NOT NULL,
    [modifiedAmount] MONEY CONSTRAINT [DF_projectvendor_modifiedAmount] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_projectvendor] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ProjectID]
    ON [project].[projectvendor]([projectid] ASC)
    INCLUDE([entityid]);


GO

