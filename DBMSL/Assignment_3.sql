-- DBSML ASSIGNMENT 3
USE dbmsl_schema;

-- 1. Which institute libraries are located in Pune city?
SELECT LibraryName, City
FROM INSTITUTELIBRARY
WHERE City = 'Pune';

-- 2. To which institute CS department belongs to?
SELECT DepartmentName, InstituteName
FROM DEPARTMENT
WHERE DepartmentName = 'Civil';

-- 3. Find all the books whose price is between 800 to 12000?
SELECT BookName, Price
FROM BOOKS
WHERE Price BETWEEN 800 AND 12000;

-- 4. Find out such employees whose salaries are not greater than 50,000/-
SELECT EmployeeName, Salary
FROM EMPLOYEE
WHERE Salary <= 50000;

-- 5. Find out such sellers whose name ends with “ta”
SELECT SellerName
FROM SELLER
WHERE SellerName LIKE '%ta';

-- 6. Find out such institute libraries where their area information is missing.
SELECT LibraryName, City
FROM INSTITUTELIBRARY
WHERE Area IS NULL;

-- 7. Find out such staff members whose name doesn’t start with “A”
SELECT StaffName
FROM STAFF
WHERE StaffName NOT LIKE 'A%';

-- 8. Find out such SIU libraries which have institute libraries located in Bangalore.
SELECT SIULibraryID, LibraryName
FROM SIULIBRARY
WHERE SIULibraryID IN (
    SELECT SIULibraryID
    FROM INSTITUTELIBRARY
    WHERE City = 'Bangalore'
);

-- 9. Which students belong to the civil department?
SELECT StudentName, DepartmentID
FROM STUDENT
WHERE DepartmentID = (SELECT DepartmentID FROM DEPARTMENT WHERE DepartmentName = 'Civil');

-- 10. Find out books which are written by “Shruti” and published by Mcgraw Hill.
SELECT B.BookName
FROM BOOKS B
JOIN WRITES W ON B.BookID = W.BookID
JOIN AUTHOR A ON W.AuthorID = A.AuthorID
JOIN PUBLISHER P ON W.PublisherID = P.PublisherID
WHERE A.AuthorName = 'Shruti' AND P.PublisherName = 'Tata Macgraw hill';
