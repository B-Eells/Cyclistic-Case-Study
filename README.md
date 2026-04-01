
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

## Step 4: Analyze & Step 5: Share

By running the following [Data Analysis SQL Queries] to generate tables, we are then able to [visualize them in Tableau] to compare and contrast trends in usage patterns.

### Summary

The story behind the data is that while annual members use the Cyclistic bikes mostly on weekdays for commuting and transportation in urban areas, casual riders use Cyclistic bikes mostly on weekends for pleasure and sightseeing along the waterfront and adjacent to attractions.

Casual riders differ from annual members in the following specific areas:
* Over the course of the year, annual members accounted for 64% of the rides while casual riders accounted for 36% of the rides.
* Annual members had the highest average daily ride count on weekdays, while casual riders had the highest average daily ride count on weekends.
* In terms of the hour of day that was most popular with each group, it was the 5:00pm hour.  However, annual members also had second peak around the 8:00am hour, while casual riders did not.
* Though both rider segments roughly equalled each other in average ride distance, annual member covered that ground in about half the time as casual riders.
* While annual members rode more efficiently and top locations were all in urban areas, casual riders rode slower and perhaps with more stops along the waterfront and near visitor attractions proximate to the waterfront.

Casual riders did not differ from annual members in the following specific areas, but the data is likely importand for marketing anwyway:
* Ridership across both groups was greatest in the momths when Chicago is warmest, May through October.
* The most popular time of day for casual riders was between 11:00am and 7:00pm, peaking at 5:00pm.
* Both groups had a similar breakdown of rideable types. Electric scooters were not very popular, while classic bikes and e-bikes were evenly split. (this may relate more to do with marketing content than targeting)

### Total Ride Volume

**Insight:** From a percent of total perspective, it appears to be a reasonable endeavor to convert casual riders to annual members.  If casual riders were a very slim minority (5% for example) or an overwheling majority (95% for example), conversions may not be where we want to focus our efforts.

<img width="80%" alt="Total Rides 2024" src="https://github.com/user-attachments/assets/1366e4fc-23e5-4ffa-a176-8868f2729f57" />

### Ride Volume by Month

The monthly trend for both segments is almost identical. Usage climbs in the Spring, peaks during summer and declines in the fall, showing a very similar trend.  A quick look at historical weather patterns for Chicago reveals that usage corresponds with the historically warmer months. **Insights:** although this data does not show a difference in usage trends between the two rider types, peak usage months is important data that should be considered when targeting our marketing.

<img width="80%" alt="Rides per Month" src="https://github.com/user-attachments/assets/da2b123e-a7f6-4d78-85ae-cc7e290c9827" />

<img width="393" height="293" alt="Screenshot 2026-03-30 at 3 34 51 PM" src="https://github.com/user-attachments/assets/6e76e319-932d-4646-83f0-505515cc072b" />
  
### Ride Distribution by Day of Week

For annual members the days with the highest average daily ride volume are weekdays. Casual riders have the opposite trend: the days with the highest average daily volume are weekends. **Insights:** this difference in riding trends supports the narrative that annual members use the service more for getting to/from work, whereas casual riders use the service more for pleasure. For casual riders, although Saturday and Sunday boast the highest average daily ride volume, weekdays should not be discounted as having low ridership.  For casual riders, weekdays collectively comprise 63% of their total rides. 

<img width="85%" alt="Ride Distro by Day of Week" src="https://github.com/user-attachments/assets/73aa6ae8-eb60-48f9-a14b-19f40143b0e3" />

### Ride Distribution by Hour of Day

Both rider types use the service most in the late afternoon, peaking during the early evening hours. However, the annual members differ from the casual riders in that they have two peaks in the day, which correspond to both a.m. and p.m. rush hours.
**Insights:** annual members have two peak usage times a day that correspond with traditional rush hours, indicating annual members mostly use the bikes for commuting. Casual riders do not appear to use the bikes as much for commuting to/from work, as evidenced by very low usage during the morning commute hours.

<img width="90%" alt="Ride Distro by Hour of Day" src="https://github.com/user-attachments/assets/38e7d20c-e2c0-4ff3-936a-a33986b876a6" />

### Average Ride Distance & Duration

The average distance per ride for annual members and casual riders was 2,209 meters and 2,173 respectively -- so they are very close in this regard. However, the average distance travelled in that time by annual members was nearly double that of casual riders. **Insights:** during an average per ride, casual riders cover approximately half the ground that annual members do.  The story this tells is that annual members use the bikes more efficiently, which corresponds to using the service more for transporation. Casual riders on the other hand, don't cover nearly as much ground during their average rides. They appear to ride slower or stop more frequently, indicating they are more likely using the bikes for pleasure and sightseeing.

<img width="80%" alt="Duration   Distance (4)" src="https://github.com/user-attachments/assets/e848d83b-bbe4-4eb4-bf40-63cc265d9c5d" />


### Start and End Locations, Routes

The top 10 start and end locations for annual members are in more urban areas including commercial areas and urban neighborhoods. Not surprisingly, the most popular hub for annual members is Chicago Union Station. The top 10 start and end locations for casual riders however, are closer to the waterfront and adjacent to popular attractions. Also not surprisingly, the most popular hub for casual riders is Navy Pier.  **Insight** This was perhaps the most surprising and telling information revealed in this analysis.  This more than any other data underscores the narrative that annual members use the bikes for transportation while casual riders use the bikes mostly for pleasure and sightseeing.

<img width="80%" alt="Locations   Routes (1)" src="https://github.com/user-attachments/assets/24371cc8-1ad3-44d5-9031-0d41379250e2" />


### Percent of Rides by Rideable Type

Annual members and Casual riders have a very similar breakdown of rideable_type usage. For both groups, 50% of their rides were on electric bikes, about 2-4% on electric scooters, and about 46-48% on classic bikes. **Insights:** although not unique to casual riders, it is important for marketing content to note that casual riders have a roughly equal preference for ebikes vs. manual bikes. Also important to note is that electric scooters only make up only about 4% of the usage for casual riders, so probably no need to feature scooters in marketing content.

<img width="80%" alt="Percent of Rides by Rideable Type" src="https://github.com/user-attachments/assets/79e30f21-a05c-4d74-95d0-67dd965d5ac0" />

### Recommendations
1. Time Targeting: if able to target marketing to casual users based on time, I would recommend targeting them 7 days a week May through mid-October.  If you can target time of day, I would recommend 7:00am through about 4:00pm.
2. Location Targeting: I recommend targeting hotels and attractions closest to the waterfront.
3. Marketing message/strategy: the goal here is to obviously increase repeat use such that it makes more sense financially to become a member. Casual riders are mostly using the service mostly for leisure activities and sighseeing on weekends. The best strategy may not be to try and convert them to commuters, but rather to encourage/incentivize them to see more sights and have even more see more sights in Chicago on additional days of the year. Key imagery will be the waterfront and a variety of the top attractions proximate to the waterfront.
4. Deeper insights will enable better marketing.  If we had deeper insights into which riders were associated with which rides, we could then customize our marketing strategy and incentives based on segments.  For example:
 * If we could determine which riders bought enough day passes that they would have saved money by buying an annual pass, we could market to them accordingly.
 * If we knew which casual riders exhibited behavior that closely aligned with member behavior, we could market to them accordingly.
 * If we knew which attractions casual riders have and have not been to, we could market to them accordingly.
5. Partnering with attractions to bundle offerings seems like an obvious strategy here. For example, if Cyclistic were able to offer discounts to key attractions that visitors would likely see over the course of multiple days, they could create Cyclistic membership bundles around that.
6. Partner with hotels. Based on the touristy activity of casual riders, hotels are likely where many casual riders make a decision to seek out Cyclistic. Perhaps the aforementioned packages and incentives, along with positive reviews, can be promoted by local hotels who want their guests to have a great time in Chicago.
