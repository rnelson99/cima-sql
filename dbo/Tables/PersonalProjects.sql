CREATE TABLE [dbo].[PersonalProjects] (
    [PersonalProjectID] INT            IDENTITY (1, 1) NOT NULL,
    [PersonalProject]   VARCHAR (50)   NULL,
    [EntityID]          INT            NULL,
    [StartDate]         DATETIME       NULL,
    [EndDate]           DATETIME       NULL,
    [Whiteboard]        VARCHAR (1000) NULL,
    [Status]            INT            DEFAULT ((1)) NULL,
    [Summary]           VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_PersonalProjects] PRIMARY KEY CLUSTERED ([PersonalProjectID] ASC)
);


GO

