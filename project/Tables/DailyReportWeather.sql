CREATE TABLE [project].[DailyReportWeather] (
    [WeatherID]        INT            IDENTITY (1, 1) NOT NULL,
    [DailyReportID]    INT            NULL,
    [mTemp]            FLOAT (53)     NULL,
    [nTemp]            FLOAT (53)     NULL,
    [eTemp]            FLOAT (53)     NULL,
    [Conditions]       VARCHAR (1000) NULL,
    [BadWeather]       INT            NULL,
    [AddID]            INT            NULL,
    [AddDate]          DATETIME       NULL,
    [ChangeID]         INT            NULL,
    [ChangeDate]       DATETIME       NULL,
    [Status]           INT            NULL,
    [hasHeir]          INT            NULL,
    [isRevised]        INT            NULL,
    [badweatherreason] VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_ProjectDailyWeather] PRIMARY KEY CLUSTERED ([WeatherID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportID]
    ON [project].[DailyReportWeather]([DailyReportID] ASC);


GO

