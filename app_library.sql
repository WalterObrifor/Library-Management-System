-- THIS ANALYSIS GOES FROM BEGINNER TO ADVANACE (ADVANCE STARTS FROM TASK 12)

-- Library System Management SQL Project

-- CREATE DATABASE library;

-- Create a table called "Branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY, -- column header
            manager_id VARCHAR(10),            -- column header
            branch_address VARCHAR(30),        -- column header
            contact_no VARCHAR(15)             -- column header
);
SELECT * FROM branch;



-- Create a table called "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,      -- column header
            emp_name VARCHAR(30),                -- column header
            position VARCHAR(30),                -- column header
            salary DECIMAL(10,2),                -- column header
            branch_id VARCHAR(10),               -- column header
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);
SELECT * FROM employees;



-- Create a table called "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,      -- column header
            member_name VARCHAR(30),                -- column header
            member_address VARCHAR(30),             -- column header
            reg_date DATE                           -- column header
);
SELECT * FROM members;



-- Create a table called "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,      -- column header
            book_title VARCHAR(80),            -- column header
            category VARCHAR(30),              -- column header
            rental_price DECIMAL(10,2),        -- column header
            status VARCHAR(10),                -- column header
            author VARCHAR(30),                -- column header
            publisher VARCHAR(30)              -- column header
);
SELECT * FROM books;



-- Create a table called "Issue_Status"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,      -- column header
            issued_member_id VARCHAR(30),           -- column header
            issued_book_name VARCHAR(80),           -- column header 
            issued_date DATE,                       -- column header
            issued_book_isbn VARCHAR(50),           -- column header
            issued_emp_id VARCHAR(10),              -- column header
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);
SELECT * FROM issued_status;



-- Create a table called "Return_Status"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,            -- column header
            issued_id VARCHAR(30),                        -- column header
            return_book_name VARCHAR(80),                 -- column header
            return_date DATE,                             -- column header
            return_book_isbn VARCHAR(50),                 -- column header
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
SELECT * FROM return_status;




-- Project TASK1
-- ### 2. CRUD Operations (Create, Update, and Delete)


-- Task 1. Create a New Record in the Book Table
-- ("978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

SELECT * FROM books;
insert into books (isbn, book_title, category, rental_price, status, author, publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co')


	
-- Task 2: Update an Existing Member's Address (changing the address of member_id 'C101' 
-- to '125 Main St')
SELECT * FROM members;
update members
set member_address = '125 Main St'
where member_id = 'C101';



-- Task 3: Delete a Record/Information from the Issued_Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.
SELECT * FROM issued_status;
delete from issued_status
where issued_id = 'IS104'



-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Retrieve all books/records issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
where issued_emp_id = 'E101';



-- Task 5: List Members Who Have Given Out More Than One Book
-- Objective: Use GROUP BY to find members who have issued out more than one book.
SELECT * FROM issued_status
SELECT 
	issued_emp_id,
	count(issued_id) as total_book_issued
FROM issued_status
group by issued_emp_id
having count (issued_id) > 1

-- to get only the columns 
SELECT 
	issued_emp_id
FROM issued_status
group by issued_emp_id
having count (issued_id) > 1



-- ### 3. CTAS (Create Table As Select)
-- Task 6: Create Summary Tables**: 
--Used CTAS to generate new tables to show the book name, book title, and total count of book_issued
SELECT * FROM issued_status;
SELECT * FROM books;

create table book_cnts
as
select 
	isbn,
	book_title,
	count(issued_id) as no_issued
from books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1

select *
from book_cnts;




-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:
select *
from books;

select 
	category,
	book_title,
	count(book_title) As no_book_title
from books
group by 1, 2

-- finding for a specific categories (Classic)
select 
	category, 
	book_title
from books
where category = 'Classic';



-- Task 8: Find Total Rental Income by Category:
select *
from books;

select 
	category, 
	sum (rental_price) as total_income,   -- this will create a new column called total_income, for the sum of rental prices
	count(*)
from books
group by 1;




-- Task 9. **List Members Who Registered in the Last 180 Days**:

select *
from members

-- using current date, we need to insert some records to meet up with last 180 days 
insert INTO members (member_id, member_name, member_address, reg_date)
values ('C122', 'Samuel', '148 Main St', '2025-05-01'),
		('C123', 'James', '136 Main St', '2025-05-01'),

select *
from members
where reg_date >= current_date - interval '180 days' 

 

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:

-- method 1
SELECT * FROM employees;

SELECT 
	emp_id,
	branch_id,
	emp_name,
	position
FROM employees
where position = 'Manager'  --- this will bring out all positions with manager role 
group by 1, 3


--method 2
select 
	*
from employees as e1
join					-- this function helps to join the employee's and branch tables together
branch as b
on b.branch_id = e1.branch_id -- using the branch id as their common column identifier
join               -- this will join the employees table and the combined table above 
employees as e2
on b.manager_id = e1.emp_id

--select only the columns that we want to display
select 
	e1.emp_id,
	b.branch_id,
	e2.emp_name,
	e2. position,
	e1. emp_name as Manager
from employees as e1
join
branch as b
on b.branch_id = e1.branch_id
join
employees as e2
on b.manager_id = e1.emp_id



-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 6USD

create table Books_Price_above7    ----creating a dataset for Books_Price_Above 7
as
select *
from books
where rental_price > 7



-- Task 12: Retrieve the List of Books Not Yet Returned
select * from issued_status
select * from return_status

select *
from issued_status as ist
left join
return_status as rs
on ist.issued_id = rs.issued_id
where rs.issued_id is null
    




--### Advanced SQL Operations

/* Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's name, book title, issue date, and days overdue.

we have many tables here(members, books, return_status, issued_status), so we need to do a multiple 
join 
*/

select * from books
select * from issued_status
select * from members
select * from employees
select * from return_status

-- issued_status == members == books == return_status
-- filter books which is over 60 days
-- overdue > 60

select 
	ist.issued_member_id,
	m.member_id,
	bk.book_title,
	ist.issued_date,
	rs.return_date,
	current_date - ist.issued_date as over_dues
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
left JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 60
ORDER BY 1




/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

-- method 1 (manually inputing records)
SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2';

SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

UPDATE books
SET status = 'yes' --- this will change the status from 'no' to 'yes'
WHERE isbn = '978-0-451-52994-2';

SELECT * FROM return_status
WHERE issued_id = 'IS130';

UPDATE return_status
SET return_book_name = 'yes' --- this will change the status from 'no' to 'yes'
WHERE return_id = 'RS125';

--
INSERT INTO return_status(return_id, issued_id, return_date, return_book_isbn)
VALUES
('RS125', 'IS130', CURRENT_DATE, 'Good');
SELECT * FROM return_status
WHERE issued_id = 'IS130';


--Method 2 (Store Procedures)
CREATE OR REPLACE PROCEDURE add_return_records (p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
/* When someone returns a book and runs the procedure "add_return_records". These are the parameters 
the receptionist would have to enter. "P_" represents Parameter. "add_return_records" is the name of the 
new record.
*/
LANGUAGE plpgsql  ---this is constant in postgreSQL. make sure its written
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into return table based on users input
    INSERT INTO return_status(return_id, issued_id, return_date,  book_quality)
    VALUES
    ('p_return_id VARCHAR(5)', 'p_issued_id VARCHAR(5)', current_date, p_book_quality);
	
    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO    -- we just need to save into one variable (v). variables are the text where we can store things
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$

--- call functions (inputed manually by library attendance)
call add_return_records ('RS135','IS135', 'good');

call add_return_records ('RS148','IS135', 'good');

---Testing functions (lets look for a book to update and be sure its not returned before updating it)

select * from books    --- it shows no under 'status'. meaning it has not been returned.
where isbn = '978-0-307-58837-1'

select * from issued_status  ---- the book was issued
where issued_id = 'IS135'

select * from return_status
where issued_id = 'IS135'  
/* its showing no rows because it has not been returned. so lets update it to 'yes'. 
'978-0-307-58837-1'

finish testing
*/




/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books 
issued, the number of books returned, and the total revenue generated from book rentals.
*/
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM return_status;


CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;




/*Task 16:  Active Members
Show the active_members containing members who have issued at least one book in the last 48 months.
*/
SELECT * FROM issued_status

SELECT * FROM members
WHERE member_id IN 
	(SELECT 
     	DISTINCT issued_member_id   
     	FROM issued_status
     WHERE 
    	issued_date >= CURRENT_DATE - INTERVAL '24 month'
    );




/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the 
employee name, number of books processed, and their branch.
*/
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2




/*Task 18: Stored Procedure
Objective: Create a stored procedure to manage the status of books in a library system.
    Description: Write a stored procedure that updates the status of a book based on its issuance 
	or return. Specifically:
    If a book is issued, the status should change to 'no'.
    If a book is returned, the status should change to 'yes'.
*/




/*Task 19: Create Table As Select (CTAS)
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
*/



/*Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
*/
