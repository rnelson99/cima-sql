CREATE TABLE [TimeSheet].[TimeSheetDetailsStartStop] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [TimeSheetID]   INT           NULL,
    [RowLink]       INT           NULL,
    [StartDateTime] DATETIME      NULL,
    [EndDateTime]   DATETIME      NULL,
    [StartGPS]      VARCHAR (100) NULL,
    [EndGPS]        VARCHAR (100) NULL,
    [WeekDayNum]    INT           NULL,
    [AddDate]       DATETIME      NULL,
    [aMins]         FLOAT (53)    NULL,
    [rMins]         FLOAT (53)    NULL,
    [Calcd]         INT           NULL,
    CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

