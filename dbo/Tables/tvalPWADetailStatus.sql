CREATE TABLE [dbo].[tvalPWADetailStatus] (
    [PWADetailStatusID]              INT           NOT NULL,
    [PWADetailStatusSymbol]          VARCHAR (5)   NULL,
    [PWADetailStatusName]            VARCHAR (255) NULL,
    [PWADetailStatusBackgroundColor] VARCHAR (255) NULL,
    CONSTRAINT [PK_tvalPWADetailStatus] PRIMARY KEY CLUSTERED ([PWADetailStatusID] ASC)
);


GO

