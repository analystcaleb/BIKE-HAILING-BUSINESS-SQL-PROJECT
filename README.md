# BIKE-HAILING-BUSINESS-SQL-PROJECT
SQL Queries

I started by creating an SQL script that sets up the local environment by creating a new database called BIKEHAILINGBUSINESS and dropping any existing bike_trips table to avoid conflicts.
It then defines the structure of a new bike_trips table with specified column data types like integers, varchar, and varying character fields.
Finally, it uses the BULK INSERT command to quickly populate the table with raw data imported from a local CSV file called bikelogistics.csv, skipping the header row.

After successfully running the above script and getting my data ready, I move on to querying the data.
I carried out my analysis using these rules.
•	Excluded rows where end_station_name = 'Missing' or 'Stolen'
•	Excluded trips where start_station_name = end_station_name

QUESTION 1: On which day of the week do we on average have the longest trip?
This SQL query finds the day of the week with the highest average trip duration for bike rides.
It filters out trips where the end station is marked as 'Missing' or 'Stolen', as well as round trips where the start and end stations are the same.
Finally, it groups the data by weekday, calculates the average duration rounded to two decimal places, and returns only the top result.


QUESTION 2: What month/year has the most bike trips and what is the count of the trips?
This SQL query identifies the single busiest month and year by calculating the highest total number of bike rides.
It excludes invalid data by filtering out trips ending at 'Missing' or 'Stolen' stations, as well as round trips that start and end at the exact same location.
The results are grouped by year and month, sorted in descending order by the total trip count, and limited to return only the top record.

QUESTION 3: Return the trip with the longest duration and the trip with the shortest duration
This SQL query uses two Common Table Expressions (CTEs) to find the single longest trip and the single shortest trip from valid bike data.
Both sections exclude invalid 'Missing' or 'Stolen' stations and round trips, sorting by duration (DESC for longest, ASC for shortest) to isolate each record.
Finally, a UNION ALL operator combines these two distinct results into a single output table showing both extreme trips together.
