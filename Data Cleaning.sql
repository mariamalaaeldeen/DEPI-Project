create database Final_Project

select * from EducationLevel 
select * from Employee
select * from PerformanceRating
select * from RatingLevel
select * from SatisfiedLevel

---cleaning by check the null
SELECT 
    SUM(CASE WHEN EmployeeID IS NULL THEN 1 ELSE 0 END) AS Null_EmployeeID,
    SUM(CASE WHEN FirstName IS NULL THEN 1 ELSE 0 END) AS Null_FirstName,
    SUM(CASE WHEN LastName IS NULL THEN 1 ELSE 0 END) AS Null_LastName,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN BusinessTravel IS NULL THEN 1 ELSE 0 END) AS Null_BusinessTravel,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Null_Department,
    SUM(CASE WHEN DistanceFromHome_KM IS NULL THEN 1 ELSE 0 END) AS Null_DistanceFromHome,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN Ethnicity IS NULL THEN 1 ELSE 0 END) AS Null_Ethnicity,
    SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS Null_Education,
    SUM(CASE WHEN EducationField IS NULL THEN 1 ELSE 0 END) AS Null_EducationField,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS Null_JobRole,
    SUM(CASE WHEN MaritalStatus IS NULL THEN 1 ELSE 0 END) AS Null_MaritalStatus,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS Null_Salary,
    SUM(CASE WHEN StockOptionLevel IS NULL THEN 1 ELSE 0 END) AS Null_StockOptionLevel,
    SUM(CASE WHEN OverTime IS NULL THEN 1 ELSE 0 END) AS Null_OverTime,
    SUM(CASE WHEN HireDate IS NULL THEN 1 ELSE 0 END) AS Null_HireDate,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS Null_Attrition,
    SUM(CASE WHEN YearsAtCompany IS NULL THEN 1 ELSE 0 END) AS Null_YearsAtCompany,
    SUM(CASE WHEN YearsInMostRecentRole IS NULL THEN 1 ELSE 0 END) AS Null_YearsInMostRecentRole,
    SUM(CASE WHEN YearsSinceLastPromotion IS NULL THEN 1 ELSE 0 END) AS Null_YearsSinceLastPromotion,
    SUM(CASE WHEN YearsWithCurrManager IS NULL THEN 1 ELSE 0 END) AS Null_YearsWithCurrManager
FROM Employee;

SELECT 
    SUM(CASE WHEN EducationLevelID IS NULL THEN 1 ELSE 0 END) AS Null_EducationLevelID,
    SUM(CASE WHEN EducationLevel IS NULL THEN 1 ELSE 0 END) AS Null_EducationLevel
FROM EducationLevel;

SELECT 
    SUM(CASE WHEN PerformanceID IS NULL THEN 1 ELSE 0 END) AS Null_PerformanceID,
    SUM(CASE WHEN EmployeeID IS NULL THEN 1 ELSE 0 END) AS Null_EmployeeID,
    SUM(CASE WHEN ReviewDate IS NULL THEN 1 ELSE 0 END) AS Null_ReviewDate,
    SUM(CASE WHEN EnvironmentSatisfaction IS NULL THEN 1 ELSE 0 END) AS Null_EnvironmentSatisfaction,
    SUM(CASE WHEN JobSatisfaction IS NULL THEN 1 ELSE 0 END) AS Null_JobSatisfaction,
    SUM(CASE WHEN RelationshipSatisfaction IS NULL THEN 1 ELSE 0 END) AS Null_RelationshipSatisfaction,
    SUM(CASE WHEN TrainingOpportunitiesWithinYear IS NULL THEN 1 ELSE 0 END) AS Null_TrainingOpportunitiesWithinYear,
    SUM(CASE WHEN TrainingOpportunitiesTaken IS NULL THEN 1 ELSE 0 END) AS Null_TrainingOpportunitiesTaken,
    SUM(CASE WHEN WorkLifeBalance IS NULL THEN 1 ELSE 0 END) AS Null_WorkLifeBalance,
    SUM(CASE WHEN SelfRating IS NULL THEN 1 ELSE 0 END) AS Null_SelfRating,
    SUM(CASE WHEN ManagerRating IS NULL THEN 1 ELSE 0 END) AS Null_ManagerRating
FROM PerformanceRating;

SELECT 
    SUM(CASE WHEN RatingID IS NULL THEN 1 ELSE 0 END) AS Null_RatingID,
    SUM(CASE WHEN RatingLevel IS NULL THEN 1 ELSE 0 END) AS Null_RatingLevel
FROM RatingLevel;

SELECT 
    SUM(CASE WHEN SatisfactionID IS NULL THEN 1 ELSE 0 END) AS Null_SatisfactionID,
    SUM(CASE WHEN SatisfactionLevel IS NULL THEN 1 ELSE 0 END) AS Null_SatisfactionLevel
FROM SatisfiedLevel;

--cleaning by check duplication

SELECT EmployeeID, COUNT(*) AS CountDup
FROM Employee
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

SELECT EducationLevelID, COUNT(*) AS CountDup
FROM EducationLevel
GROUP BY EducationLevelID
HAVING COUNT(*) > 1;

SELECT PerformanceID, COUNT(*) AS CountDup
FROM PerformanceRating
GROUP BY PerformanceID
HAVING COUNT(*) > 1;

SELECT EmployeeID, ReviewDate, COUNT(*) AS CountDup
FROM PerformanceRating
GROUP BY EmployeeID, ReviewDate
HAVING COUNT(*) > 1;

SELECT RatingID, COUNT(*) AS CountDup
FROM RatingLevel
GROUP BY RatingID
HAVING COUNT(*) > 1;

SELECT SatisfactionID, COUNT(*) AS CountDup
FROM SatisfiedLevel
GROUP BY SatisfactionID
HAVING COUNT(*) > 1;

--cleaning by check the Data Types & Ranges

--Checking for Logical Employee Ages
SELECT * 
FROM Employee
WHERE Age < 15 OR Age > 100;

--Checking Salary Ranges
SELECT MIN(Salary) AS MinSalary, MAX(Salary) AS MaxSalary,AVG(Salary) as avgsalary
FROM Employee;


--checking Logical DistanceFromHome
SELECT * 
FROM Employee
WHERE DistanceFromHome_KM < 0;

--checking Logical Years 
SELECT * 
FROM Employee
WHERE YearsAtCompany < 0
   OR YearsInMostRecentRole < 0
   OR YearsSinceLastPromotion < 0
   OR YearsWithCurrManager < 0;

--Checking for Hire Dates in the Future
SELECT * 
FROM Employee
WHERE HireDate > GETDATE();

--Distinct Text Values Check
SELECT DISTINCT Gender FROM Employee;
SELECT DISTINCT BusinessTravel FROM Employee;
SELECT DISTINCT Department FROM Employee;
SELECT DISTINCT EducationField FROM Employee;
SELECT DISTINCT JobRole FROM Employee;
SELECT DISTINCT MaritalStatus FROM Employee;
SELECT DISTINCT State FROM Employee;

-- Performance Rating Range Check
SELECT * 
FROM PerformanceRating
WHERE EnvironmentSatisfaction NOT BETWEEN 1 AND 5
   OR JobSatisfaction NOT BETWEEN 1 AND 5
   OR RelationshipSatisfaction NOT BETWEEN 1 AND 5
   OR WorkLifeBalance NOT BETWEEN 1 AND 5
   OR SelfRating NOT BETWEEN 1 AND 5
   OR ManagerRating NOT BETWEEN 1 AND 5;

--Check for Performance Evaluation Dates Set in the Future
SELECT * 
FROM PerformanceRating
WHERE ReviewDate > GETDATE();


-- Check EducationLevel IDs for Logical Values (No Negatives)
SELECT * 
FROM EducationLevel
WHERE EducationLevelID < 0;

--Check for Unique Text Values
SELECT DISTINCT EducationLevel FROM EducationLevel;

--Check for Logical RatingLevel IDs
SELECT * 
FROM RatingLevel
WHERE RatingID < 0;

-- Check for Unique Text Values
SELECT DISTINCT RatingLevel FROM RatingLevel;

-- Check for Logical SatisfiedLevel IDs
SELECT * 
FROM SatisfiedLevel
WHERE SatisfactionID < 0;

--Check for Unique Text Values
SELECT DISTINCT SatisfactionLevel FROM SatisfiedLevel;

--set primary key & forgien key

ALTER TABLE Employee
ADD CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID);

ALTER TABLE PerformanceRating
ADD CONSTRAINT PK_PerformanceRating PRIMARY KEY (PerformanceID),
CONSTRAINT FK_Performance_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);

ALTER TABLE SatisfiedLevel
ADD CONSTRAINT PK_SatisfiedLevel PRIMARY KEY (SatisfactionID);

ALTER TABLE PerformanceRating
ADD CONSTRAINT FK_Performance_EnvSat FOREIGN KEY (EnvironmentSatisfaction) 
REFERENCES SatisfiedLevel(SatisfactionID),

CONSTRAINT FK_Performance_JobSat FOREIGN KEY (JobSatisfaction)
REFERENCES SatisfiedLevel(SatisfactionID),

CONSTRAINT FK_Performance_RelSat FOREIGN KEY (RelationshipSatisfaction)
REFERENCES SatisfiedLevel(SatisfactionID);

ALTER TABLE RatingLevel
ADD CONSTRAINT PK_RatingLevel PRIMARY KEY (RatingID);

ALTER TABLE PerformanceRating
ADD CONSTRAINT FK_Performance_SelfRating FOREIGN KEY (SelfRating)
REFERENCES RatingLevel(RatingID),

CONSTRAINT FK_Performance_ManagerRating FOREIGN KEY (ManagerRating)
REFERENCES RatingLevel(RatingID);

ALTER TABLE EducationLevel
ADD CONSTRAINT PK_EducationLevel PRIMARY KEY (EducationLevelID);

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Education FOREIGN KEY (Education)
REFERENCES EducationLevel(EducationLevelID);

--Add TenureCompany column in Employee Table

ALTER TABLE Employee
ADD TenureCompany AS 
    CASE 
        WHEN YearsAtCompany < 2 THEN '0–1'
        WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2–5'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6–10'
        ELSE '10+'
    END;

--Add TrainingRatio column in table PerformanceRating

ALTER TABLE PerformanceRating
ADD TrainingRatio DECIMAL(5,2);

UPDATE PerformanceRating
SET TrainingRatio = 
    CASE 
        WHEN TrainingOpportunitiesWithinYear = 0 THEN 0
        ELSE CAST(TrainingOpportunitiesTaken AS DECIMAL(5,2)) 
             / CAST(TrainingOpportunitiesWithinYear AS DECIMAL(5,2))
    END;


-- Create column Age group in Employee table

select min(Age) as 'Min_age', max(Age) as 'Max_Age' 
from employee;

ALTER TABLE Employee
ADD AgeGroup VARCHAR(20);

UPDATE Employee
SET AgeGroup =
    CASE
        WHEN Age BETWEEN 18 AND 29 THEN '18-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END;

-- Create column Salary Level in Employee table

 ALTER TABLE Employee
ADD SalaryLevel NVARCHAR(10);

WITH SalaryLevel AS (
    SELECT 
        EmployeeID,
        PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY Salary) 
            OVER (PARTITION BY JobRole) AS P33,
        PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY Salary) 
            OVER (PARTITION BY JobRole) AS P66,
        Salary
    FROM Employee
)
UPDATE E
SET SalaryLevel = CASE
    WHEN E.Salary <= S.P33 THEN 'Low'
    WHEN E.Salary <= S.P66 THEN 'Medium'
    ELSE 'High'
END
FROM Employee E
JOIN SalaryLevel S ON E.EmployeeID = S.EmployeeID;

--Add Full Name Column in Employee Table
ALTER TABLE Employee
ADD FullName NVARCHAR(100);

UPDATE Employee
SET FullName = FirstName + ' ' + LastName;

--add end date column

ALTER TABLE Employee
ADD CurrentDate Date;

UPDATE Employee
SET CurrentDate = DATEADD(YEAR, YearsAtCompany, HireDate);


--Add ReviewCheck column  da lsa mt3mlsh
ALTER TABLE PerformanceRating
ADD ReviewCheck NVARCHAR(50);

UPDATE P
SET ReviewCheck = 
    CASE 
        WHEN P.ReviewDate < E.HireDate THEN 'Invalid - Before Hire'
        WHEN (P.ReviewDate > E.CurrentDate AND E.Attrition = 1) THEN 'Invalid - After Exit'
        ELSE 'Valid'
    END
FROM PerformanceRating P
JOIN Employee E ON P.EmployeeID = E.EmployeeID;

SELECT 
    COUNT(*) AS validCount
FROM PerformanceRating
WHERE ReviewCheck LIKE 'valid%';

select * from PerformanceRating


DELETE FROM PerformanceRating
WHERE ReviewCheck LIKE 'Invalid%';




















