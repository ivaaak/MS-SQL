--Problem 1 - Number of Users for Email Provider
SELECT (
SUBSTRING(Email,  CHARINDEX('@', Email) + 1, LEN (Email))) AS [Email Provider],
	   COUNT(*) AS [Number Of Users]
	FROM Users
	GROUP BY (SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN (Email)))
	ORDER BY COUNT(*) DESC, (SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN (Email)))

--Problem 2 - All Users in Games
SELECT 
	g.[Name] AS [Game],
	gt.[Name] AS [Game Type],
	u.Username,
	ug.[Level],
	ug.Cash,
	ch.[Name] AS [Character]
		FROM Games g
		JOIN GameTypes gt ON gt.Id = g.GameTypeId
		JOIN UsersGames	ug ON g.Id  = ug.GameId 
		JOIN Characters ch ON ch.Id = ug.CharacterId
		JOIN Users u ON u.Id = ug.UserId
	ORDER BY ug.[Level] DESC, u.Username, g.[Name]

--Problem 3 - Users in Games with Their Items
SELECT 
		u.Username,
		g.[Name] AS Game,
		COUNT (*) AS [Items Count],
		SUM(it.Price) * COUNT(*) AS [Items Price]
		FROM Users u
		JOIN UsersGames ug ON ug.UserId = u.Id
		JOIN Games g ON ug.GameId = g.Id
		JOIN UserGameItems ugi ON ugi.UserGameId = ug.Id
		JOIN Items it ON ugi.ItemId = it.Id
	WHERE u.Username = 'obliquepoof'
	GROUP BY u.Username, g.[Name]
	ORDER BY COUNT (*) DESC
