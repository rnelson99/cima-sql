CREATE TABLE [RequestForInfo].[RFISettingCopyInitial] (
    [RFISettingCopyInitialID] INT      IDENTITY (1, 1) NOT NULL,
    [RFISettingID]            INT      NULL,
    [CopyInitialID]           INT      NULL,
    [Status]                  INT      NULL,
    [AddID]                   INT      NULL,
    [AddDate]                 DATETIME CONSTRAINT [DF_RFISettingCopyInitial_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]                INT      NULL,
    [ChangeDate]              DATETIME NULL,
    CONSTRAINT [PK_RFISettingCopyInitial] PRIMARY KEY CLUSTERED ([RFISettingCopyInitialID] ASC)
);


GO

