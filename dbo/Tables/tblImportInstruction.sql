CREATE TABLE [dbo].[tblImportInstruction] (
    [ImportInstructionID] INT           IDENTITY (1, 1) NOT NULL,
    [ProViewAccountID]    INT           NOT NULL,
    [SortOrder]           SMALLINT      NOT NULL,
    [ImportInstruction]   VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_tblImportInstruction] PRIMARY KEY CLUSTERED ([ImportInstructionID] ASC),
    CONSTRAINT [FK_tblImportInstruction_tblProViewAccount] FOREIGN KEY ([ProViewAccountID]) REFERENCES [dbo].[tblProViewAccount] ([ProViewAccountID])
);


GO

