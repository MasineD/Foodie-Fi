USE FoodieFiDB;
/*********************** A.Customer Journey ***********************/
SELECT TOP 20 s.CustomerID, s.StartDate,p.*
FROM Subscriptions s
JOIN Plans p
ON s.PlanID = p.PlanID
WHERE CustomerID IN (1,2,11,13,15,16,18,19)
/*
	Considering each customer's first subscription, it is evident that most- if not all, customers 
	start with a free trial. Following the free trial, most of them upgrade to a basic monthly or pro 
	monthly plan. Only a few churn or upgrade to pro annual plan.
*/
