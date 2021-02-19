CREATE TABLE [dbo].[apiCallProcs] (
    [apiCallID] INT          IDENTITY (1, 1) NOT NULL,
    [apiCall]   VARCHAR (50) NULL,
    [apiPage]   VARCHAR (50) NULL,
    [status]    BIT          CONSTRAINT [DF_apiCallProcs_status] DEFAULT ((1)) NULL,
    [apiDesc]   VARCHAR (50) NULL,
    [allowOne]  INT          DEFAULT ((0)) NULL,
    CONSTRAINT [PK_apiCallProcs] PRIMARY KEY CLUSTERED ([apiCallID] ASC)
);


GO

