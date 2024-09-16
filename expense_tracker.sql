--CREATING NEW DATABASE
CREATE DATABASE expense_tracker;

--CREATING USERS TABLE
CREATE TABLE Users ( 
    UserId INT PRIMARY KEY AUTO_INCREMENT, 
    Username VARCHAR(50) NOT NULL, 
    Email VARCHAR(30) NOT NULL UNIQUE, 
    PasswordHash VARCHAR(20) NOT NULL, 
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
    );

--CREATING CATEGORIES TABLE

CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY AUTO_INCREMENT, 
    CategoryName VARCHAR(20) NOT NULL 
    );

--CREATING EXPENSES TABLE
CREATE TABLE Expenses ( 
    ExpenseID INT PRIMARY KEY AUTO_INCREMENT, 
    UserID INT, 
    CategoryID INT, 
    Amount DECIMAL(10,2) NOT NULL, 
    ExpenseDate DATE NOT NULL, 
    Descript_expense VARCHAR(200), 
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID), 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
    );

--CRUD OPERATIONS
--CREATE
--INSERTING VALUES INTO USERS TABLE
INSERT INTO Users (Username, Email, PasswordHash) 
VALUES ('Percy Jackson', 'percy@camphalfblood.com', 'percyjackson'),
       ('Annabeth Chase', 'annabeth@camphalfblood.com', 'annabethchase'), 
       ('Grover Underwood', 'grover@camphalfblood.com', 'groverunderwood'),
       ('Thalia Grace', 'thalia@camphalfblood.com', 'thaliagrace'),
       ('Luke Castellan', 'luke@camphalfblood.com', 'lukecastellan');

--INSERTING VALUES INTO CATEGORIES TABLE
INSERT INTO Categories (CategoryID, CategoryName) 
VALUES (1, 'Groceries'),
       (2,'Food'),
       (3,'Electronics'), 
       (4,'Transport'), 
       (5,'Utilities');

--INSERTING VALUES INTO EXPENSES TABLE
INSERT INTO Expenses (UserID, CategoryID, Amount, ExpenseDate, Descript_expense) 
VALUES (1, 2, 50.00, '2024-05-01', 'Food'),
       (1, 2, 20.00, '2024-05-02', 'Bus fare'), 
       (2, 3, 100.00, '2024-05-03', 'Electricity bill'),
       (1, 3, 3, 100, '2024-03-02'), 
       (5, 4, 4, 40, '2024-04-12');

--READ 
--DISPLAYING USERS TABLE
SELECT *FROM Users;

--DISPLAYING CATEGORIES TABLE
SELECT *FROM Categories;

--DISPLAYS EXPENSES TABLE
SELECT *FROM Expenses;

--DISPLAYS EXPENSES OF USER WITH USERID = 1
SELECT *FROM Expenses WHERE UserID = 1;

--UPDATE
--UPDATING AMOUNT VALUE FOR A USER
UPDATE Expenses SET Amount = 20 WHERE UserID = 1 AND ExpenseID = 3;

--CHANGING VALUE OF CATEGORYNAME
UPDATE Categories SET CategoryName = 'Dining' WHERE CategoryID = 2;

--DROPPING A COLUMN FROM A EXPENSES TABLE
ALTER TABLE Expenses  DROP COLUMN Descript_expense;

--DELETE
--DELETES RECORDS OF USER WITH USERID = 4
DELETE FROM USERS WHERE UserID = 4;


--CREATING VIEWS
CREATE VIEW TotalSpendingByUser AS 
SELECT UserID, SUM(Amount) AS TotalSpent 
FROM Expenses 
GROUP BY UserID;

CREATE VIEW ExpenseDetails AS 
SELECT e.ExpenseID, u.Username, c.CategoryName, e.Amount, e.ExpenseDate, e.Descript_expense 
FROM Expenses e  
JOIN Users u ON e.UserId = u.UserID 
JOIN Categories c ON e.CategoryID = c.CategoryID;

--TO DISPLAY THE VIEWS
SELECT * FROM TotalSpendingByUser;

SELECT *FROM ExpenseDetails;


--CREATING PROCEDURES
DELIMITER //
CREATE PROCEDURE AddExpense( 
    IN p_UserID INT, 
    IN p_CategoryID INT, 
    IN p_Amount DECIMAL(10,2), 
    IN p_ExpenseDate DATE 
    ) 
    BEGIN  
    INSERT INTO Expenses (UserID, CategoryID, Amount, ExpenseDate)     
    VALUES (p_UserID, p_CategoryID, p_Amount, p_ExpenseDate); 
    END
DELIMITER //

DELIMITER//
CREATE PROCEDURE GetExpensesByUser( 
    IN p_UserID INT 
    ) 
    BEGIN  
    SELECT *FROM Expenses WHERE UserID = p_UserID;
    END
DELIMITER //

--CALLING PROCEDURES
--ADDS NEW ROW IN THE EXPENSE TABLE WITH THE PARAMETERS PASSED
CALL AddExpense(3, 4, 200.00, '2024-01-29');

--GETS ALL EXPENSES OF THE USER WITH THE USERID PASSED AS PARAMETER
CALL GetExpensesByUser(2);

--CREATING TRANSACTIONS
--TRANSFERS AN EXPENSE FROM ONE USER TO ANOTHER
START TRANSACTION;

UPDATE Expenses
SET UserID = 2
WHERE ExpenseID = 1 AND UserID = 3;

COMMIT;
