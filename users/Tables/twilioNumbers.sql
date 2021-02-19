CREATE TABLE [users].[twilioNumbers] (
    [id]         INT          IDENTITY (1, 1) NOT NULL,
    [number]     VARCHAR (15) NULL,
    [assignedTo] INT          NULL,
    [status]     INT          NULL,
    [adddate]    DATETIME     NULL,
    [addid]      INT          NULL,
    [changedate] DATETIME     NULL,
    [changeid]   INT          NULL,
    CONSTRAINT [PK_twilioNumbers] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

