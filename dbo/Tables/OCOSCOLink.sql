CREATE TABLE [dbo].[OCOSCOLink] (
    [OCOSCOLinkID]        INT        IDENTITY (1, 1) NOT NULL,
    [ChangeOrderID]       INT        NULL,
    [ChangeOrderDetailID] INT        NULL,
    [PWALogID]            INT        NULL,
    [PWADetailCostID]     INT        NULL,
    [addID]               INT        NULL,
    [addDate]             DATETIME   CONSTRAINT [DF_OCOSCOLink_addDate] DEFAULT (getdate()) NULL,
    [changeID]            INT        NULL,
    [changeDate]          NCHAR (10) NULL,
    [status]              INT        CONSTRAINT [DF_OCOSCOLink_status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_OCOSCOLink] PRIMARY KEY CLUSTERED ([OCOSCOLinkID] ASC)
);


GO

