-- Total ride count for 2024

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_start_2024` AS
WITH ValueCounts AS (
    SELECT
        member_type,
        COUNT(*) AS ride_ct,
        -- Calculate percentage: (Category Sales * 100.0) / Total Sales
        ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 1) AS pct_of_total
    FROM
        `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
      member_type
)
SELECT
    member_type,
    ride_ct,
    pct_of_total
FROM
    ValueCounts
ORDER BY
    member_type DESC;

-- Ride count by start month.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_start_mo` AS
WITH ValueCounts AS (
    SELECT
        member_type,
        start_mo,
        start_mo_name,
        COUNT(*) AS ride_ct,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_type), 2) AS pct_of_member_total
    FROM
        `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
        member_type,
        start_mo,
        start_mo_name
)
SELECT
    member_type,
    start_mo,
    start_mo_name,
    ride_ct,
    pct_of_member_total
FROM
    ValueCounts
ORDER BY
    member_type DESC,
    start_mo;

-- Ride percent by day of week.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_start_day_of_wk` AS
WITH ValueCounts AS (
    SELECT
        member_type,
        start_day_of_wk,
        start_day_of_wk_name,
        COUNT(*) AS ride_ct,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_type), 2) AS pct_of_member_total
    FROM
        `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
        member_type,
        start_day_of_wk,
        start_day_of_wk_name
)
SELECT
    member_type,
    start_day_of_wk,
    start_day_of_wk_name,
    ride_ct,
    pct_of_member_total
FROM
    ValueCounts
ORDER BY
    member_type DESC,
    start_day_of_wk;

-- Ride percent by start_hour_of_day.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_start_hour_of_day` AS
WITH ValueCounts AS (
    SELECT
        member_type,
        start_hour_of_day,
        start_hour_of_day_name,
        COUNT(*) AS ride_ct,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_type), 2) AS pct_of_member_total
    FROM
        `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
        member_type,
        start_hour_of_day,
        start_hour_of_day_name
)
SELECT
    member_type,
    start_hour_of_day,
    start_hour_of_day_name,
    ride_ct,
    pct_of_member_total
FROM
    ValueCounts
ORDER BY
    member_type DESC,
    start_hour_of_day;

-- Average ride duration in mm:ss

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_avg_duration2` AS
WITH AvgDuration AS (
  SELECT
    member_type,
    MAX(duration_secs) AS max_duration_seconds,
    MIN(duration_secs) AS min_duration_seconds,
    CAST(AVG(duration_secs) AS INT64) AS avg_duration_seconds
  FROM
    `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
  GROUP BY
    member_type
)
SELECT
  member_type,
  avg_duration_seconds,
    -- Calculate hours (handling >24 hours)
  CAST(FLOOR(avg_duration_seconds / 3600) AS STRING) || ':' ||
  -- Calculate minutes and left-pad with zero
  LPAD(CAST(FLOOR(MOD(avg_duration_seconds, 3600) / 60) AS STRING), 2, '0') || ':' ||
  -- Calculate remaining seconds and left-pad with zero
  LPAD(CAST(MOD(avg_duration_seconds, 60) AS STRING), 2, '0') AS avg_duration_hms
FROM AvgDuration;

-- Average ride distance in meters, including zero-distance trips.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_avg_distance` AS
SELECT
  member_type,
  CAST(AVG(distance_in_meters) AS INT64) AS avg_distance_meters
FROM
  `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
GROUP BY
  member_type;

-- Percent of rides by rideable_type

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_rideable_type` AS
SELECT
  member_type,
  rideable_type,
  COUNT(*) AS ride_ct,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_type), 2) AS pct_of_member_total
FROM
  `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
GROUP BY
  member_type,
  rideable_type
ORDER BY
  member_type DESC,
  rideable_type;

-- Calculate the 25 most popular virtual start locations.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_v_start_loc_top25` AS
WITH ValueCounts AS (
    SELECT
      member_type,
      v_start_loc_id,
      start_lat,
      start_lng,
      COUNT(*) AS ride_ct,
      RANK() OVER (PARTITION BY member_type ORDER BY COUNT(*) DESC) AS rank,
      ROW_NUMBER() OVER (PARTITION BY member_type ORDER BY COUNT(*) DESC) AS rn
    FROM
      `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
      member_type,
      v_start_loc_id,
      start_lat,
      start_lng
)
SELECT
  member_type,
  rank,
  ride_ct,
  v_start_loc_id,
  start_lat,
  start_lng
FROM
  ValueCounts
WHERE
  rn <= 25
ORDER BY
  member_type DESC,
  rank,
  ride_ct,
  v_start_loc_id;

-- Calculate 25 most popular virtual end locations.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_v_end_loc_top25` AS
WITH ValueCounts AS (
    SELECT
      member_type,
      v_end_loc_id,
      end_lat,
      end_lng,
      COUNT(*) AS ride_ct,
      RANK() OVER (PARTITION BY member_type ORDER BY COUNT(*) DESC) AS rank,
      ROW_NUMBER() OVER (PARTITION BY member_type ORDER BY COUNT(*) DESC) AS rn
    FROM
      `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
      member_type,
      v_end_loc_id,
      end_lat,
      end_lng
)
SELECT
  member_type,
  rank,
  ride_ct,
  v_end_loc_id,
  end_lat,
  end_lng
FROM
  ValueCounts
WHERE
  rn <= 25
ORDER BY
  member_type DESC,
  rank,
  ride_ct,
  v_end_loc_id;

-- Plot the 100 most popular routes. (will use MAKEPOINT and MAKELINE functions in Tableau)

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.z_geo_routes_top100` AS
WITH ValueCounts AS (
    SELECT
      member_type,
      geo_route,
      v_start_loc_id,
      start_lat,
      start_lng,
      v_end_loc_id,
      end_lat,
      end_lng,
      COUNT(*) AS ride_ct,
      RANK() OVER (PARTITION BY member_type ORDER BY COUNT(*) DESC) AS rank,
      ROW_NUMBER() OVER (PARTITION BY member_type ORDER BY COUNT(*) DESC) AS rn
    FROM
      `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f`
    GROUP BY
      member_type,
      geo_route,
      v_start_loc_id,
      start_lat,
      start_lng,
      v_end_loc_id,
      end_lat,
      end_lng
)
SELECT
  member_type,
  rank,
  ride_ct,
  geo_route,
  v_start_loc_id,
  start_lat,
  start_lng,
  v_end_loc_id,
  end_lat,
  end_lng
FROM
  ValueCounts
WHERE
  rn <= 100
ORDER BY
  member_type DESC,
  rank,
  ride_ct;

