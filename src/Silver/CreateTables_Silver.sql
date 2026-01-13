


IF OBJECT_ID('Silver.Plans','U') IS NOT NULL
	DROP TABLE Silver.Plans;
CREATE TABLE Silver.Plans (
	PlanID INT NOT NULL,
	PlanName VARCHAR(50) NOT NULL,
	Price INT NULL
)
IF OBJECT_ID('Silver.Subscriptions','U') IS NOT NULL
	DROP TABLE Silver.Subscriptions;
CREATE TABLE Silver.Subscriptions(
	CustomerID INT NOT NULL,
	PlanID INT NOT NULL,
	StartDate DATE
)
