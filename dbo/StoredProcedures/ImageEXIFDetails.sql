-- =============================================
-- Author:		Chris
-- Modified Date: 2019-09-24
-- Description:	Script was modified to only pull EXIF data for images that we don't have already.  
-- =============================================  
--	exec dbo.ImageEXIFDetails
CREATE PROCEDURE [dbo].[ImageEXIFDetails]
	
AS
BEGIN
	
	SET NOCOUNT ON;
	-- clearing out temp table
	truncate table logdatabase.dbo.imageEXIFTemp


-- Going to insert to temp table first
BULK
INSERT logDatabase.dbo.imageEXIFTemp
FROM 'c:\Temp\exif\output.csv'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)

-- Remove non-images
delete from logDatabase.dbo.imageEXIFTemp where mimetype not like '%image%'

-- Going to remove images we already have in the image exif table in case i pulled a duplicate
Delete t
from logDatabase.dbo.imageEXIFTemp t
join logDatabase.dbo.imageEXIF d on d.filename = t.filename

-- Move to ImageExif table
Insert into logdatabase.dbo.imageEXIF (SourceFile, ImageWidth, ImageHeight, ImageSize, MIMEType, Orientation, FileName, GPSPOSITION, GPSImgDirection)
Select SourceFile, ImageWidth, ImageHeight, ImageSize, MIMEType, Orientation, FileName, GPSPOSITION, GPSImgDirection
from logDatabase.dbo.imageEXIFTemp

update logDatabase.dbo.imageEXIF set SourceFile = replace(SourceFile,'//korg/e$/Documents/','E:\Documents\')

update d
set 
d.Latitude = SUBSTRING(i.GPSPOSITION, 1, CASE CHARINDEX(' ', i.GPSPOSITION)
            WHEN 0
                THEN LEN(i.GPSPOSITION)
            ELSE CHARINDEX(' ', i.GPSPOSITION) - 1
            END)
from proview.documents.Documents d
join logDatabase.dbo.imageEXIF i on d.FileNameOnly = i.filename
where d.Latitude is null


update d
set 
d.Longitude = SUBSTRING(i.GPSPOSITION, CASE CHARINDEX(' ', i.GPSPOSITION)
            WHEN 0
                THEN LEN(i.GPSPOSITION) + 1
            ELSE CHARINDEX(' ', i.GPSPOSITION) + 1
            END, 1000)
from proview.documents.Documents d
join logDatabase.dbo.imageEXIF i on d.FileNameOnly = i.filename
where d.Longitude is null

update d
set 
d.ImgDirection = i.gpsimgdirection
from proview.documents.Documents d
join logDatabase.dbo.imageEXIF i on d.FileNameOnly = i.filename
where d.ImgDirection is null

Update d
set
d.imgheight = i.ImageHeight, 
d.imgwidth = i.ImageWidth, 
d.imgrotate = 0, 
d.fileonsystem = 1
from proview.documents.Documents d
join logDatabase.dbo.imageEXIF i on d.FileNameOnly = i.filename
where orientation not like '%Rotate 90 CW%'
and d.imgheight is null

Update d
set
d.imgheight = i.ImageWidth, 
d.imgwidth = i.ImageHeight, 
d.imgrotate = ltrim(rtrim(replace(replace(i.orientation,'Rotate',''),' CW',''))), 
d.fileonsystem = 1
from proview.documents.Documents d
join logDatabase.dbo.imageEXIF i on d.FileNameOnly = i.filename
where orientation like '%Rotate%'
and d.imgheight is null

print 'RAN'

END

GO

