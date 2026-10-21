/*
    Optional reusable procedures.
*/
USE FoodserviceDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchRestaurantsByCuisine
    @Cuisine NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NULLIF(LTRIM(RTRIM(@Cuisine)), N'') IS NULL
        THROW 50010, 'Cuisine must not be blank.', 1;

    SELECT r.Restaurant_ID, r.Name AS RestaurantName,
           r.City, r.State, r.Country, r.Price, r.Area
    FROM dbo.Restaurant AS r
    WHERE EXISTS
    (
        SELECT 1
        FROM dbo.Restaurant_Cuisines AS rc
        WHERE rc.Restaurant_ID = r.Restaurant_ID
          AND rc.Cuisine = @Cuisine
    )
    ORDER BY r.Name, r.Restaurant_ID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetRestaurantRatingSummary
    @RestaurantID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.Restaurant_ID,
        r.Name AS RestaurantName,
        COUNT(rt.Consumer_ID) AS NumberOfRatings,
        AVG(CAST(rt.Overall_rating AS DECIMAL(10,2))) AS AverageOverallRating,
        AVG(CAST(rt.Food_Rating AS DECIMAL(10,2))) AS AverageFoodRating,
        AVG(CAST(rt.Service_Rating AS DECIMAL(10,2))) AS AverageServiceRating
    FROM dbo.Restaurant AS r
    LEFT JOIN dbo.Ratings AS rt ON rt.Restaurant_ID = r.Restaurant_ID
    WHERE @RestaurantID IS NULL OR r.Restaurant_ID = @RestaurantID
    GROUP BY r.Restaurant_ID, r.Name
    ORDER BY r.Name, r.Restaurant_ID;
END;
GO

/*
Examples:
EXEC dbo.usp_SearchRestaurantsByCuisine @Cuisine = N'Japanese';
EXEC dbo.usp_GetRestaurantRatingSummary;
EXEC dbo.usp_GetRestaurantRatingSummary @RestaurantID = 101;
*/
