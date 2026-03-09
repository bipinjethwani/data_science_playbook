# Advanced SQL Practice (SQLite)

## What's Here

| File | Purpose |
|------|---------|
| `setup.sql` | Creates tables & inserts sample data — rerun anytime to reset |
| `practice.db` | SQLite database (departments, employees, sales) |
| `01_window_functions.sql` | 8 window function examples ready to run |

## Quick Start

Open a terminal in `advanced_sql/` and run:

```sh
cd advanced_sql && sqlite3 -header -column practice.db
```

You're now on the SQLite prompt. Type any SQL and hit Enter. Use `.quit` to exit.

## Run a Script File

```sh
sqlite3 -header -column practice.db < 01_window_functions.sql
```

## Reset the Database

If you mess up the data, just recreate it:

```sh
sqlite3 practice.db < setup.sql
```

## Tables Overview

- **departments** (5 rows) — `dept_id`, `dept_name`
- **employees** (15 rows) — `emp_id`, `first_name`, `last_name`, `dept_id`, `salary`, `hire_date`
- **sales** (24 rows) — `sale_id`, `emp_id`, `sale_date`, `amount`

## SQLite Viewer Extension

The **SQLite Viewer** extension (already installed) lets you **browse table data** by clicking `practice.db` in the VS Code file explorer. It opens a visual table browser — useful for inspecting data and verifying query results.

However, it is **read-only** — you cannot write or run SQL queries from it. For writing and running SQL, use one of these:

| Method | How |
|--------|-----|
| **Terminal** (recommended) | `sqlite3 -header -column practice.db` → type SQL directly |
| **`.sql` files** | Write queries in a `.sql` file, run with `sqlite3 practice.db < file.sql` |
| **SQLite extension** | Install the *SQLite* extension (`alexcvzz.vscode-sqlite`) — it adds a command palette option to run queries from `.sql` files and see results inside VS Code |

## SQLite Dot-Commands Cheat Sheet

These are typed at the `sqlite>` prompt (not in `.sql` files). They start with `.` and do **not** need a semicolon.

| Command | What it does |
|---------|-------------|
| `.quit` | Exit sqlite3 |
| `.tables` | List all tables |
| `.schema` | Show CREATE statements for all tables |
| `.schema employees` | Show CREATE statement for a specific table |
| `.headers on` | Show column headers in output |
| `.mode column` | Columnar output (aligned) |
| `.mode csv` | CSV output |
| `.mode markdown` | Markdown table output |
| `.mode box` | Box-drawing table output |
| `.width 15 10 8` | Set column widths (for column mode) |
| `.output results.txt` | Redirect output to a file |
| `.output stdout` | Switch output back to terminal |
| `.read 01_window_functions.sql` | Run a SQL file from within the prompt |
| `.import data.csv tablename` | Import CSV into a table |
| `.dump` | Export entire database as SQL |
| `.help` | Show all available dot-commands |

**Tip:** If you started sqlite3 without flags, run `.headers on` and `.mode column` first for readable output. Or just start with:
```sh
sqlite3 -header -column practice.db
```

## How This Workspace Was Set Up

1. Created `setup.sql` with table definitions and sample data (departments, employees, monthly sales)
2. Ran `sqlite3 practice.db < setup.sql` to build the database
3. Created `01_window_functions.sql` with practice examples covering `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, `NTILE`, `FIRST_VALUE`, `LAST_VALUE`, running totals, moving averages, and percent-of-total

No Docker, dev containers, or servers needed — just `sqlite3` (pre-installed on macOS).

---

## test_bed/ — HR Course Database

The `test_bed/` folder contains an HR dataset converted from a PostgreSQL dump.

### Resume Here

```sh
cd advanced_sql && sqlite3 -header -column hr_db.db
```

To reset the database:
```sh
sqlite3 hr_db.db < hr_data.sql
```

### Tables (9 total)

| Table | Rows | Key Columns |
|-------|------|-------------|
| `hris` | 51 | employee_id, first_name, last_name, department, salary, hire_date, termination_date |
| `radford_compensation` | 101 | employee_id, job_title, department, base_salary, bonus, stock_grants |
| `employee_absence` | 100 | employee_id, department, hours_absent |
| `learning_management` | 100 | employee_id, course_name, completion_status |
| `engagement_results` | 97 | employee_id, satisfaction_score, work_life_balance_score |
| `demographics` | 50 | employee_id, gender, nationality, city |
| `talent_development` | 43 | employee_id, department, training_hours |
| `audit_log` | 2 | event_time, event_type, detail |
| `hris_backup` | 0 | (backup copy of hris — empty) |

### Left Off Here: Window Functions vs GROUP BY

**Context:** 51 employees total, 47 currently active (`termination_date IS NULL`).

#### 1. Basic counts

```sql
-- Total employees
SELECT COUNT(*) FROM hris;
-- → 51

-- Active employees only
SELECT COUNT(*) FROM hris WHERE termination_date IS NULL;
-- → 47
```

#### 2. AVG without GROUP BY — collapses to one row

```sql
SELECT department, AVG(salary) FROM hris WHERE termination_date IS NULL;
```
Returns **1 row** — the overall average across all departments. The `department` value shown is arbitrary (just whichever row SQLite picks).

#### 3. AVG with GROUP BY — one row per department

```sql
SELECT department, AVG(salary)
FROM hris
WHERE termination_date IS NULL
GROUP BY department;
```
Returns **11 rows** — one per department. This is the classic aggregation approach: you lose individual employee rows.

#### 4. Window function — every row kept, avg computed per partition

```sql
SELECT employee_id, department, salary,
       AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary
FROM hris
WHERE termination_date IS NULL;
```
Returns **47 rows** — every active employee, with their department's average salary alongside. No grouping, no collapsing rows.

#### 5. Window function + COUNT(*) OVER() for total row count

```sql
SELECT employee_id, department, salary,
       AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary,
       COUNT(*) OVER () AS total_rows
FROM hris
WHERE termination_date IS NULL;
```
Returns **47 rows** — same as above, but with `total_rows = 47` on every row. `COUNT(*) OVER()` with an empty `OVER()` counts all rows in the result set.

**Key insight:** `GROUP BY` collapses rows → one row per group. `OVER (PARTITION BY ...)` keeps every row and adds the aggregate as an extra column.
