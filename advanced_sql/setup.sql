-- ============================================
-- Setup script: creates tables and sample data
-- Run: sqlite3 practice.db < setup.sql
-- ============================================

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Departments
CREATE TABLE departments (
    dept_id   INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL
);

INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Finance'),
(5, 'HR');

-- Employees
CREATE TABLE employees (
    emp_id      INTEGER PRIMARY KEY,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    dept_id     INTEGER NOT NULL REFERENCES departments(dept_id),
    salary      REAL NOT NULL,
    hire_date   TEXT NOT NULL  -- ISO format YYYY-MM-DD
);

INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date) VALUES
(1,  'Alice',   'Smith',    1, 120000, '2019-03-15'),
(2,  'Bob',     'Jones',    1, 110000, '2020-07-01'),
(3,  'Charlie', 'Brown',    1,  95000, '2021-01-10'),
(4,  'Diana',   'Prince',   2,  85000, '2018-06-20'),
(5,  'Eve',     'Davis',    2,  90000, '2019-11-05'),
(6,  'Frank',   'Miller',   2,  78000, '2022-02-14'),
(7,  'Grace',   'Lee',      3,  88000, '2020-04-22'),
(8,  'Hank',    'Wilson',   3,  92000, '2019-08-30'),
(9,  'Iris',    'Chen',     4, 105000, '2017-12-01'),
(10, 'Jack',    'Taylor',   4,  98000, '2021-05-18'),
(11, 'Karen',   'White',    4, 102000, '2020-09-12'),
(12, 'Leo',     'Garcia',   5,  72000, '2022-08-01'),
(13, 'Mona',    'Adams',    5,  75000, '2021-03-25'),
(14, 'Nate',    'Clark',    1, 130000, '2016-01-10'),
(15, 'Olivia',  'Hall',     2,  82000, '2023-01-15');

-- Sales (monthly revenue by employee, useful for running totals / moving averages)
CREATE TABLE sales (
    sale_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    emp_id     INTEGER NOT NULL REFERENCES employees(emp_id),
    sale_date  TEXT NOT NULL,
    amount     REAL NOT NULL
);

INSERT INTO sales (emp_id, sale_date, amount) VALUES
-- Diana (emp 4)
(4, '2024-01-15',  5200),
(4, '2024-02-10',  6100),
(4, '2024-03-22',  4800),
(4, '2024-04-05',  7200),
(4, '2024-05-18',  5500),
(4, '2024-06-30',  6800),
-- Eve (emp 5)
(5, '2024-01-08',  4300),
(5, '2024-02-20',  5900),
(5, '2024-03-14',  6200),
(5, '2024-04-28',  5100),
(5, '2024-05-09',  7000),
(5, '2024-06-22',  6500),
-- Frank (emp 6)
(6, '2024-01-25',  3800),
(6, '2024-02-15',  4200),
(6, '2024-03-30',  5000),
(6, '2024-04-12',  3900),
(6, '2024-05-27',  4600),
(6, '2024-06-15',  5300),
-- Olivia (emp 15)
(15, '2024-01-05', 4100),
(15, '2024-02-18', 4800),
(15, '2024-03-08', 5500),
(15, '2024-04-20', 6000),
(15, '2024-05-14', 5200),
(15, '2024-06-28', 6700);
