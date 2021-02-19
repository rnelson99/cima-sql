CREATE TABLE [Documents].[attributes] (
    [DocumentAttributeID] INT            IDENTITY (1, 1) NOT NULL,
    [AttributeType]       INT            NULL,
    [Attribute]           VARCHAR (1000) NULL,
    [DocumentID]          INT            NULL,
    [status]              INT            DEFAULT ((1)) NULL,
    [AddID]               INT            NULL,
    [ChangeID]            INT            NULL,
    [AddDate]             DATETIME       DEFAULT (getdate()) NULL,
    [ChangeDate]          DATETIME       NULL,
    [contractID]          INT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_attributes_1] PRIMARY KEY CLUSTERED ([DocumentAttributeID] ASC)
);


GO

