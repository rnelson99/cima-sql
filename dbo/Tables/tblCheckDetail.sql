CREATE TABLE [dbo].[tblCheckDetail] (
    [CheckDetailID]          INT           IDENTITY (1, 1) NOT NULL,
    [CheckDate]              DATETIME      NOT NULL,
    [CheckAmount]            MONEY         DEFAULT ((0)) NULL,
    [CheckNumberAR]          VARCHAR (50)  NULL,
    [ProViewAccountID]       INT           NULL,
    [SubPayAppID]            INT           NULL,
    [BillID]                 INT           NULL,
    [CheckDescription]       VARCHAR (MAX) NULL,
    [CreatedOn]              DATETIME      CONSTRAINT [DF_tblCheckDetail_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]            VARCHAR (255) NULL,
    [ModifiedLast]           DATETIME      NULL,
    [UpdatedUser]            VARCHAR (255) NULL,
    [AccountRegisterLocalID] INT           NULL,
    [CodeID]                 INT           NULL,
    CONSTRAINT [PK_tblCheckDetail] PRIMARY KEY CLUSTERED ([CheckDetailID] ASC)
);


GO

