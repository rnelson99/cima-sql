CREATE TABLE [RequestForInfo].[RFISetting] (
    [RFISettingID]     INT      IDENTITY (1, 1) NOT NULL,
    [CIMAApproverID]   INT      NULL,
    [FirstResponderID] INT      NULL,
    [FinalResponderID] INT      NULL,
    [ImplementationID] INT      NULL,
    [WeeklyLog]        BIT      NOT NULL,
    [ProjectID]        INT      NULL,
    [ClientID]         INT      NULL,
    [AddID]            INT      NULL,
    [AddDate]          DATETIME CONSTRAINT [DF_RFISetting_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]         INT      NULL,
    [ChangeDate]       DATETIME NULL,
    CONSTRAINT [PK_RFISetting] PRIMARY KEY CLUSTERED ([RFISettingID] ASC)
);


GO

