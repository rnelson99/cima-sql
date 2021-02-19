CREATE TABLE [dbo].[tblSubPayAppScheduleOfValues] (
    [PayAppScheduleID]  INT        IDENTITY (1, 1) NOT NULL,
    [SubPayAppId]       INT        NULL,
    [CodeID]            INT        NULL,
    [TotalApproved]     MONEY      NULL,
    [WorkComplete]      MONEY      NULL,
    [WorkCompletePerc]  FLOAT (53) NULL,
    [WorkCompleteNew]   MONEY      NULL,
    [NetPay]            MONEY      NULL,
    [PriorPayGross]     MONEY      NULL,
    [PriorPayGrossPerc] FLOAT (53) NULL,
    [addid]             INT        NULL,
    [adddate]           DATETIME   NULL,
    [changeid]          INT        NULL,
    [changedate]        DATETIME   NULL,
    [status]            INT        NULL,
    [EntityID]          INT        NULL,
    [ProjectID]         INT        NULL,
    [RetainagePayOut]   MONEY      NULL,
    CONSTRAINT [PK_tblSubPayAppScheduleOfValues] PRIMARY KEY CLUSTERED ([PayAppScheduleID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190605-161134]
    ON [dbo].[tblSubPayAppScheduleOfValues]([SubPayAppId] ASC)
    INCLUDE([PayAppScheduleID]);


GO

