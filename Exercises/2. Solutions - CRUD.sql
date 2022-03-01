USE SoftUni

-- Problem 6
SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address] 
       FROM Employees

-- Problem 7
SELECT DISTINCT Salary
       FROM Employees

-- Problem 8
SELECT * FROM Employees 
       WHERE  JobTitle = 'Sales Representative'

-- Problem 9 
SELECT FirstName, LastName, JobTitle FROM Employees
       WHERE Salary >= 20000 AND Salary <= 30000

-- Problem 10 
SELECT FirstName + ' ' + MiddleName + ' ' +LastName AS [Full Name] 
       FROM Employees
	   WHERE Salary IN (25000, 14000, 12500, 23600)

-- Problem 11
SELECT FirstName, LastName FROM Employees
       WHERE ManagerID IS NULL

-- Problem 12
SELECT FirstName, LastName, Salary 
       FROM Employees
	   WHERE Salary > 50000
	   ORDER BY Salary DESC

-- Problem 13 
SELECT TOP (5) FirstName, LastName 
       FROM Employees
	   ORDER BY Salary DESC

-- Problem 14 
SELECT FirstName, LastName 
       FROM Employees
	   WHERE DepartmentID <> 4

-- Problem 15
SELECT * FROM Employees
         ORDER BY 
		 Salary DESC, 
		 FirstName ASC,
		 LastName DESC,
		 MiddleName ASC

-- Problem 16
CREATE VIEW V_EmployeesSalaries AS
         SELECT FirstName, LastName, Salary
         FROM Employees

-- Problem 17
CREATE VIEW V_EmployeeNameJobTitle AS
       SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name],
	   JobTitle
	   FROM Employees

-- Problem 18
SELECT DISTINCT JobTitle FROM Employees
	   ORDER BY JobTitle ASC

-- Problem 19
SELECT TOP 10 ProjectID, [Name], [Description], StartDate, EndDate
       FROM Projects
       ORDER BY 
	   StartDate ASC,
	   [Name]

-- Problem 20
SELECT TOP (7) FirstName, LastName, HireDate 
       FROM Employees
	   ORDER BY HireDate DESC
	   
-- Problem 22
SELECT PeakName 
       FROM Peaks
	   ORDER BY PeakName ASC

-- Problem 23
SELECT TOP (30) CountryName, [Population]
        FROM Countries
		WHERE ContinentCode IN ('EU')
		ORDER BY [Population] DESC

-- Problem 25
SELECT [Name] FROM Characters
        ORDER BY [Name] ASC
