CREATE TABLE [users].[FeeSchedule] (
    [FeeID]          INT          IDENTITY (1, 1) NOT NULL,
    [FeeDescription] VARCHAR (20) NULL,
    [Amt]            MONEY        NULL,
    [ClientID]       INT          NULL,
    [ProjectID]      INT          NULL,
    [AddID]          INT          NULL,
    [AddDate]        DATETIME     CONSTRAINT [DF_FeeSchedule_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]       INT          NULL,
    [ChangeDate]     DATETIME     NULL,
    [status]         INT          CONSTRAINT [DF_FeeSchedule_status] DEFAULT ((1)) NULL,
    [EffectiveStart] DATETIME     NULL,
    [EffectiveEnd]   DATETIME     NULL,
    CONSTRAINT [PK_FeeSchedule] PRIMARY KEY CLUSTERED ([FeeID] ASC)
);


GO

