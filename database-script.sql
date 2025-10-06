-- SQL Script to Create the Wearable Health Device Data Hub Database and Tables

-- 1. Create the Database
-- This command creates a new database named 'WearableHealthDB'.
-- IF NOT EXISTS is used to prevent an error if the database already exists.
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'WearableHealthDB')
BEGIN
    CREATE DATABASE WearableHealthDB;
END;
GO

-- 2. Use the newly created database
-- This command sets the context to 'WearableHealthDB' so subsequent commands
-- operate within this database.
USE WearableHealthDB;
GO

-- 3. Create Tables

-- Table: [User]
-- Stores information about the users of the wearable health devices.
-- UserID: Primary Key, auto-incrementing integer.
-- FirstName: User's first name.
-- LastName: User's last name.
-- Age: User's age.
-- Email: User's email, must be unique.
-- Gender: User's gender.
-- RegistrationDate: Date when the user registered.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' and xtype='U')
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(255) NOT NULL,
    LastName NVARCHAR(255) NOT NULL,
    Age INT,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    Gender NVARCHAR(10),
    RegistrationDate DATE NOT NULL
);
GO

-- Table: Device
-- Stores information about the wearable health devices.
-- DeviceID: Primary Key, auto-incrementing integer.
-- Model: The model name of the device.
-- DeviceName: A user-friendly name for the device (e.g., "My Smartwatch").
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Device' and xtype='U')
CREATE TABLE Device (
    DeviceID INT IDENTITY(1,1) PRIMARY KEY,
    Model NVARCHAR(255) NOT NULL,
    DeviceName NVARCHAR(255) NOT NULL
);
GO

-- Table: HealthMetric
-- Defines different types of health metrics that can be tracked.
-- MetricID: Primary Key, auto-incrementing integer.
-- Unit: The unit of measurement for the metric (e.g., "bpm", "steps", "hours").
-- MetricName: The name of the health metric (e.g., "Heart Rate", "Steps Count", "Sleep Duration").
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HealthMetric' and xtype='U')
CREATE TABLE HealthMetric (
    MetricID INT IDENTITY(1,1) PRIMARY KEY,
    Unit NVARCHAR(50) NOT NULL,
    MetricName NVARCHAR(255) UNIQUE NOT NULL
);
GO

-- Table: HealthData
-- Stores the actual health data collected from devices for users.
-- DataID: Primary Key, auto-incrementing integer.
-- Value: The recorded value for the health metric.
-- Timestamp: The date and time when the data was recorded.
-- UserID: Foreign Key referencing the Users table, indicating which user the data belongs to.
-- MetricID: Foreign Key referencing the HealthMetric table, indicating the type of metric.
-- DeviceID: Foreign Key referencing the Device table, indicating which device collected the data.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HealthData' and xtype='U')
CREATE TABLE HealthData (
    DataID INT IDENTITY(1,1) PRIMARY KEY,
    Value DECIMAL(10, 2) NOT NULL,
    Timestamp DATETIME NOT NULL,
    UserID INT NOT NULL,
    MetricID INT NOT NULL,
    DeviceID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (MetricID) REFERENCES HealthMetric(MetricID) ON DELETE CASCADE,
    FOREIGN KEY (DeviceID) REFERENCES Device(DeviceID) ON DELETE CASCADE
);
GO

-- Table: Recommendation
-- Stores personalized health recommendations for users.
-- RecommendationID: Primary Key, auto-incrementing integer.
-- Description: Detailed description of the recommendation.
-- Title: A short title for the recommendation.
-- UserID: Foreign Key referencing the Users table, indicating which user the recommendation is for.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Recommendation' and xtype='U')
CREATE TABLE Recommendation (
    RecommendationID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- 4. Populate Tables with Sample Data (at least 20 entries per table)

-- Insert data into Users table
INSERT INTO Users (FirstName, LastName, Age, Email, Gender, RegistrationDate) VALUES
('Alice', 'Smith', 30, 'alice.smith@example.com', 'Female', '2023-01-15'),
('Bob', 'Johnson', 45, 'bob.j@example.com', 'Male', '2023-01-20'),
('Charlie', 'Brown', 22, 'charlie.b@example.com', 'Male', '2023-02-01'),
('Diana', 'Prince', 35, 'diana.p@example.com', 'Female', '2023-02-10'),
('Eve', 'Adams', 28, 'eve.a@example.com', 'Female', '2023-03-05'),
('Frank', 'White', 50, 'frank.w@example.com', 'Male', '2023-03-12'),
('Grace', 'Lee', 25, 'grace.l@example.com', 'Female', '2023-04-01'),
('Henry', 'Green', 40, 'henry.g@example.com', 'Male', '2023-04-18'),
('Ivy', 'King', 33, 'ivy.k@example.com', 'Female', '2023-05-01'),
('Jack', 'Black', 55, 'jack.b@example.com', 'Male', '2023-05-20'),
('Karen', 'Hall', 29, 'karen.h@example.com', 'Female', '2023-06-01'),
('Liam', 'Scott', 38, 'liam.s@example.com', 'Male', '2023-06-15'),
('Mia', 'Taylor', 26, 'mia.t@example.com', 'Female', '2023-07-01'),
('Noah', 'Clark', 42, 'noah.c@example.com', 'Male', '2023-07-10'),
('Olivia', 'Lewis', 31, 'olivia.l@example.com', 'Female', '2023-08-01'),
('Peter', 'Walker', 48, 'peter.w@example.com', 'Male', '2023-08-18'),
('Quinn', 'Young', 24, 'quinn.y@example.com', 'Female', '2023-09-01'),
('Ryan', 'Hill', 36, 'ryan.h@example.com', 'Male', '2023-09-10'),
('Sophia', 'Baker', 27, 'sophia.b@example.com', 'Female', '2023-10-01'),
('Tom', 'Harris', 52, 'tom.h@example.com', 'Male', '2023-10-15'),
('Ursula', 'Davis', 39, 'ursula.d@example.com', 'Female', '2023-11-01'),
('Victor', 'Miller', 41, 'victor.m@example.com', 'Male', '2023-11-10');
GO

-- Insert data into Device table
INSERT INTO Device (Model, DeviceName) VALUES
('FitBit Charge 5', 'Alice''s FitBit'),
('Apple Watch Series 8', 'Bob''s Apple Watch'),
('Garmin Forerunner 955', 'Charlie''s Garmin'),
('Samsung Galaxy Watch 5', 'Diana''s Galaxy Watch'),
('Whoop 4.0', 'Eve''s Whoop'),
('FitBit Sense 2', 'Frank''s FitBit'),
('Apple Watch SE', 'Grace''s Apple Watch'),
('Garmin Fenix 7', 'Henry''s Garmin'),
('Oura Ring Gen3', 'Ivy''s Oura Ring'),
('FitBit Versa 4', 'Jack''s FitBit'),
('Polar Vantage V2', 'Karen''s Polar Watch'),
('Xiaomi Mi Band 7', 'Liam''s Mi Band'),
('Huawei Watch GT 3', 'Mia''s Huawei Watch'),
('Google Pixel Watch', 'Noah''s Pixel Watch'),
('Withings ScanWatch', 'Olivia''s ScanWatch'),
('FitBit Inspire 3', 'Peter''s FitBit'),
('Apple Watch Ultra', 'Quinn''s Apple Watch Ultra'),
('Garmin Venu 2 Plus', 'Ryan''s Garmin Venu'),
('Samsung Galaxy Watch 6', 'Sophia''s Galaxy Watch'),
('Whoop 4.0', 'Tom''s Whoop'),
('FitBit Charge 5', 'Ursula''s FitBit'),
('Apple Watch Series 8', 'Victor''s Apple Watch');
GO

-- Insert data into HealthMetric table
INSERT INTO HealthMetric (Unit, MetricName) VALUES
('bpm', 'Heart Rate'),
('steps', 'Steps Count'),
('hours', 'Sleep Duration'),
('kcal', 'Calories Burned'),
('km', 'Distance Walked/Run'),
('minutes', 'Active Minutes'),
('g/dL', 'Blood Glucose'),
('mmHg', 'Blood Pressure (Systolic)'),
('mmHg', 'Blood Pressure (Diastolic)'),
('%', 'SpO2 Level'),
('mg/dL', 'Cholesterol'),
('kg', 'Weight'),
('cm', 'Height'),
('score', 'Stress Level'),
('score', 'Recovery Score'),
('breaths/min', 'Respiratory Rate'),
('count', 'Workouts Completed'),
('count', 'Water Intake (glasses)'),
('count', 'Stairs Climbed'),
('score', 'Mindfulness Minutes');
GO

-- Insert data into HealthData table (linking Users, Metrics, and Devices)
-- This will generate 20+ entries by combining various users, devices, and metrics.
INSERT INTO HealthData (Value, Timestamp, UserID, MetricID, DeviceID) VALUES
(75.5, '2024-07-20 08:00:00', 1, 1, 1), -- Alice, Heart Rate, FitBit Charge 5
(10245.0, '2024-07-20 18:30:00', 1, 2, 1), -- Alice, Steps Count, FitBit Charge 5
(7.2, '2024-07-20 07:00:00', 1, 3, 1), -- Alice, Sleep Duration, FitBit Charge 5
(1500.0, '2024-07-20 20:00:00', 1, 4, 1), -- Alice, Calories Burned, FitBit Charge 5
(68.0, '2024-07-20 09:00:00', 2, 1, 2), -- Bob, Heart Rate, Apple Watch Series 8
(8500.0, '2024-07-20 17:00:00', 2, 2, 2), -- Bob, Steps Count, Apple Watch Series 8
(6.8, '2024-07-20 06:30:00', 2, 3, 2), -- Bob, Sleep Duration, Apple Watch Series 8
(1800.0, '2024-07-20 19:00:00', 2, 4, 2), -- Bob, Calories Burned, Apple Watch Series 8
(120.0, '2024-07-20 10:00:00', 3, 8, 3), -- Charlie, Blood Pressure (Systolic), Garmin Forerunner 955
(80.0, '2024-07-20 10:00:00', 3, 9, 3), -- Charlie, Blood Pressure (Diastolic), Garmin Forerunner 955
(98.5, '2024-07-20 11:00:00', 4, 10, 4), -- Diana, SpO2 Level, Samsung Galaxy Watch 5
(5.1, '2024-07-20 12:00:00', 5, 7, 5), -- Eve, Blood Glucose, Whoop 4.0
(70.0, '2024-07-20 13:00:00', 6, 1, 6), -- Frank, Heart Rate, FitBit Sense 2
(11000.0, '2024-07-20 16:00:00', 7, 2, 7), -- Grace, Steps Count, Apple Watch SE
(7.5, '2024-07-20 07:30:00', 8, 3, 8), -- Henry, Sleep Duration, Garmin Fenix 7
(65.0, '2024-07-20 08:15:00', 9, 1, 9), -- Ivy, Heart Rate, Oura Ring Gen3
(9000.0, '2024-07-20 17:45:00', 10, 2, 10), -- Jack, Steps Count, FitBit Versa 4
(6.9, '2024-07-20 06:45:00', 11, 3, 11), -- Karen, Sleep Duration, Polar Vantage V2
(1600.0, '2024-07-20 21:00:00', 12, 4, 12), -- Liam, Calories Burned, Xiaomi Mi Band 7
(72.0, '2024-07-20 09:30:00', 13, 1, 13), -- Mia, Heart Rate, Huawei Watch GT 3
(9500.0, '2024-07-20 18:00:00', 14, 2, 14), -- Noah, Steps Count, Google Pixel Watch
(7.0, '2024-07-20 07:15:00', 15, 3, 15), -- Olivia, Sleep Duration, Withings ScanWatch
(140.0, '2024-07-20 10:30:00', 16, 8, 16), -- Peter, Blood Pressure (Systolic), FitBit Inspire 3
(85.0, '2024-07-20 10:30:00', 17, 9, 17), -- Quinn, Blood Pressure (Diastolic), Apple Watch Ultra
(99.0, '2024-07-20 11:30:00', 18, 10, 18), -- Ryan, SpO2 Level, Garmin Venu 2 Plus
(5.5, '2024-07-20 12:30:00', 19, 7, 19), -- Sophia, Blood Glucose, Samsung Galaxy Watch 6
(68.0, '2024-07-20 13:30:00', 20, 1, 20), -- Tom, Heart Rate, Whoop 4.0
(10500.0, '2024-07-20 19:00:00', 21, 2, 21), -- Ursula, Steps Count, FitBit Charge 5
(7.1, '2024-07-20 06:50:00', 22, 3, 22); -- Victor, Sleep Duration, Apple Watch Series 8
GO

-- Insert data into Recommendation table
INSERT INTO Recommendation (Title, Description, UserID) VALUES
('Increase Daily Steps', 'Aim for 10,000 steps daily. Try taking a brisk 30-minute walk during lunch.', 1),
('Improve Sleep Hygiene', 'Establish a consistent sleep schedule, avoid screens before bed, and create a relaxing bedtime routine.', 2),
('Monitor Blood Pressure', 'Continue tracking your blood pressure regularly. Consult your doctor if readings are consistently high.', 3),
('Maintain SpO2 Levels', 'Your oxygen saturation is excellent. Keep up with your regular physical activity.', 4),
('Manage Blood Glucose', 'Continue to monitor your blood glucose levels. Focus on a balanced diet with low glycemic index foods.', 5),
('Regular Cardio Exercise', 'Incorporate at least 30 minutes of moderate-intensity cardio most days of the week to maintain heart health.', 6),
('Hydration Goal', 'Drink at least 8 glasses of water daily. Use a water tracking app to help you stay on track.', 7),
('Strength Training', 'Add 2-3 days of strength training to your weekly routine to build muscle and improve metabolism.', 8),
('Mindfulness Practice', 'Practice 10 minutes of mindfulness meditation daily to help reduce stress and improve focus.', 9),
('Nutritional Review', 'Consider consulting a nutritionist to optimize your diet for sustained energy and overall well-being.', 10),
('Active Recovery', 'Incorporate light activities like stretching or yoga on rest days to aid muscle recovery and flexibility.', 11),
('Set Realistic Goals', 'Break down your fitness goals into smaller, achievable steps to maintain motivation.', 12),
('Vary Your Workouts', 'Introduce different types of exercises (e.g., swimming, cycling) to challenge your body in new ways.', 13),
('Listen to Your Body', 'Pay attention to signs of fatigue or overtraining. Rest is just as important as activity.', 14),
('Stay Consistent', 'Consistency is key to long-term health improvements. Try to stick to your routine even on busy days.', 15),
('Explore New Trails', 'If you enjoy walking/running, try exploring new parks or trails to keep your routine fresh.', 16),
('Track Food Intake', 'Logging your food can help you identify patterns and make healthier choices.', 17),
('Join a Fitness Class', 'Consider joining a group fitness class for motivation and to learn new exercises.', 18),
('Prioritize Rest', 'Ensure you are getting adequate rest, especially after intense workouts, to allow your body to recover.', 19),
('Morning Routine', 'Start your day with a short walk or light stretching to boost energy and mood.', 20),
('Evening Wind-Down', 'Create a relaxing evening routine to prepare your body for restful sleep.', 21),
('Stay Hydrated', 'Keep a water bottle handy throughout the day to ensure consistent hydration.', 22);
GO

-- Simple Data Retrieval
SELECT * FROM Users;

-- Filtering Data with WHERE Clause
SELECT * FROM HealthData WHERE UserID = 1;

--Joining tables to get User Health Metrics
SELECT 
    u.FirstName,
    u.LastName,
    hm.MetricName,
    hd.Value,
    hd.Timestamp
FROM 
    HealthData hd
JOIN 
    Users u ON hd.UserID = u.UserID
JOIN 
    HealthMetric hm ON hd.MetricID = hm.MetricID;

--Counting Entries with GROUP BY
SELECT 
    u.FirstName,
    u.LastName,
    COUNT(hd.DataID) AS NumberOfReadings
FROM 
    HealthData hd
JOIN 
    Users u ON hd.UserID = u.UserID
GROUP BY 
    u.FirstName, u.LastName
ORDER BY 
    NumberOfReadings DESC;

    --Finding the Maximum Value with MAX()
SELECT 
    MAX(Value) AS MaxStepsCount
FROM 
    HealthData
WHERE 
    MetricID = (SELECT MetricID FROM HealthMetric WHERE MetricName = 'Steps Count');

-- Retrieving All Recommendations for a Specific User
SELECT 
    r.Title,
    r.Description
FROM 
    Recommendation r
JOIN 
    Users u ON r.UserID = u.UserID
WHERE 
    u.FirstName = 'Alice' AND u.LastName = 'Smith';

-- COunting device Models
SELECT
    d.Model,
    COUNT(hd.DataID) AS TotalReadings
FROM 
    HealthData hd
JOIN 
    Device d ON hd.DeviceID = d.DeviceID
GROUP BY 
    d.Model
ORDER BY 
    TotalReadings DESC;

-- Finding all users within a specific age range
SELECT 
    FirstName,
    LastName,
    Age
FROM 
    Users
WHERE 
    Age BETWEEN 30 AND 40
ORDER BY 
    Age;

--This query calculates the average heart rate for each user. 
--It uses a WHERE clause to filter for the 'Heart Rate' metric, then GROUP BY to group by user.
SELECT 
    u.FirstName,
    u.LastName,
    AVG(hd.Value) AS AverageHeartRate
FROM 
    HealthData hd
JOIN 
    Users u ON hd.UserID = u.UserID
JOIN 
    HealthMetric hm ON hd.MetricID = hm.MetricID
WHERE 
    hm.MetricName = 'Heart Rate'
GROUP BY 
    u.FirstName, u.LastName
HAVING 
    AVG(hd.Value) > 70;

-- Find All Health Metrics for 'Alice Smith'
SELECT
    hm.MetricName,
    hd.Value,
    hd.Timestamp
FROM
    HealthData hd
JOIN
    Users u ON hd.UserID = u.UserID
JOIN
    HealthMetric hm ON hd.MetricID = hm.MetricID
WHERE
    u.FirstName = 'Alice' AND u.LastName = 'Smith'
ORDER BY
    hd.Timestamp DESC;

-- List All Users and the Devices They Use
SELECT
    u.FirstName,
    u.LastName,
    d.Model AS DeviceModel,
    d.DeviceName
FROM
    HealthData hd
JOIN
    Users u ON hd.UserID = u.UserID
JOIN
    Device d ON hd.DeviceID = d.DeviceID
GROUP BY
    u.FirstName, u.LastName, d.Model, d.DeviceName;

-- Show the 5 Most Recent Health Readings
SELECT TOP 5
    u.FirstName,
    u.LastName,
    hm.MetricName,
    hd.Value,
    hd.Timestamp
FROM
    HealthData hd
JOIN
    Users u ON hd.UserID = u.UserID
JOIN
    HealthMetric hm ON hd.MetricID = hm.MetricID
ORDER BY
    hd.Timestamp DESC;

 --Count Users by Gender
 SELECT
    Gender,
    COUNT(UserID) AS NumberOfUsers
FROM
    Users
GROUP BY
    Gender;

--Find the Average Value for Heart Rate
SELECT
    AVG(Value) AS AverageHeartRate
FROM
    HealthData
WHERE
    MetricID = (SELECT MetricID FROM HealthMetric WHERE MetricName = 'Heart Rate');