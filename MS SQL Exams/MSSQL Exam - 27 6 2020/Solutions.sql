--Create Tables
CREATE DATABASE WMS
USE WMS

CREATE TABLE Clients
(
	ClientId INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Phone VARCHAR(12),
	CHECK (LEN(Phone) = 12)
)
CREATE TABLE Mechanics
(
	MechanicId INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	[Address] VARCHAR(255)
)
CREATE TABLE Models
(
	ModelId INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) UNIQUE
)
CREATE TABLE Vendors
(
	VendorId INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) UNIQUE
)
CREATE TABLE Jobs
(
	JobId INT IDENTITY PRIMARY KEY,
    ModelId INT REFERENCES Models (ModelId),
    [Status] VARCHAR(11) DEFAULT  'Pending',
    ClientId INT REFERENCES Clients (ClientId),
    MechanicId INT REFERENCES Mechanics (MechanicId),
    IssueDate DATE,
    FinishDate DATE,
)
CREATE TABLE Orders
(
	OrderId INT IDENTITY PRIMARY KEY,
	JobId INT REFERENCES Jobs (JobId),
	IssueDate DATE,
	Delivered BIT DEFAULT 0
)
CREATE TABLE Parts
(
	PartId INT IDENTITY PRIMARY KEY,
	SerialNumber VARCHAR(50) UNIQUE,
	[Description] VARCHAR(255) ,
	Price DECIMAL(15, 2),
	CHECK (Price > 0),
	VendorId INT REFERENCES Vendors (VendorId),
	StockQty INT DEFAULT 0,
)
CREATE TABLE OrderParts
(
	OrderId INT REFERENCES Orders (OrderId),
	PartId INT REFERENCES Parts (PartId),
	PRIMARY KEY (OrderId, PartId),
	Quantity INT DEFAULT 1,
)
CREATE TABLE PartsNeeded
(
	JobId INT REFERENCES Jobs (JobId),
	PartId INT REFERENCES Parts (PartId),
	PRIMARY KEY (JobId, PartId),
	Quantity INT DEFAULT 1
)


--Problem 2
USE WMS

INSERT INTO Clients (FirstName, LastName, Phone) VALUES 
('Teri',		'Ennaco',	        '570-889-5187'),
('Merlyn',	    'Lawler',	        '201-588-7810'),
('Georgene',	'Montezuma',	    '925-615-5185'),
('Jettie',	    'Mconnell',			'908-802-3564'),
('Lemuel',	    'Latzke',			'631-748-6479'),
('Melodie',	    'Knipp',			'805-690-1682'),
('Candida',	    'Corbley',			'908-275-8357')

INSERT INTO Parts (SerialNumber, [Description], Price, VendorId) VALUES
('WP8182119',	'Door Boot Seal',			   117.86,	2),
('W10780048',	'Suspension Rod',				42.81,	1),
('W10841140',	'Silicone Adhesive', 			 6.77,	4),
('WPY055980',	'High Temperature Adhesive',	13.94,	3)


--Problem 3
SELECT * FROM Mechanics 
SELECT * FROM Jobs WHERE MechanicId = 3
SELECT COUNT(*)
FROM Jobs
WHERE [Status] = 'Pending'

UPDATE Jobs
SET [Status] = 'In Progress'
WHERE [Status] = 'Pending'

UPDATE Jobs
SET [Status] = 'In Progress'
WHERE MechanicId = 3 AND [Status] = 'Pending'


--Problem 4
DELETE FROM Orders WHERE OrderId = 19;
DELETE FROM OrderParts WHERE OrderId = 19;


--Problem 5
SELECT mec.FirstName + ' ' + mec.LastName AS [Mechanic],
	j.[Status],
	j.IssueDate
	FROM Mechanics mec
	JOIN Jobs j ON mec.MechanicId = j.MechanicId
	ORDER BY mec.MechanicId ASC, j.IssueDate ASC, j.JobId ASC
	
	
--Problem 6
SELECT c.FirstName + ' ' + c.LastName AS [Client],
	DATEDIFF(DAY, j.IssueDate, '24 April 2017') AS [Days going],
	[Status]
	FROM Clients c
	JOIN Jobs j ON c.ClientId = j.ClientId
	WHERE j.[Status] != 'Finished'
	ORDER BY [Days going] DESC, c.ClientId ASC
