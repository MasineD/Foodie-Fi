/*
	PURPOSE:
		1.This performs data cleaning on the provided datasets

	WARNING
		1.This first empties(TRUNCATE) the tables for storing clean data, before inserting any data
*/
USE FoodieFiDB

/************ Data cleaning on the plans table *************/
TRUNCATE TABLE  Silver.Plans		--2.Empty the table before inserting data
INSERT INTO Silver.Plans (PlanID, PlanName, Price)		--3.Insert the data
SELECT plan_id AS PlanID,plan_name AS PlanName, ISNULL(price,0.00) AS Price		--1.Remove NULL prices
FROM Bronze.plans

/************ Data cleaning on the plans table *************/
TRUNCATE TABLE Silver.Subscriptions		--2.Empty the table before inserting data
INSERT INTO Silver.Subscriptions(CustomerID, PlanID, StartDate)		--3.Insert the data
SELECT customer_id, plan_id, start_date
FROM (--1.ORDER BY start_date to provide insights on customer journey
	SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) OrderTheSubscriptions
	FROM Bronze.subscriptions
) GroupByCustomer;




