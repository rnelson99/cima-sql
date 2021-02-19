CREATE TABLE [RequestForInfo].[RFIRouteTo] (
    [RFIRouteToID]     INT      IDENTITY (1, 1) NOT NULL,
    [RequestForInfoID] INT      NULL,
    [RouteToID]        INT      NULL,
    [Status]           INT      NULL,
    [AddID]            INT      NULL,
    [AddDate]          DATETIME CONSTRAINT [DF_RFIRouteTo_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]         INT      NULL,
    [ChangeDate]       DATETIME NULL,
    CONSTRAINT [PK_RFIRouteTo] PRIMARY KEY CLUSTERED ([RFIRouteToID] ASC)
);


GO

