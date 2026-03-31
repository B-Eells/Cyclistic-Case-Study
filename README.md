
<img width="500" height="200" alt="Screenshot 2026-02-27 at 12 26 12 PM" src="https://github.com/user-attachments/assets/21685ed4-b0f5-49a9-9544-e8d9e00ff9c6" />

# Google Data Analytics Case Study: Cyclistic Bike Share

## Introduction

The purpose of this data analysis case study is for me to exhibit my command of the key steps of the data analysis process: [Ask](https://github.com/B-Eells/Cyclistic-Case-Study/edit/main/README.md#step-1-ask), [Prepare](https://github.com/B-Eells/Cyclistic-Case-Study/edit/main/README.md#step-2-prepare), [Process](https://github.com/B-Eells/Cyclistic-Case-Study/edit/main/README.md#step-3-process), [Analyze](https://github.com/B-Eells/Cyclistic-Case-Study/edit/main/README.md#step-4-analysis), Share, Act. The case study is based on a fictitional bike-share company, but the source data is from a real-world operation.

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

In my **Google Cloud** account, a bucket was created called **2024_divvy-tripdata-bucket** and the source files were uploaded to it. This storage solution was chosen due to its capacity and ease of access using Big Query. For backup, the 12 .zip files were uploaded to my personal Google Drive account. 

#### Google BigQuery

Data exploration and analysis was carried out using Google BigQuery, where I created a dataset called **2024_divvy_tripdata_comb**. Within that dataset I created a table called **2024_divvy_tipdata** where I combined all of the monthly data from my Google Cloud bucket. Within the same directory I also saved tables used for cleaning and analysis.

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

By running the following [Data Integrity SQL Queries](https://github.com/B-Eells/Cyclistic-Case-Study/blob/main/data_integrity_sql_queries.sql), the following issues were identified:

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

By running the following [Data Cleaning SQL Queries](https://github.com/B-Eells/Cyclistic-Case-Study/blob/main/data_cleaning_sql_queries.sql), changes were made to the data and documented in the [Cyclistic Case Study Changelog.xlsx](https://github.com/user-attachments/files/26317199/Cyclistic.Case.Study.Changelog.xlsx). These changes have also been validated in a separate "technical validation" step, which is not detailed here.

#### Data Transformation

By running the following [Data Transformation SQL Queries](https://github.com/B-Eells/Cyclistic-Case-Study/blob/main/data_transformation_sql_queries.sql), the data was processed for the Analysis step as listed below. (manipulations also listed in the changelog above)
* The `started_at` timestamp was broken out into month, day of week, and hour of day. Fields for the name of each dimension were also created for easier display in Tableau.
* The duration was calculated not only in mm:ss format, but also in seconds (INT64 format) for easier calculation.
* Because the majority of rides were on `rideable_types` that were electric and therefore not necessarily tethered to stations, analysis was not carried out by station, but rather by geographic location. As such, "virtual" start and end station id's were created to help with grouping for route calculations.
* To retain a larger data set, records that had missing station data were not deleted.
* The "distance in meters" was calcuated we we could analyze the average distance ridden.
* The routes were established so their popularity could be ranked.

The resultant schema going into the Analysis step looked like this:
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

## Step 4: Analyze

By running the following [Data Analysis SQL Queries] to generate tables, we are then able to visualize them in Tableau to compare and contrast the usage patterns. The first section discusses the differences in usage patterns.  However, I deemed it important to also share a second section that displays similarities, because even though the trends may not be different, they contain data, observations and insights that can be critical to the effective targeting of our marketing.

Summary statistics with identification of trends, relationships and surprises.

### Total Ride Volume
* Total volume of rides: 5,720,900 (100%)
* Total volume rides by annual members: 3,641,071 (63.6%)
* Total volume of rides by casual riders: 2,079,829 (36.5%)
* Insights: from a percent of total perspective, it appears to be a reasonable endeavor to convert casual riders to annual members.  If casual riders were a very slim minority (5% for example) or an overwheling majority (95% for example), conversions may not be where we want to focus our efforts.

### Ride Volume by Month
* The most popular months for both annual members and casual riders is May-Oct.
* Trends: 
* Trends/Relationships:
  * Ridership for both groups climbs in the Spring, peaks during summer and declines in the fall, showing a very similar trend.
  * A quick look at historical weather patterns for Chicago reveals this pattern corresponds to the historically warmer months.
* Insights: although this does not represent a difference in usage trends, it is important information to be considered when targeting our marketing.

<img width="393" height="293" alt="Screenshot 2026-03-30 at 3 34 51 PM" src="https://github.com/user-attachments/assets/6e76e319-932d-4646-83f0-505515cc072b" />
  
### Ride Volume by Day of Week
* The most popular days of week for annual members:
  * Wednesday (16%)
  * Tuesday (15%)
  * Thursday (15%)
* Most popular days of week for casual riders:
  * Saturday (21%)
  * Sunday (17%)
  * Friday (15%)
* Trends:
  * Annual members ride more often during weekdays and less often on weekends.
  * Casual riders ride more often on weekends and less often on weekdays.
* Trends/Relationships: the ride volume by day of week for annual members and casual riders is a largely inverse relationship.
* Insights:
  * For casual riders, although Saturday and Sunday boast the highest ridership from an "average daily" perspective, weekdays should not be discounted as having low ridership.  For casual riders, collectively weekdays comprise 63% of total rides.
  * The weekday popularity for annual members suggest that many use the bikes to get to and from work. This supports the narrative that casual riders use the bikes more for pleasure.  

### Ride Volume by Hour of Day
* The most popular time of day for both annual members and casual riders are the 3:00pm through 6:00pm hours, with the apex during the 5:00pm hour.
* The least popular time of day for both rider types is in the middle of the night, between the 2:00am through 4:00am hours.
* Trends/Relationships: the usage pattern between the two rider times is similar, except annual members also have a second, smaller spike in the hours leading up to work, 6:00am to 8:00am.
* Insights: the peak times for casual riders is between 11:00am and 7:00pm, when over 60% of their rides occur. This supports the story that annual members use the bikes more for efficient transportation (going to and from work) than pleasure.

### Average Ride Duration & Distance
* While the min and max ride durations for annual member and casual riders are simlar, annual members had an average ride duration of 12 minutes, 24 seconds, while casual riders had an average ride duration of 21 minutes, 23 seconds - almost double.
* The average distance per ride for annual members and casual riders was 2,209 meters and 2,173 respectively -- so they are very close.
* Insights: an average per ride, casual riders cover approximately half the ground that annual members do.  The story this tells is that annual members use the bikes more for transportation, efficiently travelling between point A and point B.  Casual riders on the other hand, appear to meander or stop more frequently, indicating they are more likely using the bikes for pleasure and sightseeing.

### Start and End Locations, Routes

Observations: for annual members, the top 10 start and end locations are not along the shore, they are in more urban areas including the train station, commercial areas and urban neighborhoods. The most popular location for annual members is Chicago Union Station. This supports the story that annual members use the bikes mostly for transporation. Meanwhile, for casual riders, the top locations are along the shore and adjacent to popular attractions. The most popular location for casual riders is Navy Pier. This supports the story that casual members use the bikes more for pleasure and sightseeing.
Insight: this was perhaps the most surprising and telling information revealed in this study.  This really underscores the narrative that annual members use the bikes for transportation and casual riders use the bikes mostly for pleasure and sightseeing.

### Percent of Rides by Rideable Type

Annual members and Casual riders have a very similar breakdown of rideable_type usage. For both groups, 50% of their rides were on electric bikes, about 2-4% on electric scooters, and about 46-48% on classic bikes. 

### Summary
The story behind the data is that annual members use the bike share mostly for transportation in urban areas on weekdays, with Chicago Union Station being the most popular hub.  Casual riders on the other hand primarily use the bikes for pleasure and sightseeing near coastal attractions and along the shoreline. Casual members' favorite days to ride are Saturdays and Sundays, but weekdays should not be dismissed because they also have significant ridership.

To target our marketing most effectively, I think it's important to understand certain casual rider preferences even though they are similar to that of annual members. Most riding for both groups occurs during the warmer months of May-October, and usage is highest in the late afternoon/early evenings. Also, both groups have almost an equal preference for electric bikes and classic bikes, but ridership of electric scooters is very low at 2-4%. So ad content and/or imagery should definitely focus on bikes of both types.
