CREATE TABLE [dbo].[tlkpUnitOfMeasure] (
    [UnitOfMeasureID]   INT          IDENTITY (1, 1) NOT NULL,
    [UnitOfMeasureName] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_tlkpUnitOfMeasure] PRIMARY KEY CLUSTERED ([UnitOfMeasureID] ASC),
    CONSTRAINT [UQ_tlkpUnitOfMeasure_UnitOfMeasureName] UNIQUE NONCLUSTERED ([UnitOfMeasureName] ASC)
);


GO

