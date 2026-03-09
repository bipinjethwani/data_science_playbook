-- ============================================
-- Window Functions Practice
-- Database: practice.db
-- Run a query:  sqlite3 -header -column practice.db < 01_window_functions.sql
-- Or interactive: sqlite3 -header -column practice.db
-- ============================================

-- ------------------------------------------------
-- 1. ROW_NUMBER: assign a unique row number per dept
-- ------------------------------------------------
SELECT
    d.dept_name,
    e.first_name,
    e.salary,
    ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rank_in_dept
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name, rank_in_dept;

-- ------------------------------------------------
-- 2. RANK vs DENSE_RANK (company-wide salary ranking)
-- ------------------------------------------------
SELECT
    first_name,
    salary,
    RANK()       OVER (ORDER BY salary DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_num
FROM employees;

-- ------------------------------------------------
-- 3. LAG / LEAD: compare each employee's salary to
--    the next-highest in their department
-- ------------------------------------------------
SELECT
    d.dept_name,
    e.first_name,
    e.salary,
    LAG(e.salary)  OVER w AS prev_salary,
    LEAD(e.salary) OVER w AS next_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WINDOW w AS (PARTITION BY e.dept_id ORDER BY e.salary DESC)
ORDER BY d.dept_name, e.salary DESC;

-- ------------------------------------------------
-- 4. Running total of sales per employee
-- ------------------------------------------------
SELECT
    e.first_name,
    s.sale_date,
    s.amount,
    SUM(s.amount) OVER (
        PARTITION BY s.emp_id
        ORDER BY s.sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales s
JOIN employees e ON s.emp_id = e.emp_id
ORDER BY e.first_name, s.sale_date;

-- ------------------------------------------------
-- 5. 3-month moving average of sales per employee
-- ------------------------------------------------
SELECT
    e.first_name,
    s.sale_date,
    s.amount,
    ROUND(AVG(s.amount) OVER (
        PARTITION BY s.emp_id
        ORDER BY s.sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3
FROM sales s
JOIN employees e ON s.emp_id = e.emp_id
ORDER BY e.first_name, s.sale_date;

-- ------------------------------------------------
-- 6. NTILE: split employees into salary quartiles
-- ------------------------------------------------
SELECT
    first_name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;

-- ------------------------------------------------
-- 7. FIRST_VALUE / LAST_VALUE: highest & lowest
--    salary within each department
-- ------------------------------------------------
SELECT DISTINCT
    d.dept_name,
    FIRST_VALUE(e.first_name) OVER w AS top_earner,
    FIRST_VALUE(e.salary)     OVER w AS top_salary,
    LAST_VALUE(e.first_name)  OVER w AS bottom_earner,
    LAST_VALUE(e.salary)      OVER w AS bottom_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WINDOW w AS (
    PARTITION BY e.dept_id
    ORDER BY e.salary DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY d.dept_name;

-- ------------------------------------------------
-- 8. Percent of department total salary
-- ------------------------------------------------
SELECT
    d.dept_name,
    e.first_name,
    e.salary,
    ROUND(100.0 * e.salary / SUM(e.salary) OVER (PARTITION BY e.dept_id), 1) AS pct_of_dept
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.salary DESC;
