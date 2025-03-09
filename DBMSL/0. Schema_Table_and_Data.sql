-- SIU LIBRARY MANAGEMENT SYSTEM

-- Create Schema
CREATE SCHEMA DBMSL_SCHEMA;
USE DBMSL_SCHEMA;

-- SIULIBRARY Table
CREATE TABLE SIULIBRARY (
    SIULibraryID INT PRIMARY KEY, -- Primary Key
    LibraryName VARCHAR(255) NOT NULL, 
    Location VARCHAR(255),
    NoOfBranches INT CHECK (NoOfBranches >= 0) -- Must be non-negative
);

-- INSTITUTELIBRARY Table
CREATE TABLE INSTITUTELIBRARY (
    InstituteLibraryID INT PRIMARY KEY, -- Primary Key
    LibraryName VARCHAR(255) NOT NULL,
    City VARCHAR(255),
    Area VARCHAR(255),
    SIULibraryID INT, -- Foreign Key referencing SIULIBRARY
    FOREIGN KEY (SIULibraryID) REFERENCES SIULIBRARY(SIULibraryID)
);

-- BOOKS Table
CREATE TABLE BOOKS (
    BookID INT PRIMARY KEY, -- Primary Key
    BookName VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) CHECK (Price >= 0), -- Non-negative price
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- NOOFCOPIES Table
CREATE TABLE NOOFCOPIES (
    BookNumberID INT PRIMARY KEY, -- Primary Key
    BookID INT, -- Foreign Key referencing BOOKS
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- AUTHOR Table

CREATE TABLE AUTHOR (
    AuthorID INT PRIMARY KEY, -- Primary Key
    AuthorName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE, -- Unique email
    PhoneNo VARCHAR(15)
);

-- WRITES Table
CREATE TABLE WRITES (
    BookID INT, -- Foreign Key referencing BOOKS
    AuthorID INT, -- Foreign Key referencing AUTHOR
    PublisherID INT, -- Foreign Key referencing PUBLISHER
    PRIMARY KEY (BookID, AuthorID, PublisherID), -- Composite Primary Key
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID),
    FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID)
);

-- PUBLISHER Table
CREATE TABLE PUBLISHER (
    PublisherID INT PRIMARY KEY, -- Primary Key
    PublisherName VARCHAR(255) NOT NULL
);

-- SELLER Table
CREATE TABLE SELLER (
    SellerID INT PRIMARY KEY, -- Primary Key
    SellerName VARCHAR(255) NOT NULL,
    City VARCHAR(255)
);

-- DEPARTMENT Table
CREATE TABLE DEPARTMENT (
    DepartmentID INT PRIMARY KEY, -- Primary Key
    DepartmentName VARCHAR(255) NOT NULL,
    InstituteName VARCHAR(255), -- Institute name
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- MEMBER Table
CREATE TABLE MEMBER (
    MemberID INT PRIMARY KEY, -- Primary Key
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- STUDENT Table
CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY, -- Primary Key
    StudentName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE, -- Unique email
    MemberID INT, -- Foreign Key referencing MEMBER
    DepartmentID INT, -- Foreign Key referencing DEPARTMENT
    FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID),
    FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID)
);

-- STAFF Table
CREATE TABLE STAFF (
    StaffID INT PRIMARY KEY, -- Primary Key
    StaffName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE, -- Unique email
    DepartmentID INT, -- Foreign Key referencing DEPARTMENT
    MemberID INT, -- Foreign Key referencing MEMBER
    FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID),
    FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
);

-- PURCHASE Table
CREATE TABLE PURCHASE (
    PurchaseID INT PRIMARY KEY, -- Primary Key
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    SellerID INT, -- Foreign Key referencing SELLER
    PublisherID INT, -- Foreign Key referencing PUBLISHER
    BookID INT, -- Foreign Key referencing BOOKS
    Quantity INT CHECK (Quantity > 0), -- Must be positive
    Date DATE,
    TotalCost DECIMAL(10, 2) CHECK (TotalCost >= 0), -- Non-negative cost
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID),
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID),
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID)
);

-- ISSUE Table
CREATE TABLE ISSUE (
    Issueid INT PRIMARY KEY, -- Primary Key
    MemberID INT, -- Foreign Key referencing MEMBER
    BookID INT, -- Foreign Key referencing BOOKS
    BookNumberID INT, -- Foreign Key referencing NOOFCOPIES
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    IssueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID),
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    FOREIGN KEY (BookNumberID) REFERENCES NOOFCOPIES(BookNumberID),
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- SELLS Table
CREATE TABLE SELLS (
    SellerID INT, -- Foreign Key referencing SELLER
    BookID INT, -- Foreign Key referencing BOOKS
    PublisherID INT, -- Foreign Key referencing PUBLISHER
    PRIMARY KEY (SellerID, BookID, PublisherID),
    FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID)
);

-- EMPLOYEE Table
CREATE TABLE EMPLOYEE (
    EmployeeID INT PRIMARY KEY, -- Primary Key
    EmployeeName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE, -- Unique email
    Salary DECIMAL(10, 2) CHECK (Salary >= 0), -- Non-negative salary
    InstituteLibraryID INT, -- Foreign Key referencing INSTITUTELIBRARY
    FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- AUTHORSPECIALIZATION Table
CREATE TABLE AUTHORSPECIALIZATION (
    SpecializationID INT PRIMARY KEY, -- Primary Key
    SpecializationName VARCHAR(255) NOT NULL,
    AuthorID INT, -- Foreign Key referencing AUTHOR
    FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID)
);





-- SIULIBRARY Table
INSERT INTO SIULIBRARY (SIULibraryID, LibraryName, Location, NoOfBranches) VALUES
(1, 'Pune Central Library', 'Pune', 10);

-- INSTITUTELIBRARY Table
INSERT INTO INSTITUTELIBRARY (InstituteLibraryID, LibraryName, City, Area, SIULibraryID) VALUES
(1, 'SITLib', 'Pune', 'Lavale', 1),
(2, 'SIBMLib', 'Pune', 'Lavale', 1),
(3, 'SSACLib', 'Nagpur', 'Ramnagar', 1),
(4, 'SSLALib', 'Pune', 'Vimannagar', 1),
(5, 'SIBMBLib', 'Bangalore', 'Jaynagar', 1),
(6, 'SITMHLib', 'Hyderabad', 'Banjara hills', 1),
(7, 'SIOMLib', 'Pune', 'S.B.Road', 1),
(8, 'SITMNLib', 'Noida', 'Golf course area', 1),
(9, 'SSLAHLib', 'Hyderabad', 'Gacchibowli', 1),
(10, 'SSBSLib', 'Pune', 'Tithnagar', 1);

-- BOOKS Table
INSERT INTO BOOKS (BookID, BookName, Price, InstituteLibraryID) VALUES
(1, 'Operating System', 1000, 1),
(2, 'Management System', 2500, 2),
(3, 'Supply chain management', 500, 8),
(4, 'Bioinformatics', 780, 10),
(5, 'Tele informatics', 4567, 10),
(6, 'IP and Patents formation', 345, 4),
(7, 'Engineering Graphics', 2456, 1),
(8, 'Customer Management', 3467, 5),
(9, 'Buying Pattern Analysis', 456, 8),
(10, 'Digital Finance', 600, 8),
(11, 'Telecommunication', 1500, 6),
(12, 'Algorithms', 6754, 1),
(13, 'Child Law', 1800, 4),
(14, 'Multimanagers', 2345, 2),
(15, 'MicroEconomics', 267, 5),
(16, 'Electronics', 2341, 1),
(17, 'Structure foundations', 1700, 3),
(18, 'Ecohomes', 1234, 3),
(19, 'Mobile Communication', 456, 6),
(20, 'Labor Laws', 3452, 9),
(21, 'Copyrights', 2789, 9),
(22, 'Research Laws', 1100, 9),
(23, 'DBMS', 700, 1),
(24, 'Computer networks', 3451, 1);

-- NOOFCOPIES Table
INSERT INTO NOOFCOPIES (BookNumberID, BookID, InstituteLibraryID) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 3, 1),
(5, 3, 2),
(6, 3, 3),
(7, 2, 1),
(8, 2, 2),
(9, 4, 1),
(10, 4, 2),
(11, 4, 3),
(12, 5, 1),
(13, 5, 2),
(14, 6, 1),
(15, 7, 1),
(16, 8, 1),
(17, 8, 2),
(18, 9, 1),
(19, 10, 1),
(20, 11, 1),
(21, 12, 1),
(22, 12, 2),
(23, 13, 1),
(24, 13, 2),
(25, 14, 1),
(26, 14, 2),
(27, 14, 4),
(28, 15, 1),
(29, 15, 2),
(30, 16, 1),
(31, 16, 2),
(32, 17, 1);

-- AUTHOR Table
INSERT INTO AUTHOR (AuthorID, AuthorName, Email, PhoneNo) VALUES
(1, 'Shruti', 'abc@gmail.com', '6447896542'),
(2, 'Shivam Kapoor', 'adf@gmail.com', '2345778998'),
(3, 'Ameya', 'ert@gmail.com', '23456789087'),
(4, 'Pooja Pai', 'edr@gamil.com', '32554565678'),
(5, 'Brian Kernighan', 'rtyu@gmail.com', '2143454657'),
(6, 'Ken Thompson', 'errt@gmail.com', '2343454565');

-- PUBLISHER Table
INSERT INTO PUBLISHER (PublisherID, PublisherName) VALUES
(1, 'Tata Macgraw hill'),
(2, 'Pragati book store'),
(3, 'Prentice Hall'),
(4, 'oReilly'),
(5, 'Emrald publishing');

-- WRITES Table
INSERT INTO WRITES (BookID, AuthorID, PublisherID) VALUES
(1, 1, 2),
(2, 2, 3),
(3, 5, 2),
(4, 6, 4),
(5, 1, 5),
(6, 1, 2),
(7, 4, 1),
(8, 2, 2),
(9, 5, 5),
(10, 6, 4),
(11, 1, 1),
(12, 4, 2),
(13, 5, 5),
(14, 6, 2),
(15, 3, 1),
(16, 4, 2),
(17, 6, 5),
(18, 2, 4),
(19, 5, 1),
(20, 1, 2),
(21, 3, 5),
(22, 5, 2),
(23, 6, 1),
(24, 3, 3);

-- SELLER Table
INSERT INTO SELLER (SellerID, SellerName, City) VALUES
(1, 'Kohinoor', 'Pune'),
(2, 'Shiksha', 'Pune'),
(3, 'ABP', 'Noida'),
(4, 'Technical', 'Hyderabad'),
(5, 'Timenowta', 'Bangalore'),
(6, 'Kirti', 'Pune');

-- DEPARTMENT Table
INSERT INTO DEPARTMENT (DepartmentID, DepartmentName, InstituteName, InstituteLibraryID) VALUES
(1, 'Civil', 'SIT', 1),
(2, 'E&TC', 'SIT', 1),
(3, 'Biology', 'SSBS', 10),
(4, 'Law', 'SSLA', 4),
(5, 'Structure', 'SSAC', 3),
(6, 'Finance management', 'SIBM', 2),
(7, 'Digital Telecommunications', 'SITMH', 6),
(8, 'Clinical Research', 'SSBS', 10);

-- MEMBER Table
INSERT INTO MEMBER (MemberID, InstituteLibraryID) VALUES
(1, 1),
(16, 1),
(13, 1),
(44, 1),
(35, 1),
(26, 10),
(45, 1),
(23, 10),
(12, 3),
(78, 1),
(49, 4),
(50, 1);

-- STUDENT Table
INSERT INTO STUDENT (StudentID, StudentName, Email, MemberID, DepartmentID) VALUES
(1, 'Pooja', 'aswq@gmail.com', 1, 1),
(2, 'Satish', 'azsx@gmail.com', 16, 1),
(3, 'Amar', 'cvnn@gmail.com', 13, 2),
(4, 'Meera', 'lkio@gmail.com', 44, 2),
(5, 'Ravi', 'fghj@gmail.com', 35, 2),
(6, 'Adit', 'cfgb@gmail.com', 26, 3);

-- STAFF Table
INSERT INTO STAFF (StaffID, StaffName, Email, MemberID, DepartmentID) VALUES
(1, 'Satish', 'sddf@gmail.com', 45, 1),
(2, 'Rachit', 'zxzxc@gmail.com', 23, 3),
(3, 'Seema', 'lkklk@gmail.com', 12, 5),
(4, 'Sayali', 'xzcxc@gmail.com', 78, 2),
(5, 'Aditya', 'cvvcb@gmail.com', 49, 4),
(6, 'Archit', 'gfdfg@gmail.com', 50, 1);

-- PURCHASE Table
INSERT INTO PURCHASE (PurchaseID, InstituteLibraryID, SellerID, PublisherID, BookID, Quantity, Date, TotalCost) VALUES
(1001, 1, 1, 3, 1, 100, '2015-07-12', 70000),
(1002, 2, 3, 4, 2, 1000, '2015-04-10', 80000),
(1003, 1, 4, 2, 5, 45, '2016-08-01', 4500),
(1004, 4, 1, 5, 6, 34, '2016-02-06', 23000),
(1005, 3, 4, 1, 9, 20, '2017-03-15', 1200),
(1006, 1, 2, 4, 10, 89, '2017-04-20', 4500),
(1007, 2, 5, 2, 12, 67, '2018-07-25', 5600),
(1008, 3, 2, 4, 15, 45, '2018-03-27', 50000),
(1009, 4, 3, 1, 16, 340, '2019-02-12', 7800),
(1010, 1, 1, 2, 17, 23, '2020-07-11', 10000);

-- ISSUE Table
INSERT INTO ISSUE (IssueID, MemberID, BookID, BookNumberID, InstituteLibraryID, IssueDate, ReturnDate) VALUES
(205, 44, 2, 1, 2, '2020-03-12', '2020-04-12'),
(206, 12, 7, 1, 1, '2020-05-10', NULL),
(207, 78, 4, 3, 10, '2019-03-05', '2019-08-05'),
(208, 13, 10, 1, 8, '2019-04-09', '2019-06-09'),
(209, 35, 12, 2, 1, '2020-10-07', '2020-12-07'),
(210, 45, 2, 2, 2, '2020-04-06', NULL);

-- SELLS Table
INSERT INTO SELLS (SellerID, BookID, PublisherID) VALUES
(1, 1, 2),
(5, 3, 2),
(3, 2, 3),
(2, 6, 5),
(1, 10, 5),
(4, 14, 1);

-- EMPLOYEE Table
INSERT INTO EMPLOYEE (EmployeeID, EmployeeName, Email, Salary, InstituteLibraryID) VALUES
(111, 'Shilpa', 'sdfdsf@gmail.com', 10000, 1),
(222, 'Shivani', 'sadsf@gmail.com', 20000, 1),
(333, 'Hemani', 'ertet@gmail.com', 500000, 2),
(444, 'Rekha', 'scdsf@gmail.com', 35000, 3),
(555, 'Anil', 'asd@gmail.com', 45000, 5),
(666, 'Suhas', 'fdgfg@gmail.com', 20000, 2);

-- AUTHORSPECIALIZATION Table
INSERT INTO AUTHORSPECIALIZATION (SpecializationID, AuthorID, SpecializationName) VALUES
(101, 1, 'Technical'),
(201, 1, 'Fiction'),
(301, 2, 'Non_Fiction'),
(401, 3, 'Autobiographies'),
(501, 2, 'Technical'),
(601, 4, 'Real life stories');

