CREATE TABLE [dbo].[tblSubPayAppLock] (
    [SubPayAppLockID]   INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]         INT           NOT NULL,
    [OwnerPayAppNumber] INT           NOT NULL,
    [IsLocked]          VARCHAR (1)   DEFAULT ('Y') NOT NULL,
    [LockedUser]        VARCHAR (255) NULL,
    [LockedOn]          DATETIME      NULL,
    [UnLockedUser]      VARCHAR (255) NULL,
    [UnLockedOn]        DATETIME      NULL,
    CONSTRAINT [PK_tblSubPayAppLock] PRIMARY KEY CLUSTERED ([SubPayAppLockID] ASC)
);


GO

