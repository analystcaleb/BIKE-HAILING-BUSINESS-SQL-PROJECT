# BIKE-HAILING-BUSINESS-SQL-PROJECT
SQL Queries

I started by creating an SQL script that sets up the local environment by creating a new database called BIKEHAILINGBUSINESS and dropping any existing bike_trips table to avoid conflicts.
It then defines the structure of a new bike_trips table with specified column data types like integers, varchar, and varying character fields.
Finally, it uses the BULK INSERT command to quickly populate the table with raw data imported from a local CSV file called bikelogistics.csv, skipping the header row.
SQL Script:
CREATE DATABASE BIKEHAILINGBUSINESS;
GO
USE BIKEHAILINGBUSINESS;
DROP TABLE bike_trips;
GO
CREATE TABLE bike_trips (
    trip_id INTEGER PRIMARY KEY,
    subscriber_type VARCHAR(255) NULL,
    bikeid VARCHAR(255) NULL,
    start_time DATE NULL,
    start_station_id INTEGER NULL,
    start_station_name VARCHAR(255) NULL,
    end_station_id VARCHAR(255) NULL,
    end_station_name VARCHAR(255) NULL,
    duration_minutes INTEGER NULL
);
GO
BULK INSERT bike_trips
FROM 'C:\Users\USER\Documents\TechCrushCohort 7\CLASS RESOURCES\bikelogistics.csv '
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO
 
After successfully running the above script and getting my data ready, I move on to querying the data.
I carried out my analysis using these rules.
•	Excluded rows where end_station_name = 'Missing' or 'Stolen'
•	Excluded trips where start_station_name = end_station_name

QUESTION 1: On which day of the week do we on average have the longest trip?
This SQL query finds the day of the week with the highest average trip duration for bike rides.
It filters out trips where the end station is marked as 'Missing' or 'Stolen', as well as round trips where the start and end stations are the same.
Finally, it groups the data by weekday, calculates the average duration rounded to two decimal places, and returns only the top result.

SQL Query:
SELECT TOP 1 
    DATENAME(dw, start_time) AS DayOfWeek,
    CAST(AVG(duration_minutes * 1.0) AS decimal(12,2) ) AS AvgDuration
FROM bike_trips
WHERE end_station_name NOT IN ('Missing', 'Stolen')
  AND start_station_name <> end_station_name
GROUP BY DATENAME(dw, start_time)
ORDER BY AvgDuration DESC;
GO
 
Result: Sunday has the longest average trip duration (79.91 minutes).


QUESTION 2: What month/year has the most bike trips and what is the count of the trips?
This SQL query identifies the single busiest month and year by calculating the highest total number of bike rides.
It excludes invalid data by filtering out trips ending at 'Missing' or 'Stolen' stations, as well as round trips that start and end at the exact same location.
The results are grouped by year and month, sorted in descending order by the total trip count, and limited to return only the top record.
SQL Query:
SELECT TOP 1 
    YEAR(start_time) AS TripYear,
    DATENAME(month, start_time) AS TripMonth,
    COUNT(*) AS TotalTrips
FROM bike_trips
WHERE end_station_name NOT IN ('Missing', 'Stolen')
  AND start_station_name <> end_station_name
GROUP BY YEAR(start_time), DATENAME(month, start_time), MONTH(start_time)
ORDER BY TotalTrips DESC;
GO
 
Result: September 2020 recorded the highest number of trips (248 trips). 


QUESTION 3: Return the trip with the longest duration and the trip with the shortest duration
This SQL query uses two Common Table Expressions (CTEs) to find the single longest trip and the single shortest trip from valid bike data.
Both sections exclude invalid 'Missing' or 'Stolen' stations and round trips, sorting by duration (DESC for longest, ASC for shortest) to isolate each record.
Finally, a UNION ALL operator combines these two distinct results into a single output table showing both extreme trips together.
SQL Query:
(
    SELECT *
    FROM bikelogistics
    WHERE end_station_name NOT IN ('Missing', 'Stolen')
      AND start_station_name <> end_station_name
      AND duration_minutes =
      (
          SELECT MAX(duration_minutes)
          FROM bikelogistics
          WHERE end_station_name NOT IN ('Missing', 'Stolen')
            AND start_station_name <> end_station_name
      )
    ORDER BY start_time
    LIMIT 1
)

UNION ALL

(
    SELECT *
    FROM bikelogistics
    WHERE end_station_name NOT IN ('Missing', 'Stolen')
      AND start_station_name <> end_station_name
      AND duration_minutes =
      (
          SELECT MIN(duration_minutes)
          FROM bikelogistics
          WHERE end_station_name NOT IN ('Missing', 'Stolen')
            AND start_station_name <> end_station_name
      )
    ORDER BY start_time
    LIMIT 1
);

Result:
•	Longest trip duration: 11,810 minutes (Trip ID 21577822)
•	Shortest trip duration: 2 minutes (Trip ID 21473408)
