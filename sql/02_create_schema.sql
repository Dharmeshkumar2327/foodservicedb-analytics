/*
    Step 2: Core schema.
    Run only in FoodserviceDB. This script is intended for a new/empty database.
    The column set is inferred from the supplied analytical queries; adjust data
    types/lengths to match your actual source files before importing.
*/
USE FoodserviceDB;
GO

IF OBJECT_ID(N'dbo.Ratings', N'U') IS NOT NULL
    THROW 50001, 'Ratings already exists. Use a fresh database or migrate deliberately.', 1;
IF OBJECT_ID(N'dbo.Restaurant_Cuisines', N'U') IS NOT NULL
    THROW 50002, 'Restaurant_Cuisines already exists. Use a fresh database or migrate deliberately.', 1;
IF OBJECT_ID(N'dbo.Consumers', N'U') IS NOT NULL
    THROW 50003, 'Consumers already exists. Use a fresh database or migrate deliberately.', 1;
IF OBJECT_ID(N'dbo.Restaurant', N'U') IS NOT NULL
    THROW 50004, 'Restaurant already exists. Use a fresh database or migrate deliberately.', 1;
GO

CREATE TABLE dbo.Restaurant
(
    Restaurant_ID       INT            NOT NULL,
    Name                NVARCHAR(150)  NOT NULL,
    City                NVARCHAR(100)  NULL,
    State               NVARCHAR(100)  NULL,
    Country             NVARCHAR(100)  NULL,
    Price               NVARCHAR(30)   NULL,
    Area                NVARCHAR(30)   NULL,
    Parking             NVARCHAR(30)   NULL,
    Alcohol_Service     NVARCHAR(50)   NULL,
    CONSTRAINT PK_Restaurant PRIMARY KEY (Restaurant_ID)
);
GO

CREATE TABLE dbo.Consumers
(
    Consumer_ID         INT            NOT NULL,
    Age                 TINYINT        NULL,
    CONSTRAINT PK_Consumers PRIMARY KEY (Consumer_ID),
    CONSTRAINT CK_Consumers_Age CHECK (Age IS NULL OR Age <= 120)
);
GO

CREATE TABLE dbo.Restaurant_Cuisines
(
    Restaurant_Cuisines_ID INT IDENTITY(1000,1) NOT NULL,
    Restaurant_ID          INT                  NOT NULL,
    Cuisine                NVARCHAR(100)        NOT NULL,
    CONSTRAINT PK_Restaurant_Cuisines PRIMARY KEY (Restaurant_Cuisines_ID),
    CONSTRAINT FK_Restaurant_Cuisines_Restaurant
        FOREIGN KEY (Restaurant_ID) REFERENCES dbo.Restaurant(Restaurant_ID),
    CONSTRAINT UQ_Restaurant_Cuisine UNIQUE (Restaurant_ID, Cuisine)
);
GO

CREATE TABLE dbo.Ratings
(
    Consumer_ID     INT           NOT NULL,
    Restaurant_ID   INT           NOT NULL,
    Overall_rating  DECIMAL(4,2)  NULL,
    Food_Rating     DECIMAL(4,2)  NULL,
    Service_Rating  DECIMAL(4,2)  NULL,
    CONSTRAINT PK_Ratings PRIMARY KEY (Consumer_ID, Restaurant_ID),
    CONSTRAINT FK_Ratings_Consumer
        FOREIGN KEY (Consumer_ID) REFERENCES dbo.Consumers(Consumer_ID),
    CONSTRAINT FK_Ratings_Restaurant
        FOREIGN KEY (Restaurant_ID) REFERENCES dbo.Restaurant(Restaurant_ID)
);
GO
