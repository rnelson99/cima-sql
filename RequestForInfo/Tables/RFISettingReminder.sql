CREATE TABLE [RequestForInfo].[RFISettingReminder] (
    [RFISettingReminderID] INT      IDENTITY (1, 1) NOT NULL,
    [RFISettingID]         INT      NULL,
    [RelativeDays]         INT      NULL,
    [RelativeHours]        INT      NULL,
    [Delivery8AM]          BIT      CONSTRAINT [DF_RFISettingReminder_Delivery8AM] DEFAULT ((0)) NOT NULL,
    [RepeatInterval]       INT      NULL,
    [Urgency]              INT      NULL,
    [Status]               INT      NULL,
    [AddID]                INT      NULL,
    [AddDate]              DATETIME CONSTRAINT [DF_RFISettingReminder_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]             INT      NULL,
    [ChangeDate]           DATETIME NULL,
    CONSTRAINT [PK_RFISettingReminder] PRIMARY KEY CLUSTERED ([RFISettingReminderID] ASC)
);


GO

