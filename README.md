# SQL Data Analytics Portfolio

## 🧹 Project 1: Data Cleaning & Pipeline Standardization
Raw data is rarely clean. In my `scripts/01_data_cleaning.sql` pipeline, I built an ETL preparation layer that systematically addresses common structural data bugs:

1. **Text Standardization:** Utilized `INITCAP` and `TRIM` to fix messy, user-inputted name fields.
2. **Defensive Conditional Logic:** Used `CASE WHEN` to safely flag invalid or missing email patterns so they don't break downstream communication systems.
3. **Imputation:** Applied `COALESCE` to handle missing numeric fields, preserving total row counts without skewing averages.
4. **Deduplication:** Leveraged Window Functions (`ROW_NUMBER() OVER...`) to strip out duplicate event logs triggered by rapid user double-clicks.# sql-data-analytics-portfolio
