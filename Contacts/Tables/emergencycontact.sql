CREATE TABLE [Contacts].[emergencycontact] (
    [id]                    INT           IDENTITY (1, 1) NOT NULL,
    [EntityID]              INT           NULL,
    [emergencycontact]      VARCHAR (100) NULL,
    [emergencyhomeph]       VARCHAR (50)  NULL,
    [emergencyrelationship] VARCHAR (50)  NULL,
    [emergencycellph]       VARCHAR (50)  NULL,
    [emergencyworkph]       VARCHAR (50)  NULL,
    [emergencyworkext]      VARCHAR (50)  NULL,
    CONSTRAINT [PK_emergencycontact] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

