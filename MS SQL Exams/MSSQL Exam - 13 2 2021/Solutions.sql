--Create Table

USE Bitbucket
CREATE TABLE Users
(
	Id INT IDENTITY PRIMARY KEY ,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories
(
	Id INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE RepositoriesContributors
(
	RepositoryId INT NOT NULL REFERENCES Repositories (Id),
	ContributorId INT NOT NULL REFERENCES Users (Id)
	PRIMARY KEY (RepositoryId, ContributorId)
)

CREATE TABLE Issues
(
	Id INT IDENTITY PRIMARY KEY,
	Title VARCHAR(255) NOT NULL,
	IssueStatus CHAR(6) NOT NULL,
	RepositoryId INT NOT NULL REFERENCES Repositories (Id),
	AssigneeId INT NOT NULL REFERENCES Users (Id)
)

CREATE TABLE Commits
(
	Id INT IDENTITY PRIMARY KEY,
	[Message] VARCHAR(255) NOT NULL,
	IssueId INT REFERENCES Issues (Id),
	RepositoryId INT NOT NULL REFERENCES Repositories (Id),
	ContributorId INT NOT NULL REFERENCES Users(Id)
)

CREATE TABLE Files
(
	Id INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL(16,2) NOT NULL,
	ParentId INT REFERENCES Files (Id),
	CommitId INT NOT NULL REFERENCES Commits (Id)
)


-- Problem 2
INSERT INTO Files ([Name], Size, ParentId, CommitId) VALUES
('Trade.idk',	           2598.0,	1,	1),
('menu.net',	          9238.31,	2,	2),
('Administrate.soshy',	  1246.93,	3,	3),
('Controller.php',	      7353.15,	4,	4),
('Find.java',	          9957.86,	5,	5),
('Controller.json',      14034.87,	3,	6),
('Operate.xix',	          7662.92,	7,	7)

INSERT INTO Issues (Title, IssueStatus, RepositoryId, AssigneeId) VALUES
('Critical Problem with HomeController.cs file',	'open',	1,	4),
('Typo fix in Judge.html',	                        'open',	4,	3),
('Implement documentation for UsersService.cs',	  'closed',	8,	2),
('Unreachable code in Index.cs',	                'open',	9,	8)


-- Problem 3
UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6 


-- Problem 4
DELETE FROM RepositoriesContributors WHERE RepositoryId = 3
DELETE FROM Issues WHERE RepositoryId = 3


-- Problem 5
SELECT Id, [Message], RepositoryId, ContributorId
	FROM Commits
	ORDER BY 
		Id ASC,
		[Message] ASC,
		RepositoryId ASC,
		ContributorId ASC


-- Problem 6
SELECT Id, [Name], Size 
	FROM Files
	WHERE Size > 1000 AND ([Name] LIKE '%html%')
	ORDER BY 
		Size DESC,
		Id ASC,
		[Name] ASC


-- Problem 7
SELECT  iss.Id, us.Username + ' : ' + iss.Title AS [IssueAssignee]
	FROM Issues iss
	LEFT JOIN Users us ON us.Id = iss.AssigneeId
	ORDER BY iss.Id DESC, us.Id


-- Problem 8
SELECT * 
	FROM Files 
	WHERE ParentId != CommitId


-- Problem 9
CREATE OR ALTER FUNCTION udf_AllUserCommits(@username VARCHAR(50))
RETURNS INT
AS
BEGIN  
		DECLARE @counter INT = (SELECT COUNT(*)
						FROM Users u
						JOIN Commits com ON com.ContributorId = u.Id
						WHERE u.Username = @username)

	RETURN @counter
END
SELECT dbo.udf_AllUserCommits('DarkImmagidsa')
SELECT dbo.udf_AllUserCommits('UnderSinduxrein')


-- Problem 10
CREATE OR ALTER PROC usp_SearchForFiles (@fileExtension VARCHAR(30))
AS
	SELECT 
		Id,
		[Name],
		CAST(Size AS VARCHAR(20)) + 'KB' AS [Size]
		FROM Files
		WHERE [Name] LIKE ('%' +  @fileExtension + '%')
		ORDER BY Id ASC, [Name] ASC, Size DESC
GO
EXEC usp_SearchForFiles 'net'
EXEC usp_SearchForFiles 'txt'