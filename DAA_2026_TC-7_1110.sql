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
FROM 'C:\Users\USER\Documents\TechCrush Cohort 7\CLASS RESOURCES\bikelogistics.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

------- On which day of the week do we on average have the longest trip?
SELECT TOP 1 
    DATENAME(dw, start_time) AS DayOfWeek,
    CAST(AVG(duration_minutes * 1.0) AS decimal(12,2) ) AS AvgDuration
FROM bike_trips
WHERE end_station_name NOT IN ('Missing', 'Stolen')
  AND start_station_name <> end_station_name
GROUP BY DATENAME(dw, start_time)
ORDER BY AvgDuration DESC;
GO

-------- What month/year has the most bike trips and what is the count of the trips?
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

--------- In the same table, return the particular trip that has longest duration and the trip that has 
---------the shortest duration (return all the information(columns) on the table for this record.
WITH LongestTrip AS (
    SELECT TOP 1 *
    FROM bike_trips
    WHERE end_station_name NOT IN ('Missing', 'Stolen')
      AND start_station_name <> end_station_name
    ORDER BY duration_minutes DESC, start_time ASC
),
ShortestTrip AS (
    SELECT TOP 1 *
    FROM bike_trips
    WHERE end_station_name NOT IN ('Missing', 'Stolen')
      AND start_station_name <> end_station_name
    ORDER BY duration_minutes ASC, start_time ASC
)
SELECT * FROM LongestTrip
UNION ALL
SELECT * FROM ShortestTrip;
GO




SELECT COUNT(*) AS TotalRows FROM bike_trips;