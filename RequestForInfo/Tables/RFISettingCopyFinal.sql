CREATE TABLE [RequestForInfo].[RFISettingCopyFinal] (
    [RFISettingCopyFinalID] INT      IDENTITY (1, 1) NOT NULL,
    [RFISettingID]          INT      NULL,
    [CopyFinalID]           INT      NULL,
    [Status]                INT      NULL,
    [AddID]                 INT      NULL,
    [AddDate]               DATETIME CONSTRAINT [DF_RFISettingCopyFinal_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]              INT      NULL,
    [ChangeDate]            DATETIME NULL,
    CONSTRAINT [PK_RFISettingCopyFinal] PRIMARY KEY CLUSTERED ([RFISettingCopyFinalID] ASC)
);


GO

