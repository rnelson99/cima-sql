CREATE TABLE [RequestForInfo].[RFIImplementationSub] (
    [RFIImplementationSubID] INT      IDENTITY (1, 1) NOT NULL,
    [RFIImplementationID]    INT      NULL,
    [EntityID]               INT      NULL,
    [Status]                 INT      NULL,
    [AddID]                  INT      NULL,
    [AddDate]                DATETIME CONSTRAINT [DF_RFIImplementationSub_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]               INT      NULL,
    [ChangeDate]             DATETIME NULL,
    CONSTRAINT [PK_RFIImplementationSub] PRIMARY KEY CLUSTERED ([RFIImplementationSubID] ASC)
);


GO

