CREATE TABLE [project].[RollCall] (
    [RollID]          INT      IDENTITY (1, 1) NOT NULL,
    [SubcontractorID] INT      NULL,
    [ETA]             DATETIME NULL,
    [LaborerNum]      INT      NULL,
    [LaborModTime]    DATETIME CONSTRAINT [DF_RollCall_LaborModTime] DEFAULT (getdate()) NULL,
    [AdequateLabor]   INT      NULL,
    [Onsite]          INT      NULL,
    [ProjectID]       INT      NULL,
    [AddID]           INT      NULL,
    [AddDate]         DATETIME NULL,
    [Status]          BIT      DEFAULT ((1)) NULL,
    CONSTRAINT [PK_RollCall] PRIMARY KEY CLUSTERED ([RollID] ASC)
);


GO

