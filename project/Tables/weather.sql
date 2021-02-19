CREATE TABLE [project].[weather] (
    [WeatherID]   INT           NOT NULL,
    [ProjectID]   INT           NULL,
    [dDate]       DATE          NULL,
    [AddDate]     DATETIME      NULL,
    [qpf_day]     FLOAT (53)    NULL,
    [qpf_night]   FLOAT (53)    NULL,
    [qpf_allday]  FLOAT (53)    NULL,
    [maxwind]     INT           NULL,
    [maxwinddir]  VARCHAR (1)   NULL,
    [avewind]     INT           NULL,
    [avewinddir]  VARCHAR (1)   NULL,
    [avehumidity] INT           NULL,
    [maxhumidity] INT           NULL,
    [minhumidity] INT           NULL,
    [conditions]  VARCHAR (50)  NULL,
    [templow]     INT           NULL,
    [temphigh]    INT           NULL,
    [icon_url]    VARCHAR (100) NULL,
    CONSTRAINT [PK_weather] PRIMARY KEY CLUSTERED ([WeatherID] ASC)
);


GO

