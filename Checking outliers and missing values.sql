SELECT 
    JobRole,
    MIN(Salary) AS MinSalary,
    MAX(Salary) AS MaxSalary,
    AVG(Salary) AS AvgSalary,
    (MAX(Salary) - MIN(Salary)) AS SalaryRange
FROM Employee
GROUP BY JobRole;

SELECT *
FROM Employee e
LEFT JOIN PerformanceRating p
    ON e.EmployeeID = p.EmployeeID
WHERE p.EmployeeID IS NULL;

select max(HireDate)
from Employee

SELECT *
FROM Employee e
LEFT JOIN PerformanceRating p
    ON e.EmployeeID = p.EmployeeID
WHERE p.PerformanceID IS NULL;

select * from Employee
where JobRole = 'Data Scientist';

Select * 
from Employee
where EmployeeID in ('372C-E204','66D5-3142','AFC3-E23F','B4E1-4A3E',
'E442-5985','ABB5-0B95','ABC2-0036')

--Data cleaning--

-- Checking Salaries --

--'372C-E204' 455000, education 4, years at company 0

Select * 
from Employee
where Education = '4'and JobRole = 'Data Scientist' and YearsAtCompany = 0 
and EducationField ='Computer Science';

select avg(salary) AS average_salary
from Employee
where Education = '4'and JobRole = 'Data Scientist' and YearsAtCompany = 0
and EducationField ='Computer Science';

UPDATE Employee
SET Salary = (select avg(salary)
from Employee
where Education = '4'and JobRole = 'Data Scientist' and YearsAtCompany = 0 
and EducationField ='Computer Science')
WHERE EmployeeID = '372C-E204';

-- AFC3-E23F' 423941, education:2, years at company: 1
Select * 
from Employee
where Education = '2'and JobRole = 'Data Scientist' and YearsAtCompany = 1;

select avg(salary) AS average_salary
from Employee
where Education = '2'and JobRole = 'Data Scientist' and YearsAtCompany = 1;

UPDATE Employee
SET Salary = (select Salary
              from Employee
			  where EmployeeID = '1053-41B1')
where EmployeeID = 'AFC3-E23F';

--801E-9D0E  : software engineer 439641, education : 4, years at company : 1
Select * 
from Employee
where Education = '4'and JobRole = 'Software Engineer' and YearsAtCompany = 1 
and EducationField = 'Information Systems';

select AVG(Salary) as avg_salary
from Employee
where Education = '4'and JobRole = 'Software Engineer' and YearsAtCompany = 1 
and EducationField = 'Information Systems';

UPDATE Employee
SET Salary = (select avg(salary)
from Employee
where Education = '4'and JobRole = 'Software Engineer' and YearsAtCompany = 1 
and EducationField = 'Information Systems')
WHERE EmployeeID = '801E-9D0E';

UPDATE Employee
SET Department = 'Sales'
WHERE EmployeeID = '9758-DE2F';

select * from Employee
where EmployeeID = '9758-DE2F';





select * from PerformanceRating
select JobRole,count(*) As Total_Employees 
from Employee
group by JobRole;

WITH Stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Salary) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Salary) OVER () AS Q3
    FROM Employee
)
SELECT 
    e.EmployeeID,
    e.Salary,
    CASE 
        WHEN e.Salary < (s.Q1 - 1.5 * (s.Q3 - s.Q1)) THEN 'Lower Outlier'
        WHEN e.Salary > (s.Q3 + 1.5 * (s.Q3 - s.Q1)) THEN 'Upper Outlier'
        ELSE 'Normal'
    END AS OutlierStatus
FROM Employee e
CROSS JOIN (
    SELECT DISTINCT Q1, Q3 FROM Stats
) s;


WITH Stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Salary) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Salary) OVER () AS Q3
    FROM Employee
)
SELECT 
    e.EmployeeID,
    e.JobRole,
    e.Salary,
    s.Q1,
    s.Q3,
    (s.Q3 + 1.5 * (s.Q3 - s.Q1)) AS UpperLimit
FROM Employee e
CROSS JOIN (
    SELECT DISTINCT Q1, Q3 FROM Stats
) s
WHERE e.Salary > (s.Q3 + 1.5 * (s.Q3 - s.Q1));




WITH Stats AS (
    SELECT 
        JobRole,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY JobRole) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY JobRole) AS Q3
    FROM Employee
)
SELECT 
    e.EmployeeID,
    e.JobRole,
    e.Salary,
    s.Q1,
    s.Q3,
    (s.Q3 + 1.5 * (s.Q3 - s.Q1)) AS UpperLimit
FROM Employee e
JOIN (
    SELECT DISTINCT JobRole, Q1, Q3 
    FROM Stats
) s
    ON e.JobRole = s.JobRole
WHERE e.Salary > (s.Q3 + 1.5 * (s.Q3 - s.Q1))
ORDER BY e.JobRole, e.Salary DESC;

select distinct EducationField
from Employee

select distinct JobRole
from employee

select * from Employee
where EmployeeID = '372C-E204'

select EducationField
from Employee

select count(*)
from Employee
where EducationField = 'Marketing';

select count(*)
from Employee
where JobRole = 'Sales Executive' and Department = 'Technology';