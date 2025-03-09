-- DBMSL ASSIGNMENT 5
USE dbmsl_schema;

-- 1. Give library wise book details.
-- This query groups books by library and lists their details.
SELECT InstituteLibraryID, BookID, BookName, Price
FROM BOOKS
GROUP BY InstituteLibraryID, BookID, BookName, Price
ORDER BY InstituteLibraryID;

-- 2. Give bookwise total copies which are available.
-- This query groups books and gives the total number of available copies for each book.
SELECT BookID, SUM(NoOfCopies.BookNumberID) AS TotalCopiesAvailable
FROM NOOFCOPIES
JOIN BOOKS ON NOOFCOPIES.BookID = BOOKS.BookID
GROUP BY BookID
ORDER BY BookID;

-- 3. Which library has total copies more than 5?
-- This query uses HAVING to filter libraries that have total copies of books greater than 5.
SELECT InstituteLibraryID, SUM(NoOfCopies.BookNumberID) AS TotalCopies
FROM NOOFCOPIES
JOIN BOOKS ON NOOFCOPIES.BookID = BOOKS.BookID
GROUP BY InstituteLibraryID
HAVING SUM(NoOfCopies.BookNumberID) > 5
ORDER BY TotalCopies DESC;

-- 4. Give institute wise department details.
-- This query groups departments by institute and provides details of each department.
SELECT InstituteLibraryID, DepartmentName, DepartmentHead
FROM DEPARTMENT
GROUP BY InstituteLibraryID, DepartmentName, DepartmentHead
ORDER BY InstituteLibraryID;

-- 5. Give citywise seller details.
-- This query groups sellers by their city and lists the seller details.
SELECT City, SellerID, SellerName, ContactInfo
FROM SELLER
GROUP BY City, SellerID, SellerName, ContactInfo
ORDER BY City;

-- 6. Give author wise book details that have authored more than 2 books.
-- This query uses HAVING to filter authors who have written more than 2 books and provides their book details.
SELECT AUTHOR.AuthorName, BOOKS.BookID, BOOKS.BookName, BOOKS.Price
FROM AUTHOR
JOIN WRITES ON AUTHOR.AuthorID = WRITES.AuthorID
JOIN BOOKS ON WRITES.BookID = BOOKS.BookID
GROUP BY AUTHOR.AuthorName, BOOKS.BookID, BOOKS.BookName, BOOKS.Price
HAVING COUNT(BOOKS.BookID) > 2
ORDER BY AUTHOR.AuthorName;

-- 7. Give book details library wise whose price is less than 1000.
-- This query groups books by library and lists the books with a price of less than 1000.
SELECT InstituteLibraryID, BookID, BookName, Price
FROM BOOKS
WHERE Price < 1000
GROUP BY InstituteLibraryID, BookID, BookName, Price
ORDER BY InstituteLibraryID;

-- 8. Give department wise staff details.
-- This query groups staff members by their department and lists their details.
SELECT DepartmentID, StaffID, StaffName, StaffRole
FROM STAFF
GROUP BY DepartmentID, StaffID, StaffName, StaffRole
ORDER BY DepartmentID;

-- 9. How many books are issued library wise.
-- This query counts the number of books issued per library using GROUP BY.
SELECT InstituteLibraryID, COUNT(DISTINCT ISSUE.BookID) AS BooksIssued
FROM ISSUE
JOIN BOOKS ON ISSUE.BookID = BOOKS.BookID
GROUP BY InstituteLibraryID
ORDER BY InstituteLibraryID;

-- 10. Give purchase details publisher wise.
-- This query groups the purchase details by publisher and lists the total cost of purchases made.
SELECT PUBLISHER.PublisherName, SUM(PURCHASE.TotalCost) AS TotalPurchaseCost
FROM PURCHASE
JOIN PUBLISHER ON PURCHASE.PublisherID = PUBLISHER.PublisherID
GROUP BY PUBLISHER.PublisherName
ORDER BY TotalPurchaseCost DESC;

-- 11. Display books in a descending order of their cost.
-- This query sorts the books based on their price in descending order.
SELECT BookID, BookName, Price
FROM BOOKS
ORDER BY Price DESC;





-- Explanation:
-- 1. GROUP BY: This clause groups rows based on specified columns. It allows us to perform aggregate functions (e.g., COUNT(), SUM(), etc.) on groups of data, such as counting the total books issued or summing the number of copies.
-- 2. HAVING: This is used to filter results after GROUP BY aggregation. For example, in query 6, we use HAVING COUNT(BOOKS.BookID) > 2 to get authors who have written more than 2 books.
-- 3. ORDER BY: This clause orders the results based on one or more columns. For example, query 10 orders the purchase totals by publisher in descending order.
-- 4. Nested Queries: Some queries could require joining multiple tables and nested queries to get specific results (e.g., in query 9 to count books issued for each library).