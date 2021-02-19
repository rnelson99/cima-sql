CREATE TABLE [Documents].[Documents] (
    [DocumentID]           INT            IDENTITY (1, 1) NOT NULL,
    [ReferenceType]        INT            NULL,
    [ReferenceID]          INT            NULL,
    [DocumentType]         INT            NULL,
    [FileName]             VARCHAR (2000) NULL,
    [Status]               INT            NULL,
    [AddID]                INT            NULL,
    [AddDate]              DATETIME       NULL,
    [ChangeID]             INT            NULL,
    [ChangeDate]           DATETIME       NULL,
    [IsPhoto]              BIT            CONSTRAINT [DF__Documents__IsPho__02B25B50] DEFAULT ((0)) NULL,
    [HaveThumb]            BIT            CONSTRAINT [DF__Documents__HaveT__03A67F89] DEFAULT ((0)) NULL,
    [FileNameOnly]         VARCHAR (1000) NULL,
    [LocationCoordinates1] VARCHAR (100)  NULL,
    [LocationCoordinates2] VARCHAR (100)  NULL,
    [ImageEXIFdata]        VARCHAR (1000) NULL,
    [Caption]              VARCHAR (200)  NULL,
    [tempid]               INT            NULL,
    [MobileUpload]         BIT            CONSTRAINT [DF__Documents__Mobil__77FFC2B3] DEFAULT ((0)) NULL,
    [MobilePhotoID]        VARCHAR (100)  NULL,
    [nativeImageSize]      VARCHAR (20)   NULL,
    [Latitude]             VARCHAR (20)   NULL,
    [Longitude]            VARCHAR (20)   NULL,
    [ImgDirection]         VARCHAR (50)   NULL,
    [PhotoType]            INT            NULL,
    [storedFileSize]       VARCHAR (20)   NULL,
    [emailGUID]            VARCHAR (50)   NULL,
    [PhotoGuid]            VARCHAR (50)   NULL,
    [imgheight]            INT            NULL,
    [imgwidth]             INT            NULL,
    [imgrotate]            INT            NULL,
    [fileonsystem]         INT            NULL,
    [isJPEG]               INT            NULL,
    [rotateDone]           INT            NULL,
    [TempGUID]             VARCHAR (50)   NULL,
    [OriginalFileName]     VARCHAR (1000) NULL,
    [Summary]              VARCHAR (100)  NULL,
    [LongDesc]             VARCHAR (MAX)  NULL,
    [DateTimeTaken]        DATETIME       NULL,
    [HaveDateTimeTaken]    INT            NULL,
    [AddID2]               INT            NULL,
    [NoteID]               INT            NULL,
    [haveDocThumbnail]     INT            NULL,
    [haveDocThumbnailFile] VARCHAR (1000) NULL,
    [CheckStatus]          INT            NULL,
    [weeklyReportSelected] INT            DEFAULT ((0)) NULL,
    [weeklyID]             INT            DEFAULT ((0)) NULL,
    [fileYear]             INT            NULL,
    [fileArchived]         INT            NULL,
    [blackListedPhoto]     INT            NULL,
    [deletedByUser]        INT            NULL,
    [closestProjectID]     INT            NULL,
    [closestProjectMiles]  FLOAT (53)     NULL,
    [cimaInternal]         INT            DEFAULT ((0)) NULL,
    [exifPull]             INT            NULL,
    [Orientation]          INT            NULL,
    [noGPS]                INT            NULL,
    [device_id]            VARCHAR (100)  NULL,
    [validFile]            BIT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([DocumentID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190530-170740]
    ON [Documents].[Documents]([ReferenceType] ASC, [ReferenceID] ASC)
    INCLUDE([DocumentID]);


GO

