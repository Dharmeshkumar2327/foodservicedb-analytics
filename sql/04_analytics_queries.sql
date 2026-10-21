/*
    FoodserviceDB Analytics Queries
    Execute after schema creation and data import.
*/
USE FoodserviceDB;
GO

/* 1. Medium-priced, open-area restaurants serving Mexican cuisine. */
SELECT DISTINCT r.Restaurant_ID, r.Name AS RestaurantName
FROM dbo.Restaurant AS r
WHERE r.Price = N'Medium'
  AND r.Area = N'Open'
  AND EXISTS
  (
      SELECT 1
      FROM dbo.Restaurant_Cuisines AS rc
      WHERE rc.Restaurant_ID = r.Restaurant_ID
        AND rc.Cuisine = N'Mexican'
  )
ORDER BY r.Name;


/* 2. Compare counts of restaurants with overall rating 1 by cuisine.
      COUNT(DISTINCT) prevents multiple cuisine/rating rows inflating counts. */
SELECT
    rc.Cuisine,
    COUNT(DISTINCT r.Restaurant_ID) AS RestaurantsWithOverallRating1
FROM dbo.Restaurant AS r
JOIN dbo.Ratings AS rt
  ON rt.Restaurant_ID = r.Restaurant_ID
JOIN dbo.Restaurant_Cuisines AS rc
  ON rc.Restaurant_ID = r.Restaurant_ID
WHERE rt.Overall_rating = 1
  AND rc.Cuisine IN (N'Mexican', N'Italian')
GROUP BY rc.Cuisine
ORDER BY rc.Cuisine;


/* 3. Average age of consumers who gave service rating 0.
      Confirm that 0 is a meaningful score in your source data. */
SELECT
    CAST(AVG(CAST(c.Age AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS AverageConsumerAge,
    COUNT(*) AS MatchingRatingRows
FROM dbo.Consumers AS c
JOIN dbo.Ratings AS rt
  ON rt.Consumer_ID = c.Consumer_ID
WHERE rt.Service_Rating = 0
  AND c.Age IS NOT NULL;


/* 4. Ratings submitted by the youngest consumer(s).
      Includes ties and returns every restaurant rated by those consumers. */
WITH YoungestConsumers AS
(
    SELECT Consumer_ID, Age
    FROM dbo.Consumers
    WHERE Age = (SELECT MIN(Age) FROM dbo.Consumers WHERE Age IS NOT NULL)
)
SELECT
    r.Restaurant_ID,
    r.Name AS RestaurantName,
    rt.Food_Rating,
    yc.Age AS ConsumerAge,
    yc.Consumer_ID
FROM YoungestConsumers AS yc
JOIN dbo.Ratings AS rt ON rt.Consumer_ID = yc.Consumer_ID
JOIN dbo.Restaurant AS r ON r.Restaurant_ID = rt.Restaurant_ID
ORDER BY rt.Food_Rating DESC, r.Name;


/* 5. Safe preview: service ratings for restaurants with parking.
      The supplied script changed ratings to 2; this query previews affected rows
      without overwriting customer feedback. */
SELECT
    r.Restaurant_ID,
    r.Name AS RestaurantName,
    r.Parking,
    rt.Consumer_ID,
    rt.Service_Rating AS CurrentServiceRating
FROM dbo.Restaurant AS r
JOIN dbo.Ratings AS rt ON rt.Restaurant_ID = r.Restaurant_ID
WHERE LOWER(LTRIM(RTRIM(r.Parking))) IN (N'yes', N'public')
ORDER BY r.Name, rt.Consumer_ID;


/* 6a. Restaurants serving Japanese cuisine. */
SELECT r.Restaurant_ID, r.Name AS RestaurantName,
       CONCAT_WS(N', ', r.City, r.State, r.Country) AS Location
FROM dbo.Restaurant AS r
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Restaurant_Cuisines AS rc
    WHERE rc.Restaurant_ID = r.Restaurant_ID
      AND rc.Cuisine = N'Japanese'
)
ORDER BY r.Name;


/* 6b. Top 10 restaurants rated by consumers younger than 21.
      DISTINCT avoids duplicate restaurant rows; order is deterministic. */
SELECT TOP (10)
    r.Restaurant_ID,
    r.Name AS RestaurantName,
    r.City,
    r.Country
FROM dbo.Restaurant AS r
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Ratings AS rt
    JOIN dbo.Consumers AS c ON c.Consumer_ID = rt.Consumer_ID
    WHERE rt.Restaurant_ID = r.Restaurant_ID
      AND c.Age < 21
)
ORDER BY r.Name, r.Restaurant_ID;


/* 6c. Average food rating by alcohol-service status, including unrated venues. */
SELECT
    COALESCE(NULLIF(LTRIM(RTRIM(r.Alcohol_Service)), N''), N'Unknown') AS AlcoholServiceStatus,
    AVG(CAST(rt.Food_Rating AS DECIMAL(10,2))) AS AverageFoodRating,
    COUNT(rt.Food_Rating) AS NumberOfFoodRatings
FROM dbo.Restaurant AS r
LEFT JOIN dbo.Ratings AS rt ON rt.Restaurant_ID = r.Restaurant_ID
GROUP BY COALESCE(NULLIF(LTRIM(RTRIM(r.Alcohol_Service)), N''), N'Unknown')
ORDER BY AlcoholServiceStatus;


/* 6d. Restaurants with average service rating below 3. */
SELECT
    r.Restaurant_ID,
    r.Name AS RestaurantName,
    AVG(CAST(rt.Service_Rating AS DECIMAL(10,2))) AS AverageServiceRating,
    COUNT(rt.Service_Rating) AS NumberOfServiceRatings
FROM dbo.Restaurant AS r
JOIN dbo.Ratings AS rt ON rt.Restaurant_ID = r.Restaurant_ID
WHERE rt.Service_Rating IS NOT NULL
GROUP BY r.Restaurant_ID, r.Name
HAVING AVG(CAST(rt.Service_Rating AS DECIMAL(10,2))) < 3
ORDER BY AverageServiceRating ASC, r.Name;
GO
