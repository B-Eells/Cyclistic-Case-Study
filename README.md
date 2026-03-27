# Google Data Analytics Professional Certificate: Cyclistic Bike Share Case Study

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

| Field name | Type | Mode | Description
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

