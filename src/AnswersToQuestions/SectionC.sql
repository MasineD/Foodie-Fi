USE FoodieFiDB

/******************* C.Challenge Payment Question *********************/
SELECT *
FROM Subscriptions s
JOIN Plans p
ON s.PlanID = p.PlanID
WHERE YEAR(s.StartDate) = '2020';

/***	TO BE CONTINUED		***/