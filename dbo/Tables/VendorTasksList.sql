CREATE TABLE [dbo].[VendorTasksList] (
    [VendorTaskID] INT          NOT NULL,
    [Task]         VARCHAR (50) NULL,
    [Status]       BIT          CONSTRAINT [DF_VendorTasksList_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_VendorTasksList] PRIMARY KEY CLUSTERED ([VendorTaskID] ASC)
);


GO

