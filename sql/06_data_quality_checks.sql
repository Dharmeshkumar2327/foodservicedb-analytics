/*
    Data-quality checks. These queries report issues; they do not modify data.
*/
USE FoodserviceDB;
GO

/* Row counts */
SELECT N'Restaurant' AS TableName, COUNT_BIG(*) AS RowCount FROM dbo.Restaurant
UNION ALL
SELECT N'Consumers', COUNT_BIG(*) FROM dbo.Consumers
UNION ALL
SELECT N'Restaurant_Cuisines', COUNT_BIG(*) FROM dbo.Restaurant_Cuisines
UNION ALL
SELECT N'Ratings', COUNT_BIG(*) FROM dbo.Ratings;


/* Restaurants without any cuisine mapping */
SELECT r.Restaurant_ID, r.Name
FROM dbo.Restaurant AS r
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.Restaurant_Cuisines AS rc
    WHERE rc.Restaurant_ID = r.Restaurant_ID
);


/* Consumers without ratings */
SELECT c.Consumer_ID, c.Age
FROM dbo.Consumers AS c
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.Ratings AS rt
    WHERE rt.Consumer_ID = c.Consumer_ID
);


/* Nulls in commonly analyzed fields */
SELECT
    SUM(CASE WHEN Name IS NULL OR LTRIM(RTRIM(Name)) = N'' THEN 1 ELSE 0 END) AS MissingRestaurantNames,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS MissingPriceValues,
    SUM(CASE WHEN Area IS NULL THEN 1 ELSE 0 END) AS MissingAreaValues
FROM dbo.Restaurant;


/* Ratings outside the source dataset's expected scale.
   The original script does not document the complete scale. Inspect results
   and adapt this query to your source's data dictionary before using as a rule. */
SELECT *
FROM dbo.Ratings
WHERE Overall_rating < 0 OR Food_Rating < 0 OR Service_Rating < 0;


/* Duplicate cuisine assignments (should return no rows due to unique constraint). */
SELECT Restaurant_ID, Cuisine, COUNT(*) AS DuplicateCount
FROM dbo.Restaurant_Cuisines
GROUP BY Restaurant_ID, Cuisine
HAVING COUNT(*) > 1;
GO
