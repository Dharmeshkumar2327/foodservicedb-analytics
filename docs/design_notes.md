# Design Notes and Improvements

## Scope

The project is based on the supplied `@00713171_task2.sql` file. That file contains analytical queries and `ALTER TABLE` statements, but not the original `CREATE TABLE` definitions or the dataset. The schema in this repository is therefore an implementation baseline inferred from columns referenced by those queries.

## Improvements

1. **Reproducible setup:** separate database creation, table creation, indexes, analytics, procedures, and data-quality checks into numbered scripts.
2. **Referential integrity:** define foreign keys in the table definitions.
3. **Cuisine mapping:** add a surrogate key and a unique constraint on restaurant/cuisine.
4. **Safer analysis:** replace the procedure that sets all qualifying service ratings to `2` with a read-only preview query. A customer-rating table should preserve observed feedback; business rules should not rewrite historical ratings without an explicit, audited requirement.
5. **Deterministic top-N:** add `ORDER BY` to `TOP (10)`.
6. **NULL handling:** represent missing alcohol-service values as `Unknown` in reporting, instead of implying every missing value means no alcohol service.
7. **Readable aggregates:** cast ratings explicitly when calculating averages and return the number of rating rows alongside averages.
8. **Data quality:** provide checks for missing relationships, missing fields, duplicates, and suspicious rating values.
9. **Indexes:** add indexes around frequently filtered/joined columns. Validate actual execution plans and table sizes before keeping all indexes in a large production system.

## Performance and correctness cautions

- `COUNT(DISTINCT Restaurant_ID)` avoids overcounting when a restaurant has multiple cuisine mappings or rating joins.
- `EXISTS` is used for existence checks to avoid duplicating restaurants.
- The average age query excludes unknown ages because `AVG` ignores `NULL`; it also reports the number of matching rating rows.
- The youngest-consumer query returns all consumers tied for the minimum non-null age.
- The original SQL's use of `Service_Rating = 0` may be intentional. Confirm the rating scale before interpreting zero as a bad rating.
- The schema's composite rating key assumes one rating per consumer/restaurant pair. If repeat visits are possible, use a separate rating ID or visit ID.
- Do not run this as a production healthcare/financial-grade system; this is an educational restaurant analytics database.
