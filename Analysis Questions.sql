--level of employee satisfaction --
WITH LatestReview AS (
    SELECT 
        EmployeeID,
        MAX(ReviewDate) AS MaxReviewDate
    FROM PerformanceRating
    GROUP BY EmployeeID
),
LatestData AS (
    SELECT 
        p.EmployeeID,
        p.WorkLifeBalance,
        p.EnvironmentSatisfaction,
        p.JobSatisfaction,
        p.RelationshipSatisfaction
    FROM PerformanceRating p
    JOIN LatestReview lr 
        ON p.EmployeeID = lr.EmployeeID AND p.ReviewDate = lr.MaxReviewDate
),
Unpivoted AS (
    SELECT EmployeeID, 'WorkLifeBalance' AS SatisfactionType, WorkLifeBalance AS SatisfactionID
    FROM LatestData
    UNION ALL
    SELECT EmployeeID, 'EnvironmentSatisfaction', EnvironmentSatisfaction
    FROM LatestData
    UNION ALL
    SELECT EmployeeID, 'JobSatisfaction', JobSatisfaction
    FROM LatestData
    UNION ALL
    SELECT EmployeeID, 'RelationshipSatisfaction', RelationshipSatisfaction
    FROM LatestData
)
SELECT 
    u.SatisfactionType,
    s.SatisfactionLevel,
    COUNT(*) AS EmployeeCount,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM LatestData), 2) AS Percentage
FROM Unpivoted u
JOIN SatisfiedLevel s 
    ON s.SatisfactionID = u.SatisfactionID
GROUP BY 
    u.SatisfactionType,
    s.SatisfactionLevel
ORDER BY 
    u.SatisfactionType,
    s.SatisfactionLevel;

--company’s hiring trend changed over the years--
SELECT
  YEAR(HireDate) AS Year,
  COUNT(*) AS Hires

FROM Employee
WHERE HireDate IS NOT NULL
GROUP BY YEAR(HireDate)
ORDER BY Year;

--employee attrition across the years--
SELECT 
    YEAR(CurrentDate) AS Year,
    COUNT(EmployeeID) AS AttritionCount
FROM Employee
WHERE Attrition = 1
GROUP BY YEAR(CurrentDate)
ORDER BY Year;

--attrition rate per gender group
WITH GenderAttrition AS (
    SELECT 
        CASE 
            WHEN Gender IN ('Male', 'Female') THEN Gender
            ELSE 'Other'
        END AS GenderGroup,
        COUNT(*) AS Attritions
    FROM Employee
    WHERE Attrition = 1
    GROUP BY 
        CASE 
            WHEN Gender IN ('Male', 'Female') THEN Gender
            ELSE 'Other'
        END
)
SELECT 
    GenderGroup,
    Attritions,
    ROUND(Attritions * 100.0 / SUM(Attritions) OVER (), 2) AS Percentage
FROM GenderAttrition;

--the percentage of employees who take OverTime and who don't--
WITH OverTimeCounts AS (
    SELECT 
        OverTime,
        COUNT(*) AS Count
    FROM Employee
    GROUP BY OverTime
)
SELECT 
    OverTime,
    Count,
    ROUND(Count * 100.0 / SUM(Count) OVER (), 2) AS Percentage
FROM OverTimeCounts
ORDER BY OverTime;

--#employees in each department--
SELECT 
    Department,
    COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY Department
ORDER BY TotalEmployees DESC;

--distribution of employees by age group--
SELECT
  CASE 
    WHEN Gender = 'Male' THEN 'Male'
    WHEN Gender = 'Female' THEN 'Female'
    ELSE 'Others'
  END AS GenderGroup,
  COUNT(*) AS EmployeeCount,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS Percentage
FROM Employee
GROUP BY 
  CASE 
    WHEN Gender = 'Male' THEN 'Male'
    WHEN Gender = 'Female' THEN 'Female'
    ELSE 'Others'
  END
ORDER BY GenderGroup;

--number of employees in each state--
SELECT 
    State,
    COUNT(DISTINCT EmployeeID) AS TotalEmployees
FROM Employee
GROUP BY State
ORDER BY TotalEmployees DESC;

--#employees per marital status--
SELECT 
    MaritalStatus,
    COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY MaritalStatus;

--#employees in each job role--
SELECT 
    JobRole,
    COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY JobRole
ORDER BY TotalEmployees DESC;

--#employees by Education Level
SELECT 
    EducationLevel,
    COUNT(*) AS TotalEmployees
FROM EducationLevel e join Employee em
on e.EducationLevelID=em.Education
GROUP BY EducationLevel
ORDER BY TotalEmployees DESC

--#employees in each Education Field
SELECT 
    EducationField,
    COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY EducationField
ORDER BY TotalEmployees DESC

-- Attrition vs Age Group
Select AgeGroup, count(*) as TotalEmployees, 
SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount, 
CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
from Employee
Group by AgeGroup
ORDER BY AttritionRatePercent DESC;

--attrition rate per department--
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
	CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent

FROM Employee
GROUP BY Department
ORDER BY AttritionRatePercent DESC;

--attrition rate per marital status--
select MaritalStatus,COUNT(*) AS TotalEmployees,
SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
from Employee
group by MaritalStatus
ORDER BY AttritionRatePercent DESC;

-- attrition rate vs business travel--
select BusinessTravel,COUNT(*) AS TotalEmployees,
SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
from Employee
group by BusinessTravel
ORDER BY AttritionRatePercent DESC;

--attrition rate per state--
SELECT 
    State,COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
    CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
FROM Employee
GROUP BY State
ORDER BY AttritionRatePercent DESC;

--attrition rate per jobrole--
SELECT 
    JobRole,COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
    CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
FROM Employee
GROUP BY JobRole
ORDER BY AttritionRatePercent DESC;

--attrition rate vs overtime--
SELECT 
    OverTime,COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
	CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
FROM Employee
GROUP BY OverTime

--attrition rate vs salary level--
SELECT 
    SalaryLevel,COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS AttritionCount,
	CAST(ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(5,2)) AS AttritionRatePercent
FROM Employee
GROUP BY SalaryLevel

--average salary by age group--
Select AgeGroup,
    AVG(Salary) AS AverageSalary
From Employee
Group by AgeGroup

--average salary by department--
SELECT 
    Department,
    AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY Department;

--average salary by job role--
SELECT 
    JobRole,
    AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY JobRole;

--average salary by educational level--
SELECT 
    EducationLevel,
    AVG(Salary) AS AverageSalary
FROM Employee e join EducationLevel ed
on e.Education=ed.EducationLevelID
GROUP BY EducationLevel;

--#employees per salary levels--
SELECT 
    SalaryLevel,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employee
GROUP BY SalaryLevel
ORDER BY SalaryLevel;

--Performance by JobRole--
WITH LatestReview AS (
    SELECT 
        EmployeeID,
        MAX(ReviewDate) AS MaxReviewDate
    FROM PerformanceRating
    GROUP BY EmployeeID
)

SELECT 
   JobRole, r.RatingLevel AS Performance,
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees
FROM PerformanceRating p
JOIN LatestReview lr 
    ON p.EmployeeID = lr.EmployeeID AND p.ReviewDate = lr.MaxReviewDate
JOIN Employee e 
    ON p.EmployeeID = e.EmployeeID
JOIN RatingLevel r 
    ON r.RatingID = p.ManagerRating
GROUP BY JobRole,r.RatingLevel
order by JobRole; 

--Overtime Vs Performance--

WITH LatestReview AS (
    SELECT 
        EmployeeID,
        MAX(ReviewDate) AS MaxReviewDate
    FROM PerformanceRating
    GROUP BY EmployeeID
)
SELECT 
    OverTime,
	r.RatingLevel AS ManagerRating,
    COUNT(DISTINCT p.EmployeeID) AS TotalEmployees
FROM PerformanceRating p
JOIN LatestReview lr 
    ON p.EmployeeID = lr.EmployeeID AND p.ReviewDate = lr.MaxReviewDate
JOIN Employee e 
    ON p.EmployeeID = e.EmployeeID
JOIN RatingLevel r
    ON r.RatingID = p.ManagerRating
GROUP BY r.RatingLevel,OverTime;

--Performance Vs Overtime
WITH LatestReview AS (
    SELECT 
        EmployeeID,
        MAX(ReviewDate) AS MaxReviewDate
    FROM PerformanceRating
    GROUP BY EmployeeID
)

SELECT 
   OverTime, r.RatingLevel AS Performance,
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees
FROM PerformanceRating p
JOIN LatestReview lr 
    ON p.EmployeeID = lr.EmployeeID AND p.ReviewDate = lr.MaxReviewDate
JOIN Employee e 
    ON p.EmployeeID = e.EmployeeID
JOIN RatingLevel r 
    ON r.RatingID = p.ManagerRating
GROUP BY OverTime,r.RatingLevel
order by OverTime; 

--Performance Vs SalaryLevel
WITH LatestReview AS (
    SELECT 
        EmployeeID,
        MAX(ReviewDate) AS MaxReviewDate
    FROM PerformanceRating
    GROUP BY EmployeeID
)

SELECT 
   SalaryLevel, r.RatingLevel AS Performance,
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees
FROM PerformanceRating p
JOIN LatestReview lr 
    ON p.EmployeeID = lr.EmployeeID AND p.ReviewDate = lr.MaxReviewDate
JOIN Employee e 
    ON p.EmployeeID = e.EmployeeID
JOIN RatingLevel r 
    ON r.RatingID = p.ManagerRating
GROUP BY SalaryLevel,r.RatingLevel
order by SalaryLevel; 

--Promotion Status Overview--
WITH LatestPerformance AS (
    SELECT
        p.EmployeeID,
        p.ManagerRating,
        p.ReviewDate,
        ROW_NUMBER() OVER (
            PARTITION BY p.EmployeeID
            ORDER BY p.ReviewDate DESC
        ) AS rn
    FROM PerformanceRating p
),

PerfWithEmployee AS (
    SELECT
        lp.EmployeeID,
        lp.ManagerRating,
        e.JobRole,
        e.YearsSinceLastPromotion,
        CASE
            WHEN lp.ManagerRating > 4 AND e.YearsSinceLastPromotion > 3
                THEN 'Ready for Promotion'
            WHEN lp.ManagerRating > 4 AND e.YearsSinceLastPromotion <= 3
                THEN 'Recently Promoted'
            WHEN lp.ManagerRating >= 3
                THEN 'Needs Development'
            WHEN lp.ManagerRating < 3
                THEN 'At Risk / Consider Exit'
            ELSE 'Unknown'
        END AS PromotionStatus
    FROM LatestPerformance lp
    JOIN Employee e
        ON lp.EmployeeID = e.EmployeeID
    WHERE lp.rn = 1   -- take latest performance record
)

SELECT
    JobRole,
    PromotionStatus,
    COUNT(DISTINCT EmployeeID) AS TotalEmployees
FROM PerfWithEmployee
GROUP BY JobRole, PromotionStatus
ORDER BY JobRole, PromotionStatus;

--Employee distribution per manager rating
WITH LatestReview AS (
    SELECT 
        EmployeeID,
        MAX(ReviewDate) AS MaxReviewDate
    FROM PerformanceRating
    GROUP BY EmployeeID
)

SELECT 
   r.RatingLevel AS Performance,
    COUNT(DISTINCT e.EmployeeID) AS TotalEmployees
FROM PerformanceRating p
JOIN LatestReview lr 
    ON p.EmployeeID = lr.EmployeeID AND p.ReviewDate = lr.MaxReviewDate
JOIN Employee e 
    ON p.EmployeeID = e.EmployeeID
JOIN RatingLevel r 
    ON r.RatingID = p.ManagerRating
GROUP BY r.RatingID,r.RatingLevel
order by r.RatingID; 







