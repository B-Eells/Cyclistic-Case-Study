-- ride_id: count the number of records for which the `ride_id` is null.

SELECT
  COUNT(CASE WHEN ride_id IS NULL THEN 1 END) AS null_ride_id,
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- ride_id: count duplicates, compare COUNT total ride_id values vs. COUNT distinct ride_id values

SELECT
  COUNT (ride_id) AS count_total_ride_ids,
  COUNT (DISTINCT ride_id) AS count_unique_ride_ids,
  COUNT (ride_id) - COUNT (DISTINCT ride_id) AS Difference
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

  -- rideable_type: validate that rideable_type field contains only three discreet values.

SELECT DISTINCT
  rideable_type
FROM vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- started_at & ended_at: check for nulls

SELECT
  COUNT(CASE WHEN started_at IS NULL THEN 1 END) AS null_started_at,
  COUNT(CASE WHEN ended_at IS NULL THEN 1 END) AS null_ended_at,
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- started_at & ended_at: check the min and max timestamp values to ensure they all fall within 2024

SELECT
  MIN(started_at) AS min_started_at,
  MAX(started_at) AS max_started_at,
  MIN(ended_at) AS min_ended_at,
  MAX(ended_at) AS max_ended_at,
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- started_at & ended_at: ensure we have data for the expected number of days in each month

SELECT
    TimestampExtracts.start_month,
    COUNT(DISTINCT TimestampExtracts.start_day) AS date_counts
FROM (
      SELECT
        *,
        EXTRACT(QUARTER FROM started_at) AS start_qtr,
        EXTRACT(DATE FROM started_at) AS start_date,
        EXTRACT(MONTH FROM started_at) AS start_month,
        EXTRACT(WEEK FROM started_at) AS start_week,
        EXTRACT(DAY FROM started_at) AS start_day,
        EXTRACT(DAYOFWEEK FROM started_at) AS start_day_of_week,
        EXTRACT(TIME FROM started_at) AS start_time_of_day,
        EXTRACT(QUARTER FROM ended_at) AS end_qtr,
        EXTRACT(DATE FROM ended_at) AS end_date,
        EXTRACT(MONTH FROM ended_at) AS end_month,
        EXTRACT(WEEK FROM ended_at) AS end_week,
        EXTRACT(DAY FROM ended_at) AS end_day,
        EXTRACT(DAYOFWEEK FROM ended_at) AS end_day_of_week,
        EXTRACT(TIME FROM ended_at) AS end_time_of_day
      FROM vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024
      ORDER BY started_at
      ) AS TimestampExtracts
  GROUP BY TimestampExtracts.start_month
  ORDER BY TimestampExtracts.start_month;

-- Aggregate then plot the number of trips for each day of the year to see if we can spot gaps in data.

SELECT
  DATE(started_at) AS started_at_date,
  COUNT(*) AS daily_count
FROM vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024
GROUP BY started_at_date
ORDER BY started_at_date;

-- started_at & ended_at
    -- Calculate duration_hms and duration_seconds 
    -- Filter out records that are not between 60 seconds and 24 hours (86,400 seconds).

    WITH
    -- Convert timestamps to unix seconds (seconds since 1970-01-01 00:00:00 UTC.)
    convert_to_unix AS (
      SELECT
        ride_id,
        started_at,
        ended_at,
        UNIX_SECONDS(started_at) AS start_unix_secs,
        UNIX_SECONDS(ended_at) AS end_unix_secs,
      FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024`
    ),

    -- Calculate the duration (elapsed time) using seconds.
    calculate_duration_secs AS (
      SELECT
        *,
        (end_unix_secs - start_unix_secs) AS duration_secs
      FROM
        convert_to_unix
    )

    -- Count records that are NULL, or not between 60 and 86,400 (24 hrs).
    SELECT
      COUNTIF(duration_secs IS NULL) AS duration_nulls,
      COUNTIF(duration_secs NOT BETWEEN 60 AND 86400) AS duration_omit
    FROM
      calculate_duration_secs;

-- start_station_id, start_station_name, end_station_id & end_station_name: check for nulls by rideable_type.

WITH sta_null_ct_by_type AS (
  SELECT
    -- Base counts for classic_bike
    COUNTIF(rideable_type LIKE 'classic_bike') AS classic_ride_tot,
    COUNTIF(rideable_type LIKE 'classic_bike' AND (start_station_id IS NULL OR start_station_name IS NULL OR end_station_id IS NULL OR end_station_name IS NULL)) AS classic_sta_nulls,
    -- Base counts for electric_bike
    COUNTIF(rideable_type LIKE 'electric_bike') AS ebike_ride_tot,
    COUNTIF(rideable_type LIKE 'electric_bike' AND (start_station_id IS NULL OR start_station_name IS NULL OR end_station_id IS NULL OR end_station_name IS NULL)) AS ebike_sta_nulls,
    -- Base counts for electric_scooter
    COUNTIF(rideable_type LIKE 'electric_scooter') AS escoot_ride_tot,
    COUNTIF(rideable_type LIKE 'electric_scooter' AND (start_station_id IS NULL OR start_station_name IS NULL OR end_station_id IS NULL OR end_station_name IS NULL)) AS escoot_sta_nulls
  FROM vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024
)
-- Create output of above counts, including percentages
SELECT
    -- classic_bike
    classic_ride_tot,
    classic_sta_nulls,
    (classic_sta_nulls / classic_ride_tot) AS classic_sta_null_pct,
    -- electric_bike
    ebike_ride_tot,
    ebike_sta_nulls,
    (ebike_sta_nulls / ebike_ride_tot) AS ebike_sta_null_pct,
    -- electric_scooter
    escoot_ride_tot,
    escoot_sta_nulls,
    (escoot_sta_nulls / escoot_ride_tot) AS escoot_sta_null_pct
FROM sta_null_ct_by_type;

-- start_station_id & start_station_name: check for nulls

SELECT
  COUNT(CASE WHEN start_station_name IS NULL THEN 1 END) AS start_sta_name_null_ct,
  COUNT(CASE WHEN end_station_name IS NULL THEN 1 END) AS end_sta_name_null_ct
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- start_station_id & end_station_id: check fields for nulls.

SELECT
  COUNT(CASE WHEN start_station_id IS NULL THEN 1 END) AS start_sta_id_null_ct,
  COUNT(CASE WHEN end_station_id IS NULL THEN 1 END) AS end_sta_id_null_ct
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- start_lat, start_lng, end_lat & end_lng: for rideable_type of 'classic%', COUNT the nulls in the coordinate fields

SELECT
  COUNT(CASE WHEN start_lat IS NULL THEN 1 END) AS null_start_lat,
  COUNT(CASE WHEN start_lng IS NULL THEN 1 END) AS null_start_lng,
  COUNT(CASE WHEN end_lat IS NULL THEN 1 END) AS null_end_lat,
  COUNT(CASE WHEN end_lng IS NULL THEN 1 END) AS null_end_lng,
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024
WHERE
  rideable_type LIKE 'classic%';

-- start_lat, start_lng, end_lat & end_lng: for rideable_type of 'electric%', COUNT the nulls in the coordinate fields

SELECT
  COUNT(CASE WHEN start_lat IS NULL THEN 1 END) AS null_start_lat,
  COUNT(CASE WHEN start_lng IS NULL THEN 1 END) AS null_start_lng,
  COUNT(CASE WHEN end_lat IS NULL THEN 1 END) AS null_end_lat,
  COUNT(CASE WHEN end_lng IS NULL THEN 1 END) AS null_end_lng,
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024
WHERE
  rideable_type LIKE 'electric%';

-- start_lat, start_lng, end_lat & end_lng: check the min and max values for the geolocation fields to ensure they fall within the possible range.

SELECT
  MIN(start_lat) AS min_start_lat,
  MAX(start_lat) AS max_start_lat,
  MIN(start_lng) AS min_start_lng,
  MAX(start_lng) AS max_start_lng,
  MIN(end_lat) AS min_end_lat,
  MAX(end_lat) AS max_end_lat,
  MIN(end_lng) AS min_end_lng,
  MAX(end_lng) AS max_end_lng
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024;

-- start_lat, start_lng, end_lat & end_lng: count records that are not null, but fall outside the "main cluster" of geolocation values.

SELECT
  COUNT(*) AS geo_values_outside_cluster
FROM
  vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024
WHERE
  start_lat IS NOT NULL AND
  start_lat < 41.6485 OR
  start_lat > 42.0700 OR
  end_lat IS NOT NULL AND
  end_lat < 41.6485 OR
  end_lat > 42.0700 OR
  start_lng IS NOT NULL AND
  start_lng < -87.8500 OR
  start_lng > -87.5282 OR
  end_lng IS NOT NULL AND
  end_lng < -87.8500 OR
  end_lng > -87.5282;

-- member_casual: validate that field contains two discrete values: 'member' or 'casual'.

SELECT DISTINCT
  member_casual
FROM vibrant-chain-456515-p9.DivvyTripdata2024Combined.DivvyTripdata2024




