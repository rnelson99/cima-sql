CREATE TABLE [Expense].[mileage] (
    [mileageid]       INT           IDENTITY (1, 1) NOT NULL,
    [mileageDate]     DATETIME      NULL,
    [startingAddress] VARCHAR (200) NULL,
    [endingAddress]   VARCHAR (200) NULL,
    [miles]           FLOAT (53)    NULL,
    [mileageRate]     MONEY         NULL,
    [vehicle]         INT           NULL,
    [addid]           INT           NULL,
    [adddate]         DATETIME      CONSTRAINT [DF_mileage_adddate] DEFAULT (getdate()) NULL,
    [changeid]        INT           NULL,
    [changedate]      DATETIME      NULL,
    [approvedid]      INT           NULL,
    [approveddate]    INT           NULL,
    [status]          INT           CONSTRAINT [DF_mileage_status] DEFAULT ((1)) NULL,
    [entityid]        INT           NULL,
    CONSTRAINT [PK_mileage] PRIMARY KEY CLUSTERED ([mileageid] ASC)
);


GO

