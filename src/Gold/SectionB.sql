USE FoodieFiDB;

/*********************** B.Data Analysis Questions *********************/

-- ============== Question 1 ==============

SELECT COUNT(DISTINCT CustomerID) TotalCustomers		--1.Count the unique customer IDs
FROM Silver.Subscriptions;

-- ============== Question 2 ==============
SELECT SubscriptionDate , COUNT(PlanID) MonthlyDistribution
FROM (
SELECT DATETRUNC(MONTH,StartDate) AS SubscriptionDate, PlanID
FROM Silver.Subscriptions
WHERE PlanID = 0
) TruncateDate
GROUP BY SubscriptionDate 
ORDER BY MonthlyDistribution DESC


-- ============== Question 3 ==============
/*	3.Extract only the PlanName and PlanID
	4.COUNT the rows, PARTITION BY PlanName
	5.Use the DISTINCT keyword to remove duplicate rows		*/
SELECT *
FROM(
	SELECT DISTINCT s.PlanID, p.PlanName, COUNT(*) OVER(PARTITION BY p.PlanName) EventsCount
	FROM Silver.Subscriptions s
	JOIN Silver.Plans p	--1.JOIN the Subscriptions and Plan tables on PlanID,
	ON s.PlanID = p.PlanID
	WHERE YEAR(StartDate) > 2020
) CountEvents
ORDER BY EventsCount DESC;	--2.Consider only the records WHERE YEAR(StartDate) > 2020

-- ============== Question 4 ==============

SELECT DISTINCT s.PlanID, p.PlanID, COUNT(*) OVER() TotalSubscriptions		--3.Count the churn subscriptions
	,ROUND((CAST(COUNT(*) OVER() AS FLOAT))/(SELECT CAST(COUNT(*) AS FLOAT) FROM Silver.Subscriptions)*100,2) ChurnPercentage	--4.Compute the churn percentage
FROM Silver.Subscriptions s
JOIN Silver.Plans p		--1.JOIN the subscriptions table with the plans
ON s.PlanID = p.PlanID
WHERE LOWER(p.PlanName) = 'churn'	--2.Consider only the CHURN subscriptions

-- ============== Question 5 ==============
--3.Compute the percentage
SELECT ChurnAfterTrial, ROUND((CAST(ChurnAfterTrial AS FLOAT)/(SELECT CAST(COUNT(*) AS FLOAT) FROM Silver.Subscriptions))*100,0) 'ChurnAfterTrial(%)'
FROM (
	SELECT COUNT(*) AS ChurnAfterTrial	
	FROM (	--1.Get the next subscription's ID
		SELECT *, LEAD(PlanID,1,10000000) OVER(PARTITION BY CustomerID ORDER BY PlanID) NextSubscription
		FROM Silver.Subscriptions
	) DetectNextSubscriprion
	WHERE PlanID = 0 AND NextSubscription = 4	--2.Consider only those where the next subscription is CHURN
) AccessNextSubscription

-- ============== Question 6 ==============
SELECT COUNT(*) SubscriptionsAfterTrial, ROUND((CAST(COUNT(*) AS FLOAT)/ (SELECT COUNT(*) FROM Silver.Subscriptions))*100,2) 'SubsscriptionsAfterTrial(%)'		--2.Count all the records
FROM Silver.Subscriptions
WHERE PlanID != 0	--1.Consider only the records where the plan is not Trial

/**** Is churn straight after free trial considered a plan...?********/

-- ============== Question 7 ==============
SELECT DISTINCT s.PlanID, p.PlanName
	, COUNT(*) OVER(PARTITION BY p.PlanName ORDER BY s.PlanID) CustomerCount	--3.COUNT all records, PARTITION BY PlanName
	,ROUND((CAST(COUNT(*) OVER(PARTITION BY p.PlanName) AS FLOAT)/CAST((SELECT COUNT(*) 
		FROM Silver.Subscriptions) AS FLOAT)*100),2) 'CustomerCount(%)'		--4.Calculate the percentage relative to the total subscriptions
FROM Silver.Subscriptions s
JOIN Silver.Plans p		--1.JOIN Subscriptions and Plans tables to get the PlanName
ON s.PlanID = p.PlanID
WHERE StartDate <= '2020-12-31'		--2.Extract all records where the StartDate is before 2020-12-31
ORDER BY s.PlanID

-- ============== Question 8 ==============
SELECT COUNT(*) 'AnnualSubscriptions(2020)'		--3.Count all the records
FROM Silver.Subscriptions s
JOIN Silver.Plans p		--1.JOIN the Subscriptions and Plans tables on PlanID
ON s.PlanID = p.PlanID
WHERE LOWER(p.PlanName) LIKE '%annual%' AND YEAR(s.StartDate) = '2020'		--2.Extract and COUNT all records WHERE the PlanName contain 'annual' word and the Year is 2020

-- ============== Question 9 ==============
SELECT DISTINCT AVG(DATEDIFF(DAY,StartDate,StartDate2)) OVER() AverageDays	--6.Compute the average of the date differences, in days
FROM(	--3.Put the plan names and start dates side-by-side
SELECT s.CustomerID, s.PlanID, p.PlanName, s.StartDate
	,LEAD(PlanName,1,'') OVER(PARTITION BY CustomerID ORDER BY StartDate) Plan2	
	,LEAD(StartDate,1,'') OVER(PARTITION BY CustomerID ORDER BY StartDate) StartDate2
FROM Silver.Subscriptions s
JOIN Silver.Plans p		--1.JOIN Subscriptions and Plans tables to get the PlanName
ON s.PlanID = p.PlanID
WHERE p.PlanName = 'trial' OR p.PlanName LIKE '%annual%'	--2.Consider only the trial and annual subscriptions
) Trial_Annual
WHERE plan2 != ''	--5.Consider all records where second plan name is not empty

-- ============== Question 10 ==============
WITH ComputeAvgDays AS(
	SELECT *, DATEDIFF(DAY,StartDate,StartDate2) AverageDays	--4.Compute the difference between trial and annual start dates
	FROM(	--3.Put the plan names and start dates side-by-side
	SELECT s.CustomerID, s.PlanID, p.PlanName, s.StartDate
		,LEAD(PlanName,1,'') OVER(PARTITION BY CustomerID ORDER BY StartDate) Plan2	
		,LEAD(StartDate,1,'') OVER(PARTITION BY CustomerID ORDER BY StartDate) StartDate2
	FROM Silver.Subscriptions s
	JOIN Silver.Plans p		--1.JOIN Subscriptions and Plans tables to get the PlanName
	ON s.PlanID = p.PlanID
	WHERE p.PlanName = 'trial' OR p.PlanName LIKE '%annual%'	--2.Consider only the trial and annual subscriptions
	) Trial_Annual
	WHERE plan2 != ''
)
SELECT Interval, COUNT(*) TotalSubscriptions
FROM (
	SELECT *
			,(CASE		--5.Group up the days into intervals
				WHEN AverageDays > 0 AND AverageDays <= 30 THEN '0-30'
				WHEN AverageDays > 30 AND AverageDays <= 60 THEN '30-60'
				WHEN AverageDays > 60 AND AverageDays <= 90 THEN '60-90'
				WHEN AverageDays > 90 AND AverageDays <= 120 THEN '90-120'
				WHEN AverageDays > 120 AND AverageDays <= 150 THEN '120-150'
				WHEN AverageDays > 150 AND AverageDays <= 180 THEN '150-180'
				WHEN AverageDays > 180 AND AverageDays <= 210 THEN '180-210'
				WHEN AverageDays > 210 AND AverageDays <= 240 THEN '210-240'
				WHEN AverageDays > 240 AND AverageDays <= 270 THEN '240-270'
				WHEN AverageDays > 270 AND AverageDays <= 300 THEN '270-300'
				WHEN AverageDays > 300 AND AverageDays <= 330 THEN '300-330'
				WHEN AverageDays > 330 AND AverageDays <= 360 THEN '330-360'
			END) Interval
	FROM ComputeAvgDays
) GroupingDays
GROUP BY Interval
ORDER BY TotalSubscriptions DESC;

/*WITH s AS(
SELECT 0 AS LowBound
UNION ALL
SELECT LowBound +30
FROM s
WHERE LowBound < 300
)
SELECT *, LEAD(LowBound,1,330) OVER(ORDER BY LowBound) UpperBound
FROM s;*/

/********* TODO: FIND a better way to write the code above**************/

-- ============== Question 11 ==============
SELECT COUNT(*) TotalCustomers		--5.Count all the records
FROM (	--3.Put the plan names and start dates side-by-side	
SELECT s.*, p.PlanName, LEAD(PlanName,1,'') OVER(PARTITION BY CustomerID ORDER BY PlanName) ProPlan
	, LEAD(StartDate,1,'') OVER(PARTITION BY CustomerID ORDER BY StartDate) ProStartDate
FROM Silver.Subscriptions s
JOIN Silver.Plans p		--1.JOIN Subscriptions and Plans tables to get the PlanName
ON s.PlanID = p.PlanID
WHERE p.PlanName LIKE '%monthly' AND YEAR(StartDate) = 2020		--2.Consider only the 2020 monthly subscriptions
) SeperatingPlanNames
WHERE ProPlan != '' AND ProStartDate > StartDate	--4.Consider subscriptions that started with pro monthly
