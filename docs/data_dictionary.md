# Data Dictionary

This dictionary documents the minimum column set required by the supplied analytical SQL. The original source schema and source data were not included in the supplied task SQL, so column sizes and some data types are reasonable starting choices and should be checked against the actual dataset.

## `dbo.Restaurant`

| Column | Type | Meaning |
|---|---|---|
| `Restaurant_ID` | `INT` | Primary key from the source dataset |
| `Name` | `NVARCHAR(150)` | Restaurant name |
| `City` | `NVARCHAR(100)` | City |
| `State` | `NVARCHAR(100)` | State or region |
| `Country` | `NVARCHAR(100)` | Country |
| `Price` | `NVARCHAR(30)` | Price category, e.g. Medium |
| `Area` | `NVARCHAR(30)` | Seating/area category, e.g. Open |
| `Parking` | `NVARCHAR(30)` | Parking category |
| `Alcohol_Service` | `NVARCHAR(50)` | Alcohol-service category |

## `dbo.Consumers`

| Column | Type | Meaning |
|---|---|---|
| `Consumer_ID` | `INT` | Primary key from source dataset |
| `Age` | `TINYINT` | Consumer age in years; nullable if missing |

## `dbo.Restaurant_Cuisines`

| Column | Type | Meaning |
|---|---|---|
| `Restaurant_Cuisines_ID` | `INT IDENTITY` | Surrogate primary key |
| `Restaurant_ID` | `INT` | Foreign key to `Restaurant` |
| `Cuisine` | `NVARCHAR(100)` | One cuisine associated with the restaurant |

The unique constraint on `(Restaurant_ID, Cuisine)` prevents duplicate cuisine mappings.

## `dbo.Ratings`

| Column | Type | Meaning |
|---|---|---|
| `Consumer_ID` | `INT` | Foreign key to `Consumers` |
| `Restaurant_ID` | `INT` | Foreign key to `Restaurant` |
| `Overall_rating` | `DECIMAL(4,2)` | Overall rating from source |
| `Food_Rating` | `DECIMAL(4,2)` | Food rating from source |
| `Service_Rating` | `DECIMAL(4,2)` | Service rating from source |

The composite primary key `(Consumer_ID, Restaurant_ID)` follows the supplied SQL's assumption that a consumer can have one rating record per restaurant. If the source allows multiple visits/ratings by the same consumer, add a rating/visit ID and revise the key.

## Questions to confirm before production use

- What is the valid rating range? The original queries include `Overall_rating = 1` and `Service_Rating = 0`; this project does not assume a full scale.
- Can one consumer rate a restaurant multiple times?
- Can a restaurant have multiple cuisine values? This schema supports that.
- What are the exact source values for `Price`, `Area`, `Parking`, and `Alcohol_Service`?
- Are missing values represented as `NULL`, blank strings, or source-specific labels?
