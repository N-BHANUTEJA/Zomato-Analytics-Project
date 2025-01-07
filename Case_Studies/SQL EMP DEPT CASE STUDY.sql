CREATE DATABASE SQL_CASESTUDY;
USE SQL_CASESTUDY;


-- Q1
-- DEPARTMENT TABLE CREATION
CREATE TABLE dept (
    deptno INT PRIMARY KEY,        -- Department number
    dname VARCHAR(50),             -- Department name
    location VARCHAR(50)                -- Location of the department
);

-- INSERTING DEPARTMENT TABLE DATA
INSERT INTO dept (deptno, dname, location)
VALUES
    (10, 'ACCOUNTING', 'NEW YORK'),
    (20, 'RESEARCH', 'DALLAS'),
    (30, 'SALES', 'CHICAGO'),
    (40, 'OPERATIONS', 'BOSTON');

select * from dept;

-- Q2
-- CREATING EMPLOYEE TABLE
CREATE TABLE EMP (
    empno INT PRIMARY KEY,                     -- Employee number (unique and not null)
    ename VARCHAR(50),                         -- Employee name
    job VARCHAR(50) DEFAULT 'CLERK',           -- Job title (default is 'CLERK')
    manager INT,                                   -- Manager ID
    hiredate DATE,                             -- Date of hire
    salary DECIMAL(10, 2) CHECK (salary > 0),        -- Salary (must be greater than 0)
    commission DECIMAL(10, 2),                       -- Commission (can be null)
    deptno INT,                                -- Department number
    FOREIGN KEY (deptno) REFERENCES dept(deptno) -- Foreign key referencing dept
);

-- INSERTING EMPLOYEE TABLE DATA
INSERT INTO EMP (empno, ename, job, manager, hiredate, salary, commission, deptno) VALUES
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
   
   select * from emp;
   
-- -------------------------------------------------------------------------------------------------------------
-- Q3 List the Names and salary of the employee whose salary is greater than 1000
SELECT ENAME,SALARY
FROM EMP
WHERE SALARY > 1000;

-- -------------------------------------------------------------------------------------------------------------
-- Q4 List the details of the employees who have joined before end of September 81.
SELECT * FROM EMP 
WHERE HIREDATE < '1981-10-01';

-- -------------------------------------------------------------------------------------------------------------
-- Q5 List Employee Names having I as second character.
SELECT ENAME
FROM EMP
WHERE ENAME LIKE '_I%';

-- -------------------------------------------------------------------------------------------------------------
-- Q6 List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. 
-- Also assign the alias name for the columns
SELECT ENAME AS 'EMPLOYEE NAME',
		SALARY AS 'SALARY',
        SALARY*0.4 AS 'ALLOWANCES',
        SALARY*0.1 AS 'P.F',
        SALARY+(SALARY*0.4)-(SALARY*0.1) AS 'NET SALARY'
FROM EMP;

-- -------------------------------------------------------------------------------------------------------------
-- 7 List Employee Names with designations who does not report to anybody
SELECT ENAME, JOB
FROM EMP
WHERE MANAGER IS NULL;

-- -------------------------------------------------------------------------------------------------------------
-- 8 List Empno, Ename and Salary in the ascending order of salary.
SELECT EMPNO, ENAME, SALARY
FROM EMP
ORDER BY SALARY;

-- -------------------------------------------------------------------------------------------------------------
-- 9 How many jobs are available in the Organization ?
SELECT COUNT(DISTINCT JOB) AS 'JOBS AVAILABLE'
FROM EMP;

-- THE JOBS ARE
SELECT DISTINCT JOB
FROM EMP;

-- -------------------------------------------------------------------------------------------------------------
-- 10 Determine total payable salary of salesman category
SELECT SUM(SALARY) AS 'TOTAL_SALARY'
FROM EMP
WHERE JOB = 'SALESMAN';

-- -------------------------------------------------------------------------------------------------------------
-- 11 List average monthly salary for each job within each department   
SELECT DEPTNO, JOB, ROUND(avg(SALARY),2) AS 'MONTHLY_AVERAGE_SALARY'
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, MONTHLY_AVERAGE_SALARY DESC;

-- -------------------------------------------------------------------------------------------------------------
-- 12 Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.
SELECT E.ENAME, E.SALARY, D.DNAME
FROM EMP E JOIN  DEPT D
ON E.DEPTNO = D.DEPTNO;

-- 13 CREATING JOB GRADES TABLE -------------------------------------------------------------------------------------
CREATE TABLE JOB_GRADES(GRADE VARCHAR(10), LOWEST_SAL INT, HIGHEST_SAL INT);

INSERT INTO JOB_GRADES VALUES('A',0,999),
							('B',1000,1999),
                            ('C',2000,2999),
                            ('D',3000,3999),
                            ('E',4000,5000);
SELECT * FROM JOB_GRADES;

-- 14 Display the Empname, salary and  Corresponding Grade -----------------------------------------------------------
SELECT ENAME, SALARY,
		CASE
			WHEN SALARY BETWEEN 0 AND 999 THEN 'A'
            WHEN SALARY BETWEEN 1000 AND 1999 THEN 'B'
			WHEN SALARY BETWEEN 2000 AND 2999 THEN 'C'
            WHEN SALARY BETWEEN 3000 AND 3999 THEN 'D'
            WHEN SALARY BETWEEN 4000 AND 5000 THEN 'E'
		END AS GRADE
FROM EMP;

-- 15 Display the Emp name and the Manager name under whom the Employee works in the below format. ------------------------
-- EMP REPORT TO MANAGER ---------------------------------------------------------------------------------------------------
SELECT 
	CONCAT(E1.ENAME, ' Reports to ', IFNULL(E2.ENAME,' NO MANAGER')) AS 'EMP_REPORT_TO_MANAGER'
FROM 
	EMP E1 
     JOIN
	EMP E2
ON 
	E1.MANAGER = E2.EMPNO;
    