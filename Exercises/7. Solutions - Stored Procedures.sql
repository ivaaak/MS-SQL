-- Problem 1
USE SoftUni
GO
CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000 
AS
	SELECT FirstName, LastName 
		FROM Employees
		WHERE Salary > 35000
GO

EXEC usp_GetEmployeesSalaryAbove35000


-- Problem 2
CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber  (@InputNumber DECIMAL(18,4))
AS
	SELECT FirstName, LastName 
		FROM Employees
		WHERE Salary >= @InputNumber
GO

EXEC usp_GetEmployeesSalaryAboveNumber 48100


-- Problem 3
CREATE OR ALTER PROC usp_GetTownsStartingWith (@TextInput VARCHAR(30))
AS
	SELECT [Name] AS [Town]
		FROM Towns
		WHERE SUBSTRING([Name], 1, LEN(@TextInput)) = @TextInput
GO


-- Problem 4
CREATE OR ALTER PROC usp_GetEmployeesFromTown (@TownName VARCHAR(30))
AS
	SELECT FirstName, LastName
		FROM Employees empl
		LEFT JOIN Addresses ad ON ad.AddressID = empl.AddressID
		LEFT JOIN Towns town ON ad.TownID = town.TownID
		WHERE town.[Name] = @TownName
GO


-- Problem 5
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4))
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @SalaryLevel VARCHAR(30);

	IF (@Salary < 30000)
		SET @SalaryLevel = 'Low'
	ELSE IF (@Salary >= 30000 AND @Salary <= 50000)
		SET @SalaryLevel = 'Average'
	ELSE IF (@Salary > 50000)
		SET @SalaryLevel = 'High'
	ELSE
		SET @SalaryLevel = NULL

	RETURN @SalaryLevel
END


-- Problem 6
CREATE OR ALTER PROC usp_EmployeesBySalaryLevel (@ParameterLevelOfSalary VARCHAR(30))
AS
	SELECT 
	emp.FirstName,
	emp.LastName
	FROM Employees emp
	WHERE dbo.ufn_GetSalaryLevel(Salary)  = @ParameterLevelOfSalary
GO


-- Problem 7 
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@SetOfLetters VARCHAR(MAX), @Word VARCHAR(MAX))
RETURNS BIT 
AS
BEGIN
		DECLARE @Counter INT = 1;

		WHILE (@Counter <= LEN(@Word))
		BEGIN
			DECLARE @currentLetter CHAR(1) = SUBSTRING(@Word, @Counter, 1) 

			IF (CHARINDEX (@currentLetter, @SetOfLetters) = 0)
				RETURN 0

			SET @Counter += 1
		END
	RETURN 1;
END


--- Problem 9
CREATE OR ALTER PROC usp_GetHoldersFullName
AS
	SELECT (FirstName + ' ' + LastName) AS [Full Name]
		FROM AccountHolders
GO


--- Problem 10
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@InputValue DECIMAL(15, 2) )
AS
	SELECT FirstName, LastName
		FROM AccountHolders AS ah
		JOIN Accounts AS ac ON ah.Id = ac.AccountHolderId
		GROUP BY FirstName, LastName
		HAVING SUM(Balance) > @InputValue
		ORDER BY FirstName, LastName 
GO


--- Problem 11
CREATE OR ALTER FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(15,4), @rate FLOAT, @years INT)
RETURNS DECIMAL(15,4)
AS
BEGIN
	DECLARE @money DECIMAL(15,4);

	SET @money = @sum * POWER((1.0 + @rate), @years)

	RETURN @money
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)


--- Problem 12
CREATE OR ALTER PROC usp_CalculateFutureValueForAccount (@accountId INT, @iRate FLOAT)
AS
	SELECT 
		ac.Id, 
		ah.FirstName, 
		ah.LastName,
		ac.Balance,
		dbo.ufn_CalculateFutureValue(ac.Balance, @iRate, 5) AS [Balance in 5 years]
		FROM AccountHolders ah
		JOIN Accounts ac ON ac.AccountHolderId = ah.Id
		WHERE ac.Id = @accountId
GO