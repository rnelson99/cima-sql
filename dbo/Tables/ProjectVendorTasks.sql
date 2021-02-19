CREATE TABLE [dbo].[ProjectVendorTasks] (
    [ID]         INT      IDENTITY (1, 1) NOT NULL,
    [VendorID]   INT      NULL,
    [ProjectID]  INT      NULL,
    [TaskID]     INT      NULL,
    [Status]     INT      NULL,
    [AddID]      INT      NULL,
    [AddDate]    DATETIME NULL,
    [ChangeID]   INT      NULL,
    [ChangeDate] DATETIME NULL,
    [ContactID]  INT      NULL,
    CONSTRAINT [PK_ProjectVendorTasks] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

