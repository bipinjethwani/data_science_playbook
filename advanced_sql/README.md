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
