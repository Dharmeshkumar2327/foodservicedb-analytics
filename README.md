# FoodserviceDB Analytics

A SQL Server restaurant analytics project for exploring restaurant characteristics, cuisine offerings, consumer demographics, and customer ratings.

This repository rebuilds the supplied `@00713171_task2.sql` into a cleaner, documented SQL Server project. It preserves the original analytical questions while correcting unsafe or fragile patterns.

## Project goals

- Create a reproducible relational schema with primary and foreign keys.
- Separate restaurant, consumer, cuisine, and rating data.
- Answer business questions with readable, reusable T-SQL.
- Add indexes for common joins and filters.
- Avoid silently changing customer ratings during analysis.
- Document how to load source data and validate results.

## Technology

- Microsoft SQL Server 2019+ (T-SQL)
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Optional: CSV files exported from your original dataset

## Repository structure

```text
foodservicedb-analytics/
├── README.md
├── LICENSE
├── .gitignore
├── requirements.txt
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_schema.sql
│   ├── 03_indexes.sql
│   ├── 04_analytics_queries.sql
│   ├── 05_procedures.sql
│   └── 06_data_quality_checks.sql
├── data/
│   └── README.md
└── docs/
    ├── data_dictionary.md
    └── design_notes.md
```

## Quick start

Run these scripts in SSMS **in numeric order**:

1. `sql/01_create_database.sql` — creates and selects `FoodserviceDB`.
2. `sql/02_create_schema.sql` — creates the core tables.
3. `sql/03_indexes.sql` — creates supporting indexes.
4. Import your original dataset into the tables (see `data/README.md`).
5. Run `sql/06_data_quality_checks.sql` to check imported data.
6. Run queries in `sql/04_analytics_queries.sql`.
7. Optionally create the helper procedures in `sql/05_procedures.sql`.

> Important: The supplied SQL file references tables but does not contain their original `CREATE TABLE` statements or the source dataset. This package defines a clean schema based on the column names and business questions in the supplied script. Confirm data types and source-column mappings against your actual CSV/database before importing. No real dataset or fabricated analytical results are included.

## Data model

- `Restaurant`: one row per restaurant.
- `Consumers`: one row per consumer.
- `Ratings`: one rating record per consumer–restaurant pair; composite primary key.
- `Restaurant_Cuisines`: one row per restaurant–cuisine pair, with a surrogate primary key and a uniqueness constraint to prevent duplicate cuisine assignments.

## Analytics included

- Medium-priced restaurants with open seating serving Mexican cuisine.
- Counts of low-overall-rated restaurants by cuisine (Mexican vs Italian).
- Average consumer age for ratings with service score `0`.
- Ratings submitted by the youngest consumer(s).
- Restaurants serving Japanese cuisine.
- Restaurants rated by consumers younger than 21.
- Average food rating by alcohol-service status.
- Restaurants with average service ratings below `3`.
- Data quality checks for duplicates, missing relationships, invalid rating ranges, and missing values.

## Important design changes from the supplied SQL

- Table creation is provided before `ALTER TABLE` constraints are applied.
- Foreign keys are defined in table DDL, avoiding fragile reruns of `ALTER TABLE`.
- `Restaurant_Cuisines` prevents duplicate restaurant/cuisine combinations.
- The `TOP 10` query has a deterministic `ORDER BY`.
- `NULL` alcohol-service values are handled consistently.
- Aggregations are based on the documented rating values; verify whether `0` is a valid score in your source.
- The original procedure that overwrote service ratings for restaurants with parking is not run automatically. Updating real customer feedback to a fixed value would destroy data. A safe preview query is included instead.
- The original SQL's rating scale and source schema were not fully supplied, so the validation script flags out-of-range values without enforcing an assumed scale in the table definition.

## Running in another environment

This is a Microsoft SQL Server project, not MySQL or PostgreSQL. Use T-SQL-compatible tooling.

## License

MIT. See `LICENSE`.

## Disclaimer

This is an educational analytics project. Do not use it to make decisions about real businesses without validating data quality, definitions, and source permissions.
