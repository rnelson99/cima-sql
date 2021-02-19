CREATE TABLE [dbo].[tvalAnswer] (
    [AnswerText] VARCHAR (255) NOT NULL,
    [AnswerSort] INT           NOT NULL,
    CONSTRAINT [PK_tvalAnswer] PRIMARY KEY CLUSTERED ([AnswerSort] ASC)
);


GO

