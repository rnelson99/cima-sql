CREATE TABLE [project].[divCodes] (
    [id]         INT      IDENTITY (1, 1) NOT NULL,
    [DivisionID] INT      NULL,
    [ProjectID]  INT      NULL,
    [AddID]      INT      NULL,
    [AddDate]    DATETIME CONSTRAINT [DF_divCodes_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]   INT      NULL,
    [ChangeDate] DATETIME NULL,
    [Status]     INT      CONSTRAINT [DF_divCodes_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_divCodes] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

