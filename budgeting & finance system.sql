-- CREATING A DATABASE

Create database Budgeting_and_Finance_System;

use Budgeting_and_Finance_System;

-- CREATING TABLES

create table income (
income_id INT auto_increment PRIMARY KEY,
source VARCHAR(50),
amount DECIMAL(30),
income_date date
);

create table expenses (
expense_id INT ,
category varchar(50),
amount decimal(30),
expense_date date,
description varchar(100)
); 

create table budgets (
budget_id INT,
category VARCHAR(50),
amount decimal(30),
month int,
year int
);


create table accounts (
account_id int,
account_name varchar(30),
balance decimal(30)
);




--- INCOME TABLE 
  
INSERT INTO income (income_id, source, amount, income_date)
VALUES
    (1, 'Salary', 3000.00, '2025-10-01'),
    (2, 'Investment', 500.00, '2025-10-05'),
    (3, 'Freelance', 1200.00, '2025-10-10'),
    (4, 'Salary', 3000.00, '2025-09-01'),
    (5, 'Bonus', 1500.00, '2025-09-15'),
    (6, 'Investment', 200.00, '2025-09-20'),
    (7, 'Freelance', 800.00, '2025-09-25');
    
--- EXPENSES TABLE

INSERT INTO expenses (expense_id, category, amount, expense_date, description)
VALUES
    (1, 'Utilities', 150.00, '2025-10-02', 'Electricity bill'),
    (2, 'Groceries', 200.00, '2025-10-03', 'Weekly grocery shopping'),
    (3, 'Office Supplies', 50.00, '2025-10-06', 'Stationery for office'),
    (4, 'Rent', 1200.00, '2025-10-01', 'Monthly rent for apartment'),
    (5, 'Entertainment', 100.00, '2025-10-07', 'Movie night and dining out'),
    (6, 'Groceries', 180.00, '2025-09-30', 'Groceries shopping for the week'),
    (7, 'Utilities', 80.00, '2025-09-25', 'Internet and phone bill');


--- BUDGETS TABLE

INSERT INTO budgets (budget_id, category, amount, month, year)
VALUES
    (1, 'Utilities', 200.00, 10, 2025),
    (2, 'Groceries', 300.00, 10, 2025),
    (3, 'Entertainment', 150.00, 10, 2025),
    (4, 'Rent', 1200.00, 10, 2025),
    (5, 'Utilities', 180.00, 9, 2025),
    (6, 'Groceries', 250.00, 9, 2025),
    (7, 'Entertainment', 120.00, 9, 2025);
    
--- ACCOUNTS TABLE

INSERT INTO accounts (account_id, account_name, balance)
VALUES
    (1, 'Checking', 3500.00),
    (2, 'Savings', 8000.00),
    (3, 'Investment', 12000.00),
    (4, 'Credit Card', -500.00),
    (5, 'Emergency Fund', 2000.00),
    (6, 'Business Account', 15000.00),
    (7, 'Cash', 300.00);



--- /* SQL Queries for Financial Tracking and Reporting /* ----

# Q1. Insert and delete a New Income Entry

insert into income (source,amount,income_date)
values('Salary',5000.00,'2025-10-21');
select * from income;
delete from income
where income_id = 9;

# Q2. Insert a New Expense Entry

INSERT INTO expenses (category, amount, expense_date, description)
VALUES ('Utilities', 200.00, '2025-10-22', 'Electricity bill payment');

select * from expenses;

#Q3. Calculate Total Income for a Given Month

SELECT SUM(amount) AS total_income
FROM income
WHERE income_date BETWEEN  '2025-09-15' AND '2025-10-05';


#Q4. Calculate Total Expenses for a Given Month

SELECT SUM(amount) AS total_expenses
FROM expenses
WHERE expense_date BETWEEN '2025-09-01' AND '2025-10-06';

#Q5. Compare Income vs. Expenses for a Specific Month

SELECT 
    (SELECT SUM(amount) 
     FROM income
     WHERE income_date BETWEEN '2025-09-10' AND '2025-10-04') AS total_income,
     
    (SELECT SUM(amount) 
    FROM expenses 
    WHERE expense_date BETWEEN '2025-09-10' AND '2025-10-04') AS total_expenses;
    

#Q6. Calculate the Budget vs. Actual Spending for a Category

SELECT 
    b.category, 
    b.amount AS budgeted_amount, 
    CASE WHEN SUM(e.amount) IS NULL THEN 0 
    ELSE SUM(e.amount) END AS actual_expenses,
    b.amount - (CASE WHEN SUM(e.amount) IS NULL THEN 0 
    ELSE SUM(e.amount) END) AS remaining_budget
FROM budgets b
LEFT JOIN expenses e 
ON b.category = e.category 
AND e.expense_date BETWEEN '2025-09-25' AND '2025-10-02'
WHERE b.category = 'Utilities'
AND b.year = 2025
GROUP BY b.category, b.amount;


#Q7. Track Account Balance

SELECT account_name, balance
FROM accounts
WHERE account_id = 3;


#Q8. Monthly Income and Expense Summary


SELECT 
    MONTH(i.income_date) AS month,
    SUM(i.amount) AS total_income,
    SUM(e.amount) AS total_expenses
FROM income i
LEFT JOIN expenses e ON MONTH(i.income_date) = MONTH(e.expense_date) 
AND YEAR(i.income_date) = YEAR(e.expense_date)
WHERE YEAR(i.income_date) = 2025
GROUP BY MONTH(i.income_date)
ORDER BY month;


#Q9. Over/Under Budget Report for Each Category


SELECT 
    b.category, 
    b.amount AS budgeted_amount,
    CASE 
        WHEN SUM(e.amount) IS NULL THEN 0 
        ELSE SUM(e.amount) 
    END AS actual_expenses,
    b.amount - 
        (CASE 
            WHEN SUM(e.amount) IS NULL THEN 0 
            ELSE SUM(e.amount) 
        END) AS difference,
    CASE
        WHEN b.amount - 
            (CASE WHEN SUM(e.amount) IS NULL THEN 0 
            ELSE SUM(e.amount) END) < 0 THEN 'Over Budget'
        WHEN b.amount - 
            (CASE WHEN SUM(e.amount) IS NULL THEN 0 
            ELSE SUM(e.amount) END) > 0 THEN 'Under Budget'
        ELSE 'On Budget'
    END AS budget_status
FROM budgets b
LEFT JOIN expenses e 
    ON b.category = e.category 
    AND YEAR(e.expense_date) = 2025
GROUP BY b.category, b.amount;


#Q10. Remaining Budget for the Year

SELECT 
    b.category,
    b.amount AS budgeted_amount,
    CASE 
        WHEN SUM(e.amount) IS NULL THEN 0 
        ELSE SUM(e.amount) 
    END AS actual_expenses,
    b.amount - 
        (CASE 
            WHEN SUM(e.amount) IS NULL THEN 0 
            ELSE SUM(e.amount) 
        END) AS remaining_budget
FROM budgets b
LEFT JOIN expenses e 
    ON b.category = e.category 
    AND YEAR(e.expense_date) = 2025
GROUP BY b.category, b.amount;


#Q11. Account Balance After Income and Expenses


SELECT 
    a.account_name,
    a.balance 
    + (CASE WHEN SUM(i.amount) IS NULL THEN 0 ELSE SUM(i.amount) END)
    - (CASE WHEN SUM(e.amount) IS NULL THEN 0 ELSE SUM(e.amount) END) 
    AS final_balance
FROM accounts a
LEFT JOIN income i 
    ON i.income_date BETWEEN '2025-09-01' AND '2025-10-31'
LEFT JOIN expenses e 
    ON e.expense_date BETWEEN '2025-09-01' AND '2025-10-31'
WHERE a.account_id = 1
GROUP BY a.account_name, a.balance;





