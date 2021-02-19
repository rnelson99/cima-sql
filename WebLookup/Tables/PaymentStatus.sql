CREATE TABLE [WebLookup].[PaymentStatus] (
    [PaymentStatusID] INT          NULL,
    [PaymentStatus]   VARCHAR (50) NULL,
    [Status]          INT          NULL,
    [sorter]          INT          NULL,
    [PaymentTYpe]     VARCHAR (10) NULL,
    [inProcess]       INT          DEFAULT ((0)) NULL,
    [allowDelete]     INT          NULL,
    [allowEdit]       INT          NULL
);


GO

