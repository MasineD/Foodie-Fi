/* 
	PURPOSE:
	1.This creates the database and schemas used in this porject

	WARNING:
	1.Running the code in this script will first check if the database FoodieFiDB exists, if
	  it does, it will be dropped(deleted) and a new one will be created.
*/
USE master;
GO

--Dropping an existing database and creating a new one
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'FoodieFiDB')
	BEGIN
		ALTER DATABASE FoodieFiDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE FoodieFiDB
	END;
GO
CREATE DATABASE FoodieFiDB;
GO
USE FoodieFiDB;
GO
--Creating the schemas for each layer of the project
CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;