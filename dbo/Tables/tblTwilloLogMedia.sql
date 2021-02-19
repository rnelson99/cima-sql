CREATE TABLE [dbo].[tblTwilloLogMedia] (
    [TwilloMediaLogID] INT            IDENTITY (1, 1) NOT NULL,
    [TwilloLogID]      INT            NULL,
    [url]              VARCHAR (1000) NULL,
    [status]           INT            NULL,
    [documentid]       INT            NULL,
    [mediaType]        VARCHAR (100)  NULL,
    CONSTRAINT [PK_tblTwilloLogMedia] PRIMARY KEY CLUSTERED ([TwilloMediaLogID] ASC)
);


GO

