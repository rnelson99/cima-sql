CREATE TABLE [dbo].[urlLinks] (
    [URLID]      INT           IDENTITY (1, 1) NOT NULL,
    [url]        VARCHAR (200) NULL,
    [urldesc]    VARCHAR (200) NULL,
    [status]     INT           NULL,
    [adddate]    DATETIME      CONSTRAINT [DF_urlLinks_adddate] DEFAULT (getdate()) NULL,
    [addid]      INT           NULL,
    [changedate] DATETIME      NULL,
    [changeid]   INT           NULL,
    [urltype]    INT           NULL,
    CONSTRAINT [PK_urlLinks] PRIMARY KEY CLUSTERED ([URLID] ASC)
);


GO

