# Source Data

The supplied SQL script references the tables `Restaurant`, `Consumers`, `Restaurant_Cuisines`, and `Ratings`, but it does not include their original `CREATE TABLE` definitions or data files.

To use this project:

1. Obtain the authorized source CSV files or a source database export.
2. Map the source columns to the schema described in `../docs/data_dictionary.md`.
3. Import parent tables first: `Restaurant` and `Consumers`.
4. Import `Restaurant_Cuisines` and `Ratings` after parent rows exist.
5. Run `../sql/06_data_quality_checks.sql`.

## Import tips for SQL Server

- Use SSMS Import Flat File / Import Data, or `BULK INSERT` only if the SQL Server service account can access the file path.
- Keep a copy of the raw source files unchanged.
- Inspect column types, missing-value conventions, rating ranges, and duplicate keys before importing.
- Do not commit private or licensed source data to a public GitHub repository unless you have permission.
- This repository intentionally contains no fabricated data or made-up query results.
