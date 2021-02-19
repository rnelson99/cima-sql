CREATE TABLE [Contacts].[Deprecated.Groups] (
    [GroupID]     INT           IDENTITY (1, 1) NOT NULL,
    [GroupName]   VARCHAR (100) NULL,
    [GroupStatus] INT           CONSTRAINT [DF_Groups_GroupStatus] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED ([GroupID] ASC)
);


GO

