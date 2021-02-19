CREATE TABLE [dbo].[UserUniqueMobileCode] (
    [UserSecurityID] INT          NULL,
    [UniqueCode]     VARCHAR (50) NULL,
    [MobileVefified] BIT          NULL,
    [MobileCode]     VARCHAR (10) NULL,
    [adddate]        DATETIME     NULL,
    [ExpDate]        DATETIME     NULL,
    [status]         BIT          DEFAULT ((1)) NULL,
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [method]         INT          NULL,
    CONSTRAINT [PK_UserUniqueMobileCode] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

