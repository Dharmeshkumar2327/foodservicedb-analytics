/*
    FoodserviceDB Analytics
    Step 1: Create database.

    Run this script using an account with permission to create databases.
    If the database already exists, skip CREATE DATABASE and select it.
*/
IF DB_ID(N'FoodserviceDB') IS NULL
BEGIN
    CREATE DATABASE FoodserviceDB;
END;
GO

USE FoodserviceDB;
GO
