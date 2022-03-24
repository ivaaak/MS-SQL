USE Gringotts

--- Problem 1
SELECT COUNT(*) AS Count
	FROM WizzardDeposits wd


--- Problem 2
SELECT MAX(wd.MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits wd


--- Problem 3
SELECT wd.DepositGroup, 
	MAX(wd.MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits wd
	GROUP BY wd.DepositGroup
	
	
--- Problem 4
SELECT wd.DepositGroup, 
	SUM(wd.DepositAmount) AS [TotalSum]
	FROM WizzardDeposits wd
	GROUP BY wd.DepositGroup


--- Problem 5
SELECT wd.DepositGroup,
	SUM(wd.DepositAmount) AS [TotalSum]
	FROM WizzardDeposits wd
	WHERE wd.MagicWandCreator = 'Ollivander family'
	GROUP BY wd.DepositGroup


--- Problem 6
SELECT wd.DepositGroup,
	SUM(wd.DepositAmount) AS [TotalSum]
	FROM WizzardDeposits wd
	WHERE wd.MagicWandCreator = 'Ollivander family'
	GROUP BY wd.DepositGroup
	HAVING SUM(wd.DepositAmount) < 150000
	ORDER BY wd.DepositGroup DESC


--- Problem 7
SELECT wd.DepositGroup,
	mwc.MagicWandCreator AS [MagicWandCreator],
	MIN(wd.DepositCharge) AS [MinDepositCharge]
	FROM WizzardDeposits wd
	JOIN WizzardDeposits mwc ON mwc.MagicWandCreator = wd.MagicWandCreator
	GROUP BY wd.DepositGroup, mwc.MagicWandCreator
	ORDER BY mwc.MagicWandCreator, wd.DepositGroup


--- Problem 8
SELECT LEFT(FirstName, 1)
	FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY LEFT(FirstName, 1)


--- Problem 9
SELECT DepositGroup, 
	IsDepositExpired,  
	AVG(DepositInterest) AS [AverageInterest]
	FROM WizzardDeposits
	WHERE DepositStartDate > '01/01/1985'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired ASC


--- Problem 10
SELECT DepartmentID, 
	SUM(Salary) AS [TotalSalary]
	FROM Employees
	GROUP BY DepartmentID
	ORDER BY DepartmentID


--- Problem 11
SELECT DepartmentID, 
	MIN(Salary) AS MinimumSalary
	FROM Employees
	WHERE DepartmentID IN (2,5,7) AND HireDate > '01/01/2000'
	GROUP BY DepartmentID
	ORDER BY DepartmentID


--- Problem 12
SELECT * INTO NewEmployeeTableDB
	FROM Employees
	WHERE Salary > 30000

DELETE 
	FROM NewEmployeeTableDB
	WHERE NewEmployeeTableDB.ManagerID = 42

UPDATE NewEmployeeTableDB
	SET Salary += 5000
	WHERE NewEmployeeTableDB.DepartmentID = 1

SELECT DepartmentID, 
	AVG(Salary) AS [AverageSalary]
	FROM NewEmployeeTableDB
	GROUP BY DepartmentID


--- Problem 13
SELECT DepartmentID,
	MAX(Salary) AS [MaxSalary]
	FROM Employees
	GROUP BY DepartmentID
	HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000


--- Problem 14
SELECT COUNT(Salary) AS [Count]
	FROM Employees
	WHERE ManagerID IS NULL
	GROUP BY ManagerID
