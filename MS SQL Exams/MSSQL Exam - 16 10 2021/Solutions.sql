--Create Table

USE CigarShop
CREATE TABLE Sizes
(
	Id INT IDENTITY PRIMARY KEY,
	[Length] INT NOT NULL,
	RingRange DECIMAL(16,2) NOT NULL
)
CREATE TABLE Tastes
(
	Id INT IDENTITY PRIMARY KEY,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)
CREATE TABLE Brands
(
	Id INT IDENTITY PRIMARY KEY,
	BrandName VARCHAR(30) UNIQUE NOT NULL,
	BrandDescription VARCHAR(MAX)
)
CREATE TABLE Cigars
(
	Id INT IDENTITY PRIMARY KEY,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) NOT NULL,
	TastId INT FOREIGN KEY REFERENCES Tastes(Id) NOT NULL,
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	PriceForSingleCigar DECIMAL(16,2) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)
CREATE TABLE Addresses
(
	Id INT IDENTITY PRIMARY KEY,
	Town NVARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Streat NVARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL
)
CREATE TABLE Clients
(
	Id INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)
CREATE TABLE ClientsCigars
(
	ClientId INT FOREIGN KEY REFERENCES Clients(Id),
	CigarId INT FOREIGN KEY REFERENCES Cigars(Id),
	PRIMARY KEY (ClientId, CigarId)
)


-- Problem 2
INSERT INTO Cigars (CigarName,	BrandId,	TastId,	SizeId,	PriceForSingleCigar,	ImageURL) VALUES 
('COHIBA ROBUSTO',	9,	1,	5,	15.50,	'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I',	9,	1,	10,	410.00,	'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE',	14,	5,	11,	7.50,	'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN',	14,	4,	15,	32.00,	'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES',	2,	3,	8,	85.21,	'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town,	Country,	Streat,	ZIP) VALUES
('Sofia',	'Bulgaria',	'18 Bul. Vasil levski',	1000),
('Athens',	'Greece',	'4342 McDonald Avenue',	10435),
('Zagreb',	'Croatia',	'4333 Lauren Drive',	10000)


-- Problem 3
UPDATE Cigars
	SET PriceForSingleCigar *= 1.20
	WHERE TastId = 1

UPDATE Brands
	SET BrandDescription = 'New description'
	WHERE BrandDescription IS NULL


-- Problem 4
DELETE FROM Clients
	WHERE AddressId IN (7, 8, 10, 23)

DELETE Addresses
	WHERE Country LIKE 'c%'


-- Problem 5
SELECT CigarName,
	PriceForSingleCigar,
	ImageURL
		FROM Cigars
	ORDER BY PriceForSingleCigar ASC, CigarName DESC

-- Problem 6
SELECT cs.Id,
	cs.CigarName,
	cs.PriceForSingleCigar,
	ts.TasteType,
	ts.TasteStrength
		FROM Cigars cs
		JOIN Tastes ts ON cs.TastId = ts.Id
		WHERE ts.TasteType IN ('Earthy' , 'Woody')
	ORDER BY cs.PriceForSingleCigar DESC


-- Problem 7
SELECT cs.Id,
	cs.FirstName + ' ' + cs.LastName AS [ClientName],
	cs.Email
		FROM Clients cs
		LEFT JOIN ClientsCigars cc ON cc.ClientId = cs.Id
		LEFT JOIN Cigars c ON cc.CigarId = c.Id
		WHERE CigarId IS NULL
	ORDER BY [ClientName] ASC


-- Problem 8
SELECT TOP (5)
	CigarName,
	PriceForSingleCigar,
	ImageURL
		FROM Cigars cs
		JOIN Sizes ss ON cs.SizeId = ss.Id
		WHERE ss.[Length] >= 12 AND (cs.CigarName LIKE '%ci%' 
			OR cs.PriceForSingleCigar > 50) AND ss.RingRange > 2.55
	ORDER BY cs.CigarName ASC, cs.PriceForSingleCigar DESC


-- Problem 9
SELECT CONCAT(FirstName , ' ' , LastName) AS [FullName],
	ads.Country,
	ads.ZIP,
	CONCAT('$', MAX([PriceForSingleCigar])) AS [CigarPrice]
		FROM Clients cs
		JOIN Addresses ads ON cs.AddressId = ads.Id
		JOIN ClientsCigars cc ON cc.ClientId = cs.Id
		JOIN Cigars cig ON cc.CigarId = cig.Id
		WHERE ZIP NOT LIKE ('%[^0-9]%')
	GROUP BY FirstName, LastName, ads.Country, ads.ZIP
	ORDER BY [FullName]


-- Problem 10
SELECT c.LastName,
	AVG(sz.[Length]) AS [CiagrLength],
	CEILING(AVG(sz.RingRange)) AS [CigarRingRange]
		FROM Clients c
		JOIN ClientsCigars cc ON cc.ClientId = c.Id
		JOIN Cigars cs ON cc.CigarId = cs.Id
		JOIN Sizes sz ON cs.SizeId = sz.Id
	GROUP BY c.LastName
	ORDER BY [CiagrLength] DESC


-- Problem 11
CREATE OR ALTER FUNCTION udf_ClientWithCigars(@name VARCHAR(50)) 
RETURNS INT
BEGIN 
	DECLARE @Result INT = (SELECT 
		COUNT(*)
		FROM Clients c
		JOIN ClientsCigars cc ON cc.ClientId = c.Id
		WHERE c.FirstName = @name)
	RETURN @Result
END


-- Problem 12
CREATE OR ALTER PROC usp_SearchByTaste(@taste VARCHAR(50))
AS
	SELECT c.CigarName AS [CigarName],
	CONCAT('$', c.PriceForSingleCigar) AS [Price],
	t.TasteType,
	b.BrandName,
	CONCAT(s.[Length], ' cm') AS [CigarLength],
	CONCAT(s.RingRange , ' cm') AS [CigarRingRange]
		FROM Tastes t
		JOIN Cigars c ON c.TastId = t.Id
		JOIN Sizes s ON c.SizeId = s.Id
		JOIN Brands b ON c.BrandId = b.Id
		WHERE t.TasteType = @taste
	ORDER BY [CigarLength] ASC, [CigarRingRange] DESC
GO
