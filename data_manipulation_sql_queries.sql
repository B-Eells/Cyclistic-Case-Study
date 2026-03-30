-- Data Transformation:
    -- Add columns for the start_mo (1 = Jan) and start_mo_name.
    -- Add column for the start_day_of_week (1 = Monday, 7 = Sunday) and start_day_of_wk_name.
    -- Add column for the start_hour_of_day (24 hour) and start_hour_of_day_name.
    -- If station id or name missing, populate record with "NO STATION".
    -- Create virtual location id's based on coordinates.
    -- Calculate route distances in meters.
    -- Create a column to identify route using coordinates.

CREATE OR REPLACE TABLE `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6f` AS
SELECT
  ride_id,
  member_type,
  rideable_type,
  started_at,
  CASE
    WHEN EXTRACT(MONTH FROM started_at) IN (12, 1, 2) THEN '1'
    WHEN EXTRACT(MONTH FROM started_at) IN (3, 4, 5) THEN '2'
    WHEN EXTRACT(MONTH FROM started_at) IN (6, 7, 8) THEN '3'
    ELSE '4'
  END AS start_season,
  CASE
    WHEN EXTRACT(MONTH FROM started_at) IN (12, 1, 2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM started_at) IN (3, 4, 5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM started_at) IN (6, 7, 8) THEN 'Summer'
    ELSE 'Fall'
  END AS start_season_name,
  FORMAT_TIMESTAMP('%m', started_at) AS start_mo,
  FORMAT_TIMESTAMP('%b', started_at) AS start_mo_name,
  FORMAT_TIMESTAMP('%u', started_at) AS start_day_of_wk,
  FORMAT_TIMESTAMP('%a', started_at) AS start_day_of_wk_name,
  FORMAT_TIMESTAMP('%k', started_at) AS start_hour_of_day,
  FORMAT_TIMESTAMP('%l:00' '%p', started_at) AS start_hour_of_day_name,
  ended_at,
  duration_hms,
  duration_secs,
  COALESCE(start_station_id, 'NO STATION') AS start_station_id,
  COALESCE(start_station_name, 'NO STATION') AS start_station_name,
  COALESCE(end_station_id, 'NO STATION') AS end_station_id,
  COALESCE(end_station_name, 'NO STATION') AS end_station_name,
  start_lat,
  start_lng,
  CONCAT(CAST(start_lat AS STRING), ", ", CAST(start_lng AS STRING)) AS v_start_loc_id,
  end_lat,
  end_lng,
  CONCAT(CAST(end_lat AS STRING), ", ", CAST(end_lng AS STRING)) AS v_end_loc_id,
  CONCAT(start_lat, ', ', start_lng, ' to ', end_lat, ', ', end_lng) AS geo_route,
  CAST(ST_DISTANCE(ST_GEOGPOINT(start_lng, start_lat), ST_GEOGPOINT(end_lng, end_lat)) AS INT64) AS distance_in_meters
FROM `vibrant-chain-456515-p9.DivvyTripdata2024Combined.cleaning_step6e`
ORDER BY started_at;
