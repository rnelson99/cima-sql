CREATE TABLE [dbo].[tblUserCompensationCode] (
    [UserCompensationCodeID] INT          IDENTITY (1, 1) NOT NULL,
    [UserSecurityID]         INT          NOT NULL,
    [StartDate]              DATETIME     NULL,
    [CompensationCode]       VARCHAR (50) NULL,
    [EntityID]               INT          NULL,
    CONSTRAINT [PK_tblUserCompensationCode] PRIMARY KEY CLUSTERED ([UserCompensationCodeID] ASC)
);


GO

