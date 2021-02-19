CREATE TABLE [dbo].[tblPayment] (
    [PaymentID]         INT           IDENTITY (1, 1) NOT NULL,
    [ClientID]          INT           NULL,
    [Amount]            MONEY         NULL,
    [DatePay]           DATETIME      NULL,
    [PaymentTypeID]     INT           NULL,
    [Notes]             VARCHAR (MAX) NULL,
    [IsDeleted]         VARCHAR (1)   CONSTRAINT [DF_tblPayment_IsDeleted] DEFAULT ('N') NULL,
    [CreatedOn]         DATETIME      CONSTRAINT [DF_tblPayment_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]       VARCHAR (255) NULL,
    [ModifiedLast]      DATETIME      NULL,
    [UpdatedUser]       VARCHAR (255) NULL,
    [CheckNumber]       VARCHAR (50)  NULL,
    [ProViewAccountID]  INT           NULL,
    [paymentGUID]       VARCHAR (40)  NULL,
    [addID]             INT           NULL,
    [adddate]           DATETIME      NULL,
    [changeID]          INT           NULL,
    [changedate]        DATETIME      NULL,
    [OriginalPaymentID] INT           NULL,
    [VerifiedBy]        INT           NULL,
    [VerifiedDate]      DATETIME      NULL,
    CONSTRAINT [PK_tblPayment] PRIMARY KEY CLUSTERED ([PaymentID] ASC)
);


GO

