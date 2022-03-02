--Create Tables
CREATE DATABASE [Service]
USE [Service]

DROP DATABASE [Service]


CREATE TABLE Users
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Birthdate DATETIME NOT NULL,
	Age INT ,
	CHECK(Age >= 14 AND Age <= 110),
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE Employees
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATETIME,
	Age INT,
	CHECK(Age >= 14 AND Age <= 110),
	DepartmentId INT REFERENCES Departments(Id)
)

CREATE TABLE Categories
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT NOT NULL REFERENCES Departments(Id)
)

CREATE TABLE [Status]
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	[Label] VARCHAR(30) NOT NULL,
)

CREATE TABLE Reports
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	CategoryId INT NOT NULL REFERENCES Categories(Id),
	StatusId INT NOT NULL REFERENCES [Status](Id),
	OpenDate DATETIME NOT NULL,
	CloseDATE DATETIME ,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT NOT NULL REFERENCES [Users] (Id),
	EmployeeId INT REFERENCES [Employees](Id)
)


--Problem 2
INSERT INTO Employees (FirstName, LastName, Birthdate, DepartmentId) VALUES
('Marlo', 'O Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO Reports (CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId) VALUES
(1 ,1 ,'2017-04-13' , '', 'Stuck Road on Str.133',6 , 2),
(6 ,3 ,'2015-09-05' , '2015-12-06', 'Charity trail running',3 , 5),
(14 ,2 ,'2015-09-07' , '', 'Falling bricks on Str.58',5 , 2),
(4 ,3 ,'2017-07-03' , '2017-07-06', 'Cut off streetlight on Str.11',1 , 1)


--Problem 3
UPDATE Reports
	SET CloseDate = GETDATE()
	WHERE CloseDate IS NULL
	
	
--Problem 4
DELETE FROM Reports
	WHERE [StatusId] = 4


--Problem 5
SELECT 
	[Description],
	FORMAT (OpenDate, 'dd-MM-yyyy') 
	FROM Reports
	WHERE EmployeeId IS NULL
	ORDER BY OpenDate ASC, [Description] ASC
	
	
--Problem 6
SELECT 
	r.[Description],
	ca.[Name] AS CategoryName
	FROM Reports r
	JOIN Categories ca ON r.CategoryId = ca.Id
	WHERE CategoryId IS NOT NULL
	ORDER BY [Description] ASC, CategoryName ASC

SELECT TOP 5 Name, COUNT(*) AS ReportsNumber
	FROM Reports r
	JOIN Categories ca ON ca.Id = r.CategoryId
	GROUP BY ca.[Name]
	ORDER BY COUNT(ca.Name) DESC, ca.Name


--Problem 7
SELECT TOP 5 Name, COUNT(*) AS ReportsNumber
	FROM Reports r
	JOIN Categories ca ON ca.Id = r.CategoryId
	GROUP BY ca.[Name]
	ORDER BY COUNT(ca.Name) DESC, ca.Name
	
	
--Problem 8
USE Service

CREATE OR ALTER PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT) 
AS 
GO

SELECT * FROM Employees
	WHERE Id = 17

SELECT emp.Id, emp.FirstName, rep.EmployeeId, rep.Description
	FROM Employees emp
	JOIN Departments dp ON dp.Id = emp.DepartmentId
	JOIN Categories cat ON cat.DepartmentId = dp.Id
	JOIN Reports rep ON rep.CategoryId = cat.Id
	WHERE emp.Id = 30

SELECT *
	FROM Reports rep
	JOIN Employees emp ON emp.Id = rep.EmployeeId
	WHERE emp.Id = 30

SELECT * FROM Reports
SELECT * FROM Departments
SELECT * FROM Categories

EXEC usp_AssignEmployeeToReport 12, 4
EXEC usp_AssignEmployeeToReport 3, 1
