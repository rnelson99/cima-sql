CREATE TABLE [project].[Delays] (
    [startDate]        DATETIME       NULL,
    [endDate]          DATETIME       NULL,
    [Summary]          VARCHAR (1000) NULL,
    [status]           INT            NULL,
    [AffectedSubs]     VARCHAR (100)  NULL,
    [AllSchedule]      INT            NULL,
    [projectid]        INT            NULL,
    [addid]            INT            NULL,
    [changeid]         INT            NULL,
    [adddate]          DATETIME       NULL,
    [changedate]       DATETIME       NULL,
    [DelayId]          INT            IDENTITY (1, 1) NOT NULL,
    [delayType]        INT            NULL,
    [responsibleParty] INT            NULL,
    [criticalPath]     INT            NULL,
    [ownerVisible]     INT            DEFAULT ((0)) NULL
);


GO

