CREATE TABLE [dbo].[Deprecated.tblClientRequirement] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]        INT           NOT NULL,
    [Requirement]     VARCHAR (255) NOT NULL,
    [RequirementType] VARCHAR (10)  DEFAULT ('Start-Up') NOT NULL,
    [Milestone]       INT           NOT NULL,
    [Days]            INT           DEFAULT ((0)) NOT NULL,
    [Responsible]     INT           NULL,
    CONSTRAINT [tblClientRequirement_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

