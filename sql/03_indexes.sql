/*
    Step 3: Supporting indexes.
    Primary keys already create indexes. These help common filtering and joins.
*/
USE FoodserviceDB;
GO

CREATE INDEX IX_Restaurant_Price_Area
    ON dbo.Restaurant (Price, Area)
    INCLUDE (Name, Restaurant_ID);

CREATE INDEX IX_Restaurant_Cuisines_Cuisine_Restaurant
    ON dbo.Restaurant_Cuisines (Cuisine, Restaurant_ID);

CREATE INDEX IX_Ratings_Overall_Restaurant
    ON dbo.Ratings (Overall_rating, Restaurant_ID)
    INCLUDE (Consumer_ID, Food_Rating, Service_Rating);

CREATE INDEX IX_Ratings_Service_Consumer
    ON dbo.Ratings (Service_Rating, Consumer_ID)
    INCLUDE (Restaurant_ID, Overall_rating, Food_Rating);

CREATE INDEX IX_Consumers_Age
    ON dbo.Consumers (Age)
    INCLUDE (Consumer_ID);
GO
