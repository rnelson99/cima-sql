CREATE TABLE [dbo].[tblBudgetNotes] (
    [BudgetNoteId] INT      IDENTITY (1, 1) NOT NULL,
    [codeid]       INT      NULL,
    [projectid]    INT      NULL,
    [addid]        INT      NULL,
    [adddate]      DATETIME CONSTRAINT [DF_tblBudgetNotes_adddate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblBudgetNotes] PRIMARY KEY CLUSTERED ([BudgetNoteId] ASC)
);


GO

