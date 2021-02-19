CREATE TABLE [Contacts].[InsuranceAgent] (
    [insAgentID] INT            IDENTITY (1, 1) NOT NULL,
    [entityid]   INT            NULL,
    [agentname]  VARCHAR (150)  NULL,
    [agency]     VARCHAR (150)  NULL,
    [phone]      VARCHAR (30)   NULL,
    [email]      VARCHAR (150)  NULL,
    [status]     INT            NULL,
    [addid]      INT            NULL,
    [adddate]    DATETIME       NULL,
    [changeid]   INT            NULL,
    [changedate] DATETIME       NULL,
    [comments]   VARCHAR (1000) NULL,
    CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED ([insAgentID] ASC)
);


GO

