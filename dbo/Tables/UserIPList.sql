CREATE TABLE [dbo].[UserIPList] (
    [IPID]           INT          IDENTITY (1, 1) NOT NULL,
    [AddDate]        DATETIME     NULL,
    [IPAddress]      VARCHAR (50) NULL,
    [Status]         INT          NULL,
    [EntityID]       INT          NULL,
    [MobileCode]     VARCHAR (50) NULL,
    [ExpirationDate] DATETIME     NULL,
    [dbGUID]         VARCHAR (50) NULL,
    [attempts]       INT          DEFAULT ((0)) NULL,
    CONSTRAINT [PK_UserIPList] PRIMARY KEY CLUSTERED ([IPID] ASC)
);


GO

