CREATE TABLE [dbo].[tblQuickText] (
    [QuickTextID]      INT           IDENTITY (1, 1) NOT NULL,
    [ShortDescription] VARCHAR (55)  NULL,
    [QuickText]        VARCHAR (160) NULL,
    [AddID]            INT           NULL,
    [AddDate]          DATETIME      NULL,
    [ChangeID]         INT           NULL,
    [ChangeDate]       DATETIME      NULL,
    CONSTRAINT [PK_tblQuickText] PRIMARY KEY CLUSTERED ([QuickTextID] ASC)
);


GO

