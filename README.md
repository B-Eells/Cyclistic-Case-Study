
<img width="500" height="200" alt="Screenshot 2026-02-27 at 12 26 12 PM" src="https://github.com/user-attachments/assets/21685ed4-b0f5-49a9-9544-e8d9e00ff9c6" />

# Google Data Analytics Case Study: Cyclistic Bike Share

## Introduction

The purpose of this data analysis case study is for me to exhibit my command of the key steps of the data analysis process: Ask, Prepare, Process, Analyze, Share, Act. The case study is based on a fictitional bike-share company, but the source data is from a real-world operation.

References:
* [Coursera: Google Data Analytics Professional Certificate](https://www.coursera.org/professional-certificates/google-data-analytics)
* [Case Study 1_How does a bike-share navigate speedy success.pdf](https://github.com/user-attachments/files/26315462/Case.Study.1_How.does.a.bike-share.navigate.speedy.success.pdf)


[Links to steps in paragraph above]

## Scenario

I am a junior data analyst working on the marketing analyst team at Cyclistic, a bike-share
company in Chicago. Cyclistic's Director of Marketing, Lily Moreno, believes the company’s future success depends on maximizing the number of annual memberships. Therefore, the marketing analytics team wants to understand how casual riders and annual members differ in their use of Cyclistic bikes. From these insights, our team will design a new marketing strategy to convert casual riders into annual members. Cyclistic executives must approve our recommendations, so they must be backed up with compelling data insights and professional data visualizations.

Three questions provided that will guide the future marketing program:
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

I have been specifically assigned to answer the first question. I have also been asked to contribute some recommendation on the marketing strategy.

## Step 1: Ask

### Business Task

Using Cyclistic historical bike trip data, identify how annual members and casual riders differ in their use of Cyclistic bikes. Based on my insights make some recommendations on marketing strategy to convert casual riders into annual members.

## Step 2: Prepare

### Data Locations

#### Source Data

Source data was obtained from the following location provided in the case study: [divvy_tripdata](
https://divvy-tripdata.s3.amazonaws.com/index.html). From this page I downloaded to my computer a separate .zip file for each month of 2024.

Regarding licensing, the case study cited that the data was made available by Motivate International, Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

#### Google Cloud

In my **Google Cloud** account, I created a bucket called **2024_divvy-tripdata-bucket** and uploaded the source files to it. I chose this location due to its capacity and ease of access using Big Query. For backup, I uploaded the 12 zip files to my personal Google Drive account. 

#### Google BigQuery

I performed data exploration and analysis using Google BigQuery, where I created a dataset called **2024_divvy_tripdata_comb**. Within that dataset I created a table called **2024_divvy_tipdata** where I combined all of the monthly data from my Google Cloud bucket. Within the same directory I  also saved cleaning and analysis tables.

### Data Organization

The table **2024_divvy_tripdata_comb.2024_divvy_tipdata** contains combined data from all 12 months of 2024, and has the below schema. Note that each variable exists as the appropriate data type. Short descriptions of each field also appear below. This combined dataset has **5,860,568** rows.

| Field Name | Type | Mode | Description
| --- | --- | --- | ---
| ride_id | String | Nullable | The unique identifier for the ride.
| rideable_type | String | Nullable | The equipment type used for the ride.
| started_at | Timestamp | Nullable | The date and time the ride started.
| ended_at | Timestamp | Nullable | The date and time the ride ended.
| start_station_name | String | Nullable | The name of the station where the ride started.
| start_station_id | String | Nullable | The unique identifier of the station where the ride started.
| end_station_name | String | Nullable | The name of the station where the ride ended.
| end_station_id | String | Nullable | The unique identifier of the station where the ride ended.
| start_lat | Float | Nullable | The latitude coordinate where the ride started.
| start_lng | Float | Nullable | The longitude coordinate where the ride started.
| end_lat | Float | Nullable | The latitude coordinate where the ride ended.
| end_lng | Float | Nullable | The longitude coordinate where the ride ended.
| member_casual | String | Nullable | The membership type of the rider.

### Data Credibility

I do not believe this data to have issues with bias or credibility, as it passes the "ROCCC" test:
* **Reliability**: I believe this data to be reliable (vetted and fit for use) since it is a public dataset vetted by Coursera.
* **Original**: I obtained the data directly from the source provided in the case study. (1st party data)
* **Comprehensive**: The case study states, "For the purposes of this case study, the datasets are appropriate and will enable you to answer the business questions."
* **Current**: The data is from 2024, which was the most current full year when I started this case study.
* **Cited**: the case study cited that the data was made available by Motivate International, Inc. under this [license](https://www.divvybikes.com/data-license-agreement). The dataset appears to have been last refreshed in June of 2025, so it seems sufficiently current.

## Step 3: Process

### Data Integrity

By running the following [Data Integrity SQL Queries], I idenfified the following issues:

| Field(s) | Issues
| --- | ---
| `ride_id` | 211 duplicates
| `rideable_type` | No issues
| `started_at`, `ended_at` | 138,852 records have a duration that does not fall between 60 seconds and 24 hours.
| `start_station_name` | 1,073,951 nulls and 3 invalid values found.
| `start_station_id` | 1,073,951 nulls and 3 invalid values found.
| `end_station_name` | 1,104,653 nulls and 95 rows where an `end_station_id` has more than one `end_station_name`.
| `end_station_id` | 1,104,653 nulls and 2 invalid values found.
| `start_lat`, `start_lng`, `end_lat`, `end_lng` | 7,232 nulls within `end_lat` and `end_lng`, plus 342 geographic outliers.

### Data Cleaning and Manipulation

#### Data Cleaning

By running the following [Data Cleaning SQL Queries], I made changes to the data as recorded in this [Cyclistic Case Study Changelog.xlsx](https://github.com/user-attachments/files/26317199/Cyclistic.Case.Study.Changelog.xlsx). I have also validated these changes as a separate step.

#### Data Manipulation

By running the following [Data Manipulation SQL Queries], I processed the data for the Analysis step as listed below. (manipulations also listed in the changelog above)
* I broke out the `started_at` timestamp into month, day of week, and hour of day. I also created fields for the name of each dimension for easier display in Tableau.
* I calculated duration not only in mm:ss format, but also in seconds (INT64 format) for easier calculation.
* Because the majority of rides were on `rideable_types` that were electric and therefore not necessarily tethered to stations, I decided to analyze data not by station, but by geographic location. As such, I created "virtual start station id's" and "virtual end station id's" to help with Grouping for distance and route calculations.
* To retain a larger data set, I also chose not to delete records that had missing station data. (I did not end up using the station data)
* I calculated the distance in meters for each ride so I could compare the member types in terms of average distance ridden.
* I calculated the routes so I could rank their popularity.

My resultant schema going into the Analysis step looked like this:
| Field name | Data Type | Source
| --- | --- | ---
| ride_id | string | provided
| member_type | string | provided
| rideable_type | string | provided
| started_at | timestamp | provided
| start_mo | string | calculated
| start_mo_name | string | calculated
| start_day_of_wk | string | calculated
| start_day_of_wk_name | string | calculated
| start_hour_of_day | string | calculated
| start_hour_of_day_name | string | calculated
| ended_at | timestamp | calculated
| duration_hms | string | calculated
| duration_secs | integer | calculated
| distance_in_meters | integer | calculated
| start_station_id | string | provided
| start_station_name | string | provided
| end_station_id | string | provided
| end_station_name | string | provided
| start_lat | string | provided
| start_lng | string | provided
| v_start_station_id | string | calculated
| end_lat | string | provided
| end_lng | string | provided
| v_end_station_id | string | calculated
| geo_route | string | calculated







