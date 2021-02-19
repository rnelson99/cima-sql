CREATE TABLE [dbo].[tlkpMilestones] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [Milestone]     NVARCHAR (25) NOT NULL,
    [MilestoneAbbr] NVARCHAR (5)  NOT NULL,
    [Active]        BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [tlkpMilestones_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

