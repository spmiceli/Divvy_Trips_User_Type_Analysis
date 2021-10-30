/* Delete all entries that are not O'Hare Airport in Chicago  */
DELETE
  FROM [2019_weather_info].[dbo].[2019_weather]
  WHERE station_id != 'USW00094846';

SELECT *
FROM [2019_weather_info].[dbo].[2019_weather]

/* Convert date column to date type */

ALTER TABLE [dbo].[2019_weather]
ALTER COLUMN "date" varchar(10)

ALTER TABLE [dbo].[2019_weather]
ALTER COLUMN "date" date

/* Convert value1 column to int type */

ALTER TABLE [dbo].[2019_weather]
ALTER COLUMN value1 int

/* Drop unnecessary columns */
ALTER TABLE [dbo].[2019_weather]
DROP COLUMN station_id, value2, MFlag, QFlag, SFlag

/* Find the unique element codes for analysis */ 

SELECT DISTINCT element
FROM [2019_weather_info].[dbo].[2019_weather]
ORDER BY element

/*
From the documentation for the data:
https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt

PRCP = Precipitation (tenths of mm)
SNOW = Snowfall (mm)
SNWD = Snow depth (mm)
TMAX = Maximum temperature (tenths of degrees C)
TMIN = Minimum temperature (tenths of degrees C)


AWND = Average daily wind speed (tenths of meters per second)
TAVG = = Average temperature (tenths of degrees C) 
		[Note that TAVG from source 'S' corresponds to an average for the period ending at 2400 UTC rather than local midnight]
WDF2 = Direction of fastest 2-minute wind (degrees)
WDF5 = Direction of fastest 5-second wind (degrees)
WSF2 = Fastest 2-minute wind speed (tenths of meters per second)
WSF5 = Fastest 5-second wind speed (tenths of meters per second)
WT01 = Fog, ice fog, or freezing fog (may include heavy fog)
WT02 = Heavy fog or heaving freezing fog (not always distinquished from fog)
WT03 = Thunder
WT04 = Ice pellets, sleet, snow pellets, or small hail 
WT05 = Hail (may include small hail)
WT06 = Glaze or rime 
WT08 = Smoke or haze 
WT09 = Blowing or drifting snow

*/


/* Check for missing values in value1 column (-9999 denotes missing value for value1) */ 
SELECT value1 
FROM [2019_weather_info].[dbo].[2019_weather]
WHERE value1 = -9999


/* Pivot the data wider by element with entries equal to value1 and create a CTE for further manipulation*/
WITH weather_wide_CTE ("date", [AWND], [PRCP], [SNOW], [SNWD], [TAVG], [TMAX], [TMIN], [WDF2],
		[WDF5], [WSF2], [WSF5], [WT01],[WT02], [WT03], [WT04], [WT05], [WT06], [WT08], [WT09] )
AS (

	SELECT *
	FROM (
	SELECT "date", [AWND], [PRCP], [SNOW], [SNWD], [TAVG], [TMAX], [TMIN], [WDF2],
			[WDF5], [WSF2], [WSF5], [WT01],[WT02], [WT03], [WT04], [WT05], [WT06], [WT08], [WT09]
	FROM (
	    SELECT "date", element, value1
	    FROM [2019_weather_info].[dbo].[2019_weather]
	) pivotdata
	PIVOT(
		MAX(value1)
	    FOR element IN ([AWND], [PRCP], [SNOW], [SNWD], [TAVG], [TMAX], [TMIN], [WDF2],
			[WDF5], [WSF2], [WSF5], [WT01],[WT02], [WT03], [WT04], [WT05], [WT06], [WT08], [WT09])
	) as p ) as pvt

)
SELECT * 
FROM weather_wide_CTE




