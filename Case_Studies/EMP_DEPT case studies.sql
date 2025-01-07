CREATE DATABASE CompanyDB;
USE CompanyDB;
CREATE SCHEMA CompanySchema;
CREATE TABLE CompanySchema.dept (
    deptno INT PRIMARY KEY,        -- Department number
    dname VARCHAR(50),             -- Department name
    loc VARCHAR(50)                -- Location of the department
);
CREATE TABLE CompanySchema.dept (
    deptno INT PRIMARY KEY,        -- Department number
    dname VARCHAR(50),             -- Department name
    loc VARCHAR(50)                -- Location of the department
);
INSERT INTO CompanySchema.dept (deptno, dname, loc)
VALUES
    (10, 'ACCOUNTING', 'NEW YORK'),
    (20, 'RESEARCH', 'DALLAS'),
    (30, 'SALES', 'CHICAGO'),
    (40, 'OPERATIONS', 'BOSTON');
    CREATE TABLE CompanySchema.emp (
    empno INT PRIMARY KEY,                     -- Employee number (unique and not null)
    ename VARCHAR(50),                         -- Employee name
    job VARCHAR(50) DEFAULT 'CLERK',           -- Job title (default is 'CLERK')
    mgr INT,                                   -- Manager ID
    hiredate DATE,                             -- Date of hire
    sal DECIMAL(10, 2) CHECK (sal > 0),        -- Salary (must be greater than 0)
    comm DECIMAL(10, 2),                       -- Commission (can be null)
    deptno INT,                                -- Department number
    FOREIGN KEY (deptno) REFERENCES CompanySchema.dept(deptno) -- Foreign key referencing dept
);
INSERT INTO CompanySchema.emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
    (7369, 'SMITH', 'CLERK', 7902, '1890-12-17', 800.00, NULL, 20),
    (7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
    (7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
    (7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
    (7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
    (7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
    (7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
    (7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
    (7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
    (7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
    (7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
    (7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
    (7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
    (7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);
    
-- Swap the values for deptno = 10 and deptno = 40
UPDATE CompanySchema.dept
SET dname = 'ACCOUNTING', loc = 'NEW YORK'
WHERE deptno = 40;

UPDATE CompanySchema.dept
SET dname = 'OPERATIONS', loc = 'BOSTON'
WHERE deptno = 10;

-- 3.	List the Names and salary of the employee whose salary is greater than 1000
SELECT ename, sal
FROM CompanySchema.emp
WHERE sal > 1000;

-- 4.	List the details of the employees who have joined before end of September 81.
SELECT *
FROM CompanySchema.emp
WHERE hiredate < '1981-10-01';

-- 5.	List Employee Names having I as second character.
SELECT ename
FROM CompanySchema.emp
WHERE ename LIKE '_I%';

-- 6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns
SELECT 
    ename AS Employee_Name,
    sal AS Salary,
    sal * 0.40 AS Allowances,
    sal * 0.10 AS PF,
    sal + (sal * 0.40) - (sal * 0.10) AS Net_Salary
FROM CompanySchema.emp;

-- 7.	  List Employee Names with designations who does not report to anybody
SELECT ename AS Employee_Name, job AS Designation
FROM CompanySchema.emp
WHERE mgr IS NULL;

-- 8.	List Empno, Ename and Salary in the ascending order of salary.
SELECT empno, ename, sal
FROM CompanySchema.emp
ORDER BY sal ASC;

-- 9.	How many jobs are available in the Organization ?
SELECT COUNT(DISTINCT job) AS NumberOfJobs
FROM CompanySchema.emp;

-- 10.	Determine total payable salary of salesman category
SELECT SUM(sal) AS Total_Salary_Payable
FROM CompanySchema.emp
WHERE job = 'SALESMAN';

-- 11.	List average monthly salary for each job within each department   
SELECT 
    deptno AS Department_Number,
    job AS Job_Title,
    AVG(sal)  AS Average_Monthly_Salary
FROM CompanySchema.emp
GROUP BY deptno, job
ORDER BY deptno, job;

-- 12.	Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.
SELECT 
    e.ename AS Employee_Name,
    e.sal AS Salary,
    d.dname AS Department_Name
FROM CompanySchema.emp e
JOIN CompanySchema.dept d ON e.deptno = d.deptno;

-- 13.	  Create the Job Grades Table as below
CREATE TABLE CompanySchema.job_grades (
    grade CHAR(1) PRIMARY KEY,      -- Job grade (e.g., 'A', 'B', etc.)
    lowest_sal DECIMAL(10, 2),      -- Lowest salary for this grade
    highest_sal DECIMAL(10, 2)     -- Highest salary for this grade
);

INSERT INTO CompanySchema.job_grades (grade, lowest_sal, highest_sal)
VALUES
    ('A', 0.00, 999.00),
    ('B', 1000.00, 1999.00),
    ('C', 2000.00, 2999.00),
    ('D', 3000.00, 3999.00),
    ('E', 4000.00, 5000.00);
    
-- 14.	Display the last name, salary and  Corresponding Grade.
SELECT e.ename, e.sal, j.grade
FROM CompanySchema.emp e
JOIN CompanySchema.job_grades j
ON e.sal BETWEEN j.lowest_sal AND j.highest_sal;

-- 15.	Display the Emp name and the Manager name under whom the Employee works in the below format .
-- Emp Report to Mgr.
SELECT e.ename AS "Emp", 
       m.ename AS "Mgr"
FROM CompanySchema.emp e
LEFT JOIN CompanySchema.emp m
ON e.mgr = m.empno;

-- 16.	Display Empname and Total sal where Total Sal (sal + Comm)
SELECT e.ename AS "Empname", 
       (e.sal + COALESCE(e.comm, 0)) AS "Total Sal"
FROM CompanySchema.emp e;

-- 17.	Display Empname and Sal whose empno is a odd number
SELECT e.ename AS "Empname", 
       e.sal AS "Sal"
FROM CompanySchema.emp e
WHERE MOD(e.empno, 2) = 1;

-- 18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department
SELECT e.ename AS "Empname",
       RANK() OVER (ORDER BY e.sal DESC) AS "Rank in Organisation",
       RANK() OVER (PARTITION BY e.deptno ORDER BY e.sal DESC) AS "Rank in Department"
FROM CompanySchema.emp e;

-- 19.	Display Top 3 Empnames based on their Salary

SELECT e.ename AS "Empname", 
       e.sal AS "Salary"
FROM CompanySchema.emp e
ORDER BY e.sal DESC
LIMIT 3;

-- 20.	 Display Empname who has highest Salary in Each Department.
SELECT e.ename AS "Empname",
       e.deptno AS "Deptno",
       e.sal AS "Salary"
FROM CompanySchema.emp e
WHERE e.sal = (
    SELECT MAX(sal)
    FROM CompanySchema.emp
    WHERE deptno = e.deptno
);









