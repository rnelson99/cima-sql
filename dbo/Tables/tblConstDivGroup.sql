CREATE TABLE [dbo].[tblConstDivGroup] (
    [DivisionGroupID]          INT           IDENTITY (1, 1) NOT NULL,
    [DivisionGroupCode]        VARCHAR (20)  NOT NULL,
    [DivisionGroupSortOrder]   INT           NULL,
    [DivisionGroupDescription] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tblConstDivGroup] PRIMARY KEY CLUSTERED ([DivisionGroupID] ASC),
    CONSTRAINT [UQ_tblConstDivGroup_Code] UNIQUE NONCLUSTERED ([DivisionGroupCode] ASC)
);


GO

