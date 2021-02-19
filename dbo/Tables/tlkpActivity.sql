CREATE TABLE [dbo].[tlkpActivity] (
    [ActivityID]          INT           IDENTITY (1, 1) NOT NULL,
    [ActivityCode]        VARCHAR (50)  NOT NULL,
    [ActivityDescription] VARCHAR (255) NOT NULL,
    [AddID]               INT           NULL,
    [ChangeID]            INT           NULL,
    [AddDate]             DATETIME      NULL,
    [ChangeDate]          DATETIME      NULL,
    [Status]              INT           NULL,
    [TimeGroup]           VARCHAR (50)  NULL,
    [nj]                  BIT           NULL,
    [cima]                BIT           NULL,
    [overhead]            BIT           NULL,
    CONSTRAINT [PK_tlkpActivity] PRIMARY KEY CLUSTERED ([ActivityID] ASC)
);


GO

