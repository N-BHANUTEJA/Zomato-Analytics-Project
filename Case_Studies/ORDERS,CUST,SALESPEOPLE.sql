CREATE DATABASE SalesDB;
USE SalesDB;
CREATE TABLE Salespeople (
    snum INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50),
    comm DECIMAL(5, 2)
);
INSERT INTO Salespeople (snum, sname, city, comm)
VALUES
    (1001, 'Peel', 'London', 0.12),
    (1002, 'Serres', 'San Jose', 0.13),
    (1003, 'Axelrod', 'New York', 0.10),
    (1004, 'Motika', 'London', 0.11),
    (1007, 'Rafkin', 'Barcelona', 0.15);
    CREATE TABLE Cust (
    cnum INT PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(50),
    rating INT,
    snum INT,
    FOREIGN KEY (snum) REFERENCES Salespeople(snum)
);
INSERT INTO Cust (cnum, cname, city, rating, snum)
VALUES
    (2001, 'Hoffman', 'London', 100, 1001),
    (2002, 'Giovanne', 'San Jose', 200, 1003),
    (2003, 'Liu', 'New York', 300, 1002),
    (2004, 'Grass', 'London', 100, 1002),
    (2006, 'Clemens', 'San Jose', 300, 1007),
    (2007, 'Pereira', 'London', 100, 1004),
    (2008, 'James', 'Barcelona', 200, 1007);
    
CREATE TABLE Orders (
    onum INT PRIMARY KEY,
    amt DECIMAL(10, 2),
    odate DATE,
    cnum INT,
    snum INT,
    FOREIGN KEY (cnum) REFERENCES Cust(cnum),
    FOREIGN KEY (snum) REFERENCES Salespeople(snum)
);


INSERT INTO Orders (onum, amt, odate, cnum, snum)
VALUES
    (3001, 18.69, '1994-10-03', 2008, 1007),
    (3002, 1900.10, '1994-10-03', 2007, 1004),
    (3003, 767.19, '1994-10-03', 2001, 1001),
    (3005, 5160.45, '1994-10-03', 2003, 1002),
    (3006, 1098.16, '1994-10-04', 2008, 1007),
    (3007, 75.75, '1994-10-05', 2004, 1002),
    (3008, 4723.00, '1994-10-05', 2006, 1001),
    (3009, 1713.23, '1994-10-04', 2002, 1003),
    (3010, 1309.95, '1994-10-06', 2004, 1002),
    (3011, 9891.88, '1994-10-06', 2006, 1001);
    
    -- Update the city names in the Cust table
UPDATE Cust
SET city = 'Rome'
WHERE cnum = 2002;

UPDATE Cust
SET city = 'San Jose'
WHERE cnum = 2003;

UPDATE Cust
SET city = 'Berlin'
WHERE cnum = 2004;

UPDATE Cust
SET city = 'London'
WHERE cnum = 2006;

UPDATE Cust
SET city = 'Rome'
WHERE cnum = 2007;

UPDATE Cust
SET city = 'London'
WHERE cnum = 2008;
-- 4.	Write a query to match the salespeople to the customers according to the city they are living.
SELECT 
    Salespeople.snum, 
    Salespeople.sname, 
    Salespeople.city AS salesperson_city,
    Cust.cnum, 
    Cust.cname, 
    Cust.city AS customer_city
FROM 
    Salespeople
JOIN 
    Cust ON Salespeople.city = Cust.city
ORDER BY 
    Salespeople.snum;
    
-- 5.	Write a query to select the names of customers and the salespersons who are providing service to them.
SELECT 
    Cust.cname AS customer_name, 
    Salespeople.sname AS salesperson_name
FROM 
    Cust
JOIN 
    Salespeople ON Cust.snum = Salespeople.snum;
    
-- 6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople
SELECT 
    Orders.onum, 
    Orders.amt, 
    Orders.odate, 
    Cust.cnum, 
    Cust.cname AS customer_name, 
    Salespeople.snum, 
    Salespeople.sname AS salesperson_name
FROM 
    Orders
JOIN 
    Cust ON Orders.cnum = Cust.cnum
JOIN 
    Salespeople ON Orders.snum = Salespeople.snum
WHERE 
    Cust.city <> Salespeople.city;

-- 7.	Write a query that lists each order number followed by name of customer who made that order
  SELECT 
    Orders.onum, 
    Cust.cname AS customer_name
FROM 
    Orders
JOIN 
    Cust ON Orders.cnum = Cust.cnum;
    
    -- 8.	Write a query that finds all pairs of customers having the same rating………………
  SELECT 
    C1.cname AS customer1_name, 
    C2.cname AS customer2_name, 
    C1.rating
FROM 
    Cust C1
JOIN 
    Cust C2 ON C1.rating = C2.rating
WHERE 
    C1.cnum < C2.cnum;
    
    -- 9.	Write a query to find out all pairs of customers served by a single salesperson………………..
SELECT 
    C1.cname AS customer1_name, 
    C2.cname AS customer2_name, 
    Salespeople.sname AS salesperson_name
FROM 
    Cust C1
JOIN 
    Cust C2 ON C1.snum = C2.snum AND C1.cnum < C2.cnum
JOIN 
    Salespeople ON C1.snum = Salespeople.snum;
    
-- 10.	Write a query that produces all pairs of salespeople who are living in same city………………..
SELECT 
    S1.sname AS salesperson1_name, 
    S2.sname AS salesperson2_name, 
    S1.city AS city
FROM 
    Salespeople S1
JOIN 
    Salespeople S2 ON S1.city = S2.city
WHERE 
    S1.snum < S2.snum;

-- 11.	Write a Query to find all orders credited to the same salesperson who services Customer 2008
SELECT 
    Orders.onum, 
    Orders.amt, 
    Orders.odate, 
    Cust.cnum, 
    Cust.cname AS customer_name,
    Salespeople.snum, 
    Salespeople.sname AS salesperson_name
FROM 
    Orders
JOIN 
    Cust ON Orders.cnum = Cust.cnum
JOIN 
    Salespeople ON Orders.snum = Salespeople.snum
WHERE 
    Salespeople.snum = (
        SELECT snum
        FROM Cust
        WHERE cnum = 2008
    );
    
    -- 12.	Write a Query to find out all orders that are greater than the average for Oct 4th
SELECT 
    onum, 
    amt, 
    odate, 
    cnum, 
    snum
FROM 
    Orders
WHERE 
    odate = '1994-10-04'
    AND amt > (
        SELECT AVG(amt)
        FROM Orders
        WHERE odate = '1994-10-04'
    );
    
-- 13.	Write a Query to find all orders attributed to salespeople in London.
SELECT 
    Orders.onum, 
    Orders.amt, 
    Orders.odate, 
    Orders.cnum, 
    Orders.snum, 
    Salespeople.sname AS salesperson_name
FROM 
    Orders
JOIN 
    Salespeople ON Orders.snum = Salespeople.snum
WHERE 
    Salespeople.city = 'London';
    
-- 14.	Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 
SELECT 
    cnum, 
    cname, 
    city, 
    rating, 
    snum
FROM 
    Cust
WHERE 
    cnum > (
        SELECT snum 
        FROM Salespeople 
        WHERE sname = 'Serres'
    ) + 1000;

-- 15.	Write a query to count customers with ratings above San Jose’s average rating.
SELECT 
    COUNT(*) AS customer_count
FROM 
    Cust
WHERE 
    rating > (
        SELECT AVG(rating)
        FROM Cust
        WHERE city = 'San Jose'
    );

-- 16.	Write a query to show each salesperson with multiple customers.
SELECT 
    Salespeople.snum, 
    Salespeople.sname, 
    COUNT(Cust.cnum) AS customer_count
FROM 
    Salespeople
JOIN 
    Cust ON Salespeople.snum = Cust.snum
GROUP BY 
    Salespeople.snum, Salespeople.sname
HAVING 
    COUNT(Cust.cnum) > 1;
