CREATE TABLE [dbo].[Messages] (
    [MessageID]    INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]    INT            NULL,
    [VendorID]     INT            NULL,
    [SentFrom]     VARCHAR (255)  NULL,
    [SentTo]       VARCHAR (255)  NULL,
    [Direction]    TINYINT        NULL,
    [Subject]      VARCHAR (MAX)  NULL,
    [Message1]     VARCHAR (MAX)  NULL,
    [Message2]     VARCHAR (MAX)  NULL,
    [Message3]     VARCHAR (MAX)  NULL,
    [MessageType]  TINYINT        NULL,
    [AddDate]      DATETIME       CONSTRAINT [DF_Messages_AddDate] DEFAULT (getdate()) NULL,
    [AppMessageID] VARCHAR (1000) NULL,
    [TwilloID]     INT            NULL,
    [Status]       TINYINT        NULL,
    CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED ([MessageID] ASC)
);


GO

