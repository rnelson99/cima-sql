CREATE TABLE [dbo].[tvalPWAStatus] (
    [PWAStatusID]              INT           NOT NULL,
    [PWAStatusSymbol]          VARCHAR (5)   NULL,
    [PWAStatusName]            VARCHAR (255) NULL,
    [PWAStatusBackgroundColor] VARCHAR (255) NULL,
    [atRisk]                   INT           NULL,
    [createNewPWA]             INT           NULL,
    CONSTRAINT [PK_tvalPWAStatus] PRIMARY KEY CLUSTERED ([PWAStatusID] ASC)
);


GO

