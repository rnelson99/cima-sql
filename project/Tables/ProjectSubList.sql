CREATE TABLE [project].[ProjectSubList] (
    [ProjectSubListID] INT IDENTITY (1, 1) NOT NULL,
    [ProjectID]        INT NULL,
    [PX]               INT NULL,
    [PM]               INT NULL,
    [Lead]             INT NULL,
    [SubContractorID]  INT NULL,
    CONSTRAINT [PK_ProjectSubList] PRIMARY KEY CLUSTERED ([ProjectSubListID] ASC)
);


GO

