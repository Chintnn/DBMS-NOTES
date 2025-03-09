-- DBMSL ASSIGNMENT 4
USE dbmsl_schema;

-- 1. Find the cheapest book of SIBM library.
-- We will use the MIN function to find the book with the least price in the SIBM library (InstituteLibraryID = 2)
SELECT BookName, MIN(Price) AS CheapestBookPrice
FROM BOOKS
WHERE InstituteLibraryID = 2
GROUP BY BookName;

-- 2. Which library has the costliest book?
-- We will use the MAX function to find the library with the highest book price.
SELECT InstituteLibraryID, LibraryName, MAX(Price) AS CostliestBookPrice
FROM BOOKS
JOIN INSTITUTELIBRARY ON BOOKS.InstituteLibraryID = INSTITUTELIBRARY.InstituteLibraryID
GROUP BY InstituteLibraryID;

-- 3. How many students from SIT issued the book?
-- We will count the number of students from SIT (InstituteLibraryID = 1) who have issued books.
SELECT COUNT(DISTINCT STUDENT.StudentID) AS StudentsIssuedBooks
FROM ISSUE
JOIN MEMBER ON ISSUE.MemberID = MEMBER.MemberID
JOIN STUDENT ON MEMBER.MemberID = STUDENT.MemberID
WHERE MEMBER.InstituteLibraryID = 1;

-- 4. What is the average cost of books in SITMN library?
-- We will calculate the average price of books in the SITMN library (InstituteLibraryID = 8).
SELECT AVG(Price) AS AverageCost
FROM BOOKS
WHERE InstituteLibraryID = 8;

-- 5. What is the total cost of purchase made by SIT in the month of January to June?
-- We will sum the total purchase cost made by SIT (InstituteLibraryID = 1) from January to June (2015).
SELECT SUM(TotalCost) AS TotalPurchaseCost
FROM PURCHASE
WHERE InstituteLibraryID = 1 AND MONTH(Date) BETWEEN 1 AND 6 AND YEAR(Date) = 2015;

-- 6. How many books are written by “Shruti”?
-- We will count how many books are written by author "Shruti" (AuthorName = 'Shruti').
SELECT COUNT(DISTINCT BOOKS.BookID) AS BooksByShruti
FROM WRITES
JOIN AUTHOR ON WRITES.AuthorID = AUTHOR.AuthorID
JOIN BOOKS ON WRITES.BookID = BOOKS.BookID
WHERE AUTHOR.AuthorName = 'Shruti';

-- 7. What is the costliest book published by “Pragati Book Store”?
-- We will find the book with the highest price published by "Pragati Book Store".
SELECT BookName, MAX(Price) AS CostliestBookPrice
FROM BOOKS
JOIN WRITES ON BOOKS.BookID = WRITES.BookID
JOIN PUBLISHER ON WRITES.PublisherID = PUBLISHER.PublisherID
WHERE PUBLISHER.PublisherName = 'Pragati book store'
GROUP BY BookName;

-- 8. How many total copies of books do SIT have?
-- We will sum the number of copies of books in the SIT library (InstituteLibraryID = 1).
SELECT SUM(NoOfCopies.BookNumberID) AS TotalCopies
FROM NOOFCOPIES
JOIN BOOKS ON NOOFCOPIES.BookID = BOOKS.BookID
WHERE BOOKS.InstituteLibraryID = 1;

-- 9. What is the average cost of books written by “Shivam Kapoor”?
-- We will calculate the average price of books written by "Shivam Kapoor".
SELECT AVG(Price) AS AverageCost
FROM BOOKS
JOIN WRITES ON BOOKS.BookID = WRITES.BookID
JOIN AUTHOR ON WRITES.AuthorID = AUTHOR.AuthorID
WHERE AUTHOR.AuthorName = 'Shivam Kapoor';

-- 10. How many books are sold by the seller living in Pune?
-- We will count the number of books sold by sellers located in Pune.
SELECT COUNT(DISTINCT SELLS.BookID) AS BooksSoldByPuneSellers
FROM SELLS
JOIN SELLER ON SELLS.SellerID = SELLER.SellerID
WHERE SELLER.City = 'Pune';

-- 11. Print the student name in capital who belongs to SSBS
-- We will select the student names in uppercase from the SSBS library (InstituteLibraryID = 10).
SELECT UPPER(StudentName) AS StudentName
FROM STUDENT
JOIN MEMBER ON STUDENT.MemberID = MEMBER.MemberID
WHERE MEMBER.InstituteLibraryID = 10;

-- 12. Add two months to the issue date of a book written by “Shivam Kapoor”
-- We will use the DATE_ADD function to add two months to the issue date for books written by "Shivam Kapoor".
SELECT IssueID, DATE_ADD(IssueDate, INTERVAL 2 MONTH) AS UpdatedIssueDate
FROM ISSUE
JOIN BOOKS ON ISSUE.BookID = BOOKS.BookID
JOIN WRITES ON BOOKS.BookID = WRITES.BookID
JOIN AUTHOR ON WRITES.AuthorID = AUTHOR.AuthorID
WHERE AUTHOR.AuthorName = 'Shivam Kapoor';

-- 13. What was the last day of the month when Satish issued the book?
-- We will find the last day of the month for the book issued by "Satish".
SELECT LAST_DAY(IssueDate) AS LastDayOfMonth
FROM ISSUE
JOIN MEMBER ON ISSUE.MemberID = MEMBER.MemberID
JOIN STUDENT ON MEMBER.MemberID = STUDENT.MemberID
WHERE STUDENT.StudentName = 'Satish';

-- 14. How many books were issued from January to March 2010 & 2020?
-- We will count the number of books issued in the months of January to March for the years 2010 and 2020.
SELECT COUNT(DISTINCT IssueID) AS BooksIssuedInFirstQuarter
FROM ISSUE
WHERE (YEAR(IssueDate) = 2010 OR YEAR(IssueDate) = 2020)
AND MONTH(IssueDate) BETWEEN 1 AND 3;

-- 15. How many books have copies less than 5 available in the SIBM library?
-- We will count the number of books that have less than 5 copies available in the SIBM library (InstituteLibraryID = 2).
SELECT COUNT(DISTINCT NOOFCOPIES.BookID) AS BooksWithLessThan5Copies
FROM NOOFCOPIES
JOIN BOOKS ON NOOFCOPIES.BookID = BOOKS.BookID
WHERE BOOKS.InstituteLibraryID = 2
GROUP BY NOOFCOPIES.BookID
HAVING COUNT(NOOFCOPIES.BookNumberID) < 5;





-- Explanation:
-- 1. MIN/AVG/MAX: Used to calculate the minimum, maximum, or average values for a specified column (e.g., book price or total cost).
-- 2. COUNT: Used to count distinct or total entries that match the condition (e.g., counting students or books).
-- 3. DATE_ADD: Used to add a specified time interval (like 2 months) to a date column.
-- 4. UPPER: Converts the student name to uppercase.
-- 5. LAST_DAY: Returns the last day of the month for a given date.
-- 6. GROUP BY: Used to group rows that have the same values in specified columns (e.g., counting the number of books by author).