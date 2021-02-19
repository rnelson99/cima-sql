CREATE TABLE [project].[salesTaxQuestions] (
    [projectTaxID]     INT          IDENTITY (1, 1) NOT NULL,
    [projectid]        INT          NULL,
    [taxQuestion]      INT          NULL,
    [taxAnswer]        INT          NULL,
    [addid]            INT          NULL,
    [adddate]          DATETIME     NULL,
    [changeid]         INT          NULL,
    [changedate]       DATETIME     NULL,
    [status]           INT          NULL,
    [taxQuestionGroup] INT          DEFAULT ((0)) NULL,
    [approver1]        INT          NULL,
    [approver2]        INT          NULL,
    [dbGUID]           VARCHAR (50) NULL,
    [notifyID]         INT          NULL,
    CONSTRAINT [PK_salesTaxQustions] PRIMARY KEY CLUSTERED ([projectTaxID] ASC)
);


GO

