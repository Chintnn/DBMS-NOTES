-- SIU LIBRARY MANAGEMENT SYSTEM

-- SIULIBRARY Table
CREATE TABLE SIULIBRARY (
    SIULibraryID NUMBER PRIMARY KEY,
    LibraryName VARCHAR2(255) NOT NULL, 
    Location VARCHAR2(255),
    NoOfBranches NUMBER CHECK (NoOfBranches >= 0)
);

-- INSTITUTELIBRARY Table
CREATE TABLE INSTITUTELIBRARY (
    InstituteLibraryID NUMBER PRIMARY KEY,
    LibraryName VARCHAR2(255) NOT NULL,
    City VARCHAR2(255),
    Area VARCHAR2(255),
    SIULibraryID NUMBER,
    CONSTRAINT fk_InstituteLibrary_SIULibrary FOREIGN KEY (SIULibraryID) REFERENCES SIULIBRARY(SIULibraryID)
);

-- BOOKS Table
CREATE TABLE BOOKS (
    BookID NUMBER PRIMARY KEY,
    BookName VARCHAR2(255) NOT NULL,
    Price NUMBER(10, 2) CHECK (Price >= 0),
    InstituteLibraryID NUMBER,
    CONSTRAINT fk_Books_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- NOOFCOPIES Table
CREATE TABLE NOOFCOPIES (
    BookNumberID NUMBER PRIMARY KEY,
    BookID NUMBER,
    InstituteLibraryID NUMBER,
    CONSTRAINT fk_NoOfCopies_Book FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    CONSTRAINT fk_NoOfCopies_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- AUTHOR Table
CREATE TABLE AUTHOR (
    AuthorID NUMBER PRIMARY KEY,
    AuthorName VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE,
    PhoneNo VARCHAR2(15)
);

-- PUBLISHER Table
CREATE TABLE PUBLISHER (
    PublisherID NUMBER PRIMARY KEY,
    PublisherName VARCHAR2(255) NOT NULL
);

-- WRITES Table
CREATE TABLE WRITES (
    BookID NUMBER,
    AuthorID NUMBER,
    PublisherID NUMBER,
    PRIMARY KEY (BookID, AuthorID, PublisherID),
    CONSTRAINT fk_Writes_Book FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    CONSTRAINT fk_Writes_Author FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID),
    CONSTRAINT fk_Writes_Publisher FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID)
);

-- SELLER Table
CREATE TABLE SELLER (
    SellerID NUMBER PRIMARY KEY,
    SellerName VARCHAR2(255) NOT NULL,
    City VARCHAR2(255)
);

-- DEPARTMENT Table
CREATE TABLE DEPARTMENT (
    DepartmentID NUMBER PRIMARY KEY,
    DepartmentName VARCHAR2(255) NOT NULL,
    InstituteName VARCHAR2(255),
    InstituteLibraryID NUMBER,
    CONSTRAINT fk_Department_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- MEMBER Table
CREATE TABLE MEMBER (
    MemberID NUMBER PRIMARY KEY,
    InstituteLibraryID NUMBER,
    CONSTRAINT fk_Member_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- STUDENT Table
CREATE TABLE STUDENT (
    StudentID NUMBER PRIMARY KEY,
    StudentName VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE,
    MemberID NUMBER,
    DepartmentID NUMBER,
    CONSTRAINT fk_Student_Member FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID),
    CONSTRAINT fk_Student_Department FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID)
);

-- STAFF Table
CREATE TABLE STAFF (
    StaffID NUMBER PRIMARY KEY,
    StaffName VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE,
    DepartmentID NUMBER,
    MemberID NUMBER,
    CONSTRAINT fk_Staff_Department FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID),
    CONSTRAINT fk_Staff_Member FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
);

-- PURCHASE Table
CREATE TABLE PURCHASE (
    PurchaseID NUMBER PRIMARY KEY,
    InstituteLibraryID NUMBER,
    SellerID NUMBER,
    PublisherID NUMBER,
    BookID NUMBER,
    Quantity NUMBER CHECK (Quantity > 0),
    PurchaseDate DATE,
    TotalCost NUMBER(10, 2) CHECK (TotalCost >= 0),
    CONSTRAINT fk_Purchase_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID),
    CONSTRAINT fk_Purchase_Seller FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    CONSTRAINT fk_Purchase_Publisher FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID),
    CONSTRAINT fk_Purchase_Book FOREIGN KEY (BookID) REFERENCES BOOKS(BookID)
);

-- ISSUE Table
CREATE TABLE ISSUE (
    IssueID NUMBER PRIMARY KEY,
    MemberID NUMBER,
    BookID NUMBER,
    BookNumberID NUMBER,
    InstituteLibraryID NUMBER,
    IssueDate DATE,
    ReturnDate DATE,
    CONSTRAINT fk_Issue_Member FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID),
    CONSTRAINT fk_Issue_Book FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    CONSTRAINT fk_Issue_BookNumber FOREIGN KEY (BookNumberID) REFERENCES NOOFCOPIES(BookNumberID),
    CONSTRAINT fk_Issue_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- SELLS Table
CREATE TABLE SELLS (
    SellerID NUMBER,
    BookID NUMBER,
    PublisherID NUMBER,
    PRIMARY KEY (SellerID, BookID, PublisherID),
    CONSTRAINT fk_Sells_Seller FOREIGN KEY (SellerID) REFERENCES SELLER(SellerID),
    CONSTRAINT fk_Sells_Book FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    CONSTRAINT fk_Sells_Publisher FOREIGN KEY (PublisherID) REFERENCES PUBLISHER(PublisherID)
);

-- EMPLOYEE Table
CREATE TABLE EMPLOYEE (
    EmployeeID NUMBER PRIMARY KEY,
    EmployeeName VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE,
    Salary NUMBER(10, 2) CHECK (Salary >= 0),
    InstituteLibraryID NUMBER,
    CONSTRAINT fk_Employee_InstituteLibrary FOREIGN KEY (InstituteLibraryID) REFERENCES INSTITUTELIBRARY(InstituteLibraryID)
);

-- AUTHORSPECIALIZATION Table
CREATE TABLE AUTHORSPECIALIZATION (
    SpecializationID NUMBER PRIMARY KEY,
    SpecializationName VARCHAR2(255) NOT NULL,
    AuthorID NUMBER,
    CONSTRAINT fk_AuthorSpecialization_Author FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID)
);

-- Copy insert values from main data file 
-- and adjust for syntax in purchase and issue tables with date error