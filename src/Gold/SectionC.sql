USE FoodieFiDB

/******************* C.Challenge Payment Question *********************/
SELECT s.CustomerID, s.PlanID, s.StartDate, p.PlanName, 
	( CASE
		WHEN Price > 0 AND Price <= 199 THEN Price +0.90
		ELSE Price
	END ) AS Amount, ROW_NUMBER() OVER(PARTITION BY s.CustomerID ORDER BY s.StartDate) PaymentOrder
FROM Silver.Subscriptions s
JOIN Silver.Plans p
ON s.PlanID = p.PlanID
WHERE YEAR(s.StartDate) = '2020' AND PlanName != 'trial' AND PlanName != 'churn';

/***	TO BE CONTINUED		***/