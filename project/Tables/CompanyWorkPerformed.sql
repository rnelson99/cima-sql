CREATE TABLE [project].[CompanyWorkPerformed] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [entityid]      INT            NULL,
    [projectid]     INT            NULL,
    [workPerformed] VARCHAR (1000) NULL,
    [addID]         INT            NULL,
    [addDate]       DATETIME       NULL,
    [changeID]      INT            NULL,
    [ChangeDate]    DATETIME       NULL,
    [keywords]      VARCHAR (1000) NULL,
    CONSTRAINT [PK_CompanyWorkPerformed] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

