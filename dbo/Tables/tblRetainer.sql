CREATE TABLE [dbo].[tblRetainer] (
    [RetainerID] INT      NULL,
    [EntityID]   INT      NULL,
    [ClientID]   INT      NULL,
    [ProjectID]  INT      NULL,
    [dDate]      DATETIME NULL,
    [amount]     MONEY    NULL,
    [addid]      INT      NULL,
    [adddate]    DATETIME CONSTRAINT [DF_tblRetainer_adddate] DEFAULT (getdate()) NULL,
    [changeid]   INT      NULL,
    [changedate] DATETIME NULL,
    [status]     INT      CONSTRAINT [DF_tblRetainer_status] DEFAULT ((1)) NULL,
    [paymentID]  INT      NULL,
    [id]         INT      IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblRetainer] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

