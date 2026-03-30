-- 
    -- Reorder and rename fields.
    -- Standardize text in string fields to UPPER
    -- Remove extra spaces from string fieStandardize inconsistent datalds using TRIM
    -- Limit strings to alphanumeric or select characters only.
    -- Round lat and lng values to 3 decimal places.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step2` AS
SELECT
  UPPER(REGEXP_REPLACE(TRIM(ride_id), r'[^a-zA-Z0-9.&_ -]', '')) AS ride_id,
  UPPER(REGEXP_REPLACE(TRIM(member_casual), r'[^a-zA-Z0-9.&_ -]', '')) AS member_type,
  UPPER(REGEXP_REPLACE(TRIM(rideable_type), r'[^a-zA-Z0-9.&_ -]', '')) AS rideable_type,
  started_at,
  ended_at,
  UPPER(REGEXP_REPLACE(TRIM(start_station_id), r'[^a-zA-Z0-9.&_ -]', '')) AS start_station_id,
  UPPER(REGEXP_REPLACE(TRIM(start_station_name), r'[^a-zA-Z0-9.&_ -]', '')) AS start_station_name,
  UPPER(REGEXP_REPLACE(TRIM(end_station_id), r'[^a-zA-Z0-9.&_ -]', '')) AS end_station_id,
  UPPER(REGEXP_REPLACE(TRIM(end_station_name), r'[^a-zA-Z0-9.&_ -]', '')) AS end_station_name,
  ROUND(start_lat,3) AS start_lat,
  ROUND(start_lng,3) AS start_lng,
  ROUND(end_lat,3) AS end_lat,
  ROUND(end_lng,3) AS end_lng
FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024`;

-- Remove duplicates
    -- Remove records with duplicate ride_id values.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step3` AS
SELECT * EXCEPT(rn)
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
  FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step2`
)
WHERE
  rn = 1;

-- Remove extra spaces and blanks
    -- Select records with rideable_type of CLASSIC% and start_station_id and end_station_id are not null.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step5` AS
SELECT *
FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step3`
WHERE
  rideable_type LIKE 'CLASSIC%' AND (start_station_id IS NOT NULL AND end_station_id IS NOT NULL) OR
  rideable_type LIKE 'ELECTRIC%';

-- Fix incorrect/inaccurate data
    -- Select records that do not contain start_sta_id or end_sta_id values previously-identified invalid.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6a` AS
SELECT *
FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step5`
WHERE
  (start_station_id NOT LIKE '%BIKE FLEET%' OR start_station_id IS NULL) AND
  (start_station_id NOT LIKE '%HUBBARD BIKE-CHECKING (LBS-WH-TEST)%' OR start_station_id IS NULL) AND
  (end_station_id NOT LIKE '%BIKE FLEET%' OR end_station_id IS NULL) AND
  (end_station_id NOT LIKE '%HUBBARD BIKE-CHECKING (LBS-WH-TEST)%' OR end_station_id IS NULL);

-- Fix incorrect/inaccurate data
    -- Calculate duration_seconds and duration_hms
    -- Omit records that are not between 60 seconds and 24 hours.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6b` AS

WITH
 -- Convert timestamps to unix seconds (seconds since 1970-01-01 00:00:00 UTC.)
convert_to_unix AS (
  SELECT
    *,
    UNIX_SECONDS(started_at) AS start_unix_secs,
    UNIX_SECONDS(ended_at) AS end_unix_secs,
  FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6a`
),

-- Calculate the duration (elapsed time) using seconds.
calculate_duration_secs AS (
  SELECT
    *,
    (end_unix_secs - start_unix_secs) AS duration_secs
  FROM
    convert_to_unix
),

-- Select records with duration_seconds between 60 and 86,400 (24 hrs).
filter_duration AS (
  SELECT *
  FROM calculate_duration_secs
  WHERE
    duration_secs BETWEEN 60 AND 86400
)

-- Create a column for duration expressed as HH:MM:SS.
SELECT
  *,
  FORMAT('%02d:%02d:%02d',
    DIV(duration_secs, 3600),
    DIV(MOD(duration_secs, 3600), 60),
    MOD(duration_secs, 60)
  ) AS duration_hms
FROM filter_duration;

-- Fix incorrect/inaccurate data
    -- Select records that fall within the main cluster of geolocation values, omitting outliers.
    -- Do not filter out records having coordinates with null values.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6c` AS
SELECT *
FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6b`
WHERE
  start_lat IS NOT NULL AND
  end_lat IS NOT NULL AND
  start_lng IS NOT NULL AND
  end_lng IS NOT NULL AND
  start_lat BETWEEN 41.6485 AND 42.0700 AND
  end_lat BETWEEN 41.6485 AND 42.0700 AND
  start_lng BETWEEN -87.8500 AND -87.5282 AND
  end_lng BETWEEN -87.8500 AND -87.5282;



