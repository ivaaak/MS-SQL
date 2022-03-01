CREATE DATABASE TableRelationsDB
USE TableRelationsDB


-- Problem 1
CREATE TABLE Passports 
( 
      PassportID INT PRIMARY KEY NOT NULL,
	  PassportNumber CHAR(30),
)
CREATE TABLE Persons
(
	PersonID INT NOT NULL,
	FirstName VARCHAR(30),
	Salary FLOAT NOT NULL,
	PassportID INT,
	PRIMARY KEY (PersonID),
	FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)
)

INSERT INTO Passports (PassportID, PassportNumber)
       VALUES
	   (101, 'N34FG21B'),
	   (102, 'K65LO4R7'),
	   (103, 'ZE657QP2')
INSERT INTO Persons (PersonID, FirstName, Salary, PassportID)
       VALUES
	  (1, 'Roberto', 43300.00, 102),
	  (2, 'Tom', 56100.00, 103),
	  (3, 'Yana', 60200.00, 101)


-- Problem 2 
USE MyDemoData
CREATE TABLE Manufacturers
( 
        ManufacturerID INT NOT NULL,
	[Name] VARCHAR(30) NOT NULL,
	EstablishedOn VARCHAR(30) NOT NULL,
	PRIMARY KEY (ManufacturerID)
)
CREATE TABLE Models
( 
        ModelID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(30) NOT NULL,
	ManufacturerID INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers (ManufacturerID, [Name], EstablishedOn)
       VALUES
	   (1, 'BMW', '07/03/1916'),
	   (2, 'Tesla', '01/01/2003'),
	   (3, 'Lada', '01/05/1966')
INSERT INTO Models (ModelID, [Name], ManufacturerID)
       VALUES
	   (101, 'X1', 1),
	   (102, 'i6', 1),
	   (103, 'Model S', 2),
	   (104, 'Model X', 2),
	   (105, 'Model 3', 2),
	   (106, 'Nova', 3)


-- Problem 3
USE MyDemoData
CREATE TABLE Students
(      
        StudentID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(30) NOT NULL,
)
CREATE TABLE Exams
(
        ExamID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(30) NOT NULL,
)
CREATE TABLE StudentsExams
(
        StudentID INT NOT NULL,
	ExamID INT NOT NULL,
	PRIMARY KEY (StudentID, ExamID),
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students (StudentID, [Name])
       VALUES 
	   (1, 'Mila'),
	   (2, 'Toni'),
	   (3, 'Ron')
INSERT INTO Exams (ExamID, [Name])
       VALUES
	   (101, 'SpringMVC'),
	   (102, 'Neo4j'),
	   (103, 'Oracle 11g')
INSERT INTO StudentsExams (StudentID, ExamID)
       VALUES 
	   (1, 101),
	   (1, 102),
	   (2, 101),
	   (3, 103),
	   (2, 102),
	   (2, 103)


-- Problem 4
USE TableRelationsDB

CREATE TABLE Teachers
(      
	TeacherID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(30) NOT NULL,
	ManagerID INT REFERENCES Teachers(TeacherID)
)


-- Problem 5
CREATE DATABASE OnlineStore
USE OnlineStore
CREATE TABLE Cities
(
	CityID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL
)
CREATE TABLE Customers
(
	CustomerID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(50),
	Birthday DATE,
	CityID INT,
)
ALTER TABLE Customers
	ADD FOREIGN KEY (CityID) REFERENCES Cities(CityID)

CREATE TABLE Orders
(
	OrderID INT NOT NULL PRIMARY KEY,
	CustomerID INT NOT NULL,
)
ALTER TABLE Orders
	ADD FOREIGN KEY	(CustomerID) REFERENCES Customers(CustomerID)

CREATE TABLE ItemTypes
(
	ItemTypeID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL
)
CREATE TABLE Items
(
	ItemID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(30) NOT NULL,
	ItemTypeID INT NOT NULL, 
)
ALTER TABLE Items
	ADD FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID)

CREATE TABLE OrderItems
(
	OrderID INT NOT NULL,
	ItemID INT NOT NULL
	PRIMARY KEY (OrderID, ItemID)
)
ALTER TABLE OrderItems 
	ADD FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
ALTER TABLE OrderItems
	ADD FOREIGN KEY (ItemID) REFERENCES Items(ItemID)


-- Problem 6
CREATE DATABASE University 
USE University
DROP DATABASE University 

CREATE TABLE Majors
(
	MajorID INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(30) NOT NULL,
)
CREATE TABLE Students
(
	StudentID INT NOT NULL PRIMARY KEY,
	StudentNumber INT NOT NULL,
	StudentName VARCHAR(30),
	MajorID INT NOT NULL
)
ALTER TABLE Students
	ADD FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)

CREATE TABLE Payments
(
	PaymetID INT NOT NULL PRIMARY KEY,
	PaymentDate DATE NOT NULL,
	PaymentAmaout DECIMAL,
	StudentID INT NOT NULL,
	FOREIGN KEY (StudentID) REFERENCES Students (StudentID)
)
CREATE TABLE Subjects
(
	SubjectID INT NOT NULL PRIMARY KEY,
	SubjectName INT NOT NULL,
)
CREATE TABLE Agenda
(
	StudentID INT NOT NULL,
	SubjectID INT NOT NULL,
	PRIMARY KEY (StudentID, SubjectID)
)
ALTER TABLE Agenda
	ADD FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
ALTER TABLE Agenda
	ADD FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
