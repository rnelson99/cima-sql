CREATE TABLE [project].[SubmittalDivCodes] (
    [SubmittalCodeID] INT           IDENTITY (1, 1) NOT NULL,
    [DivCode]         VARCHAR (20)  NULL,
    [DivCodeDesc]     VARCHAR (100) NULL,
    CONSTRAINT [PK_SubmittalDivCodes] PRIMARY KEY CLUSTERED ([SubmittalCodeID] ASC)
);


GO

