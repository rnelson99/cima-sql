CREATE TABLE [RequestForInfo].[RFIDivision] (
    [RFIDivisionID]    INT      IDENTITY (1, 1) NOT NULL,
    [RequestForInfoID] INT      NULL,
    [DivisionID]       INT      NULL,
    [Status]           INT      NULL,
    [AddID]            INT      NULL,
    [AddDate]          DATETIME CONSTRAINT [DF_RFIDivision_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]         INT      NULL,
    [ChangeDate]       DATETIME NULL,
    CONSTRAINT [PK_RFIDivision] PRIMARY KEY CLUSTERED ([RFIDivisionID] ASC)
);


GO

