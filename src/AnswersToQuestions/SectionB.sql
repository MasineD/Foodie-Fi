USE FoodieFiDB;

/*********************** B.Data Analysis Questions *********************/

-- ============== Question 1 ==============

SELECT COUNT(DISTINCT CustomerID) TotalCustomers		--1.Count the unique customer IDs
FROM Subscriptions;

-- ============== Question 2 ==============
SELECT *, ROUND(CUME_DIST() OVER(PARTITION BY StartOfMonth ORDER BY StartDate),2) MonthlyDistribution	--4.Use the CUME_DIST() to get the sidtribution, PARTITION BY StartOfMonth and ORDER BY the StartDate
INTO FreeTrialsTABLE
FROM(
SELECT s.CustomerID, s.PlanID, p.PlanName,p.Price, s.StartDate, DATETRUNC(MONTH,s.StartDate) StartOfMonth		--3.Reset the StartDates to the start of the the respective month, using the DATETRUNC function
FROM Subscriptions s
JOIN Plans p		--1.JOIN the Subscriptions and Plans tables on PlanID
ON s.PlanID = p.PlanID
WHERE s.PlanID = 0 OR p.PlanName = 'trial'		--2.Considering only the records WHERE the PlanName is 'trial'
) SubQuery;

SELECT PlanID, PlanName, StartDate, StartOfMonth, MonthlyDistribution
FROM FreeTrialsTABLE;

-- ============== Question 3 ==============
/*	3.Extract only the PlanName and PlanID
	4.COUNT the rows, PARTITION BY PlanName
	5.Use the DISTINCT keyword to remove duplicate rows		*/
SELECT DISTINCT s.PlanID, p.PlanName, COUNT(*) OVER(PARTITION BY p.PlanName) EventsCount
FROM Subscriptions s
JOIN Plans p	--1.JOIN the Subscriptions and Plan tables on PlanID,
ON s.PlanID = p.PlanID
WHERE YEAR(StartDate) > 2020;	--2.Consider only the records WHERE YEAR(StartDate) > 2020

-- ============== Question 4 ==============
/*	3.Divide by the total number of customers
	4.Multiply by 100 to get the percentage
	5.Round to 1 decimal place
	6.Use the DISTINCT keyword to remove duplicates		*/
SELECT DISTINCT PlanID, PlanName, TotalRecords, CAST(COUNT(*) OVER() AS FLOAT)  TotalChurnRecords 
	,ROUND((CAST(COUNT(*) OVER()AS FLOAT)/TotalRecords)*100,1) ChurnPercentage		
INTO ChurnTABLE
FROM(
	SELECT s.CustomerID, s.StartDate,p.*, CAST(COUNT(*) OVER() AS FLOAT) TotalRecords	--2.COUNT the records
	FROM Subscriptions s
	JOIN Plans p
	ON s.PlanID = p.PlanID
) SubQuery
WHERE LOWER(PlanName) = 'churn';	--1.Extract the records WHERE the PlanName is CHURN, then

SELECT * 
FROM ChurnTABLE;

-- ============== Question 5 ==============
/*SELECT *		1.Check if there are customers who took MULTIPLE FREE TRIALS
FROM(
SELECT *, COUNT(*) OVER(PARTITION BY CustomerID) FreeTrialCountPerCustomer
FROM Subscriptions
WHERE PlanID = 0
) SubQuery
WHERE FreeTrialCountPerCustomer > 1;*/

SELECT s.*, p.PlanName, p.Price
INTO ChurnAfterTrialTABLE
FROM Subscriptions s
JOIN Plans p
ON s.PlanID = p.PlanID
WHERE LOWER(p.PlanName) = 'churn'		--2.Extract the records WHERE the PlanName is CHURN , and create a table

SELECT DISTINCT c.PlanID, c.PlanName, c.Price, CAST(COUNT(*) OVER() AS FLOAT) ChurnStraightAfterTrial
INTO #ChurnTEMP_TABLE
FROM FreeTrialsTABLE f
JOIN ChurnAfterTrialTABLE c		--3.JOIN with the FreeTrialsTABLE on CustomerID
ON f.CustomerID = c.CustomerID
WHERE DATEADD(DAY,7, f.StartDate) = c.StartDate;	--4.Extract only the records WHERE trial's StartDate + 7days = churn's StartDate

--5.Calculate the percentage relative to all customers, and relative to only CHURN records
SELECT ct.PlanID, ct.PlanName,ct.ChurnStraightAfterTrial
	,ROUND((ct.ChurnStraightAfterTrial/c.TotalRecords)*100,0) 'ChurnAfterTrialPERCENTAGE(all records)'
	,ROUND((ct.ChurnStraightAfterTrial/c.TotalChurnRecords)*100,0) 'ChurnAfterTrialPERCENTAGE(churn records)'
FROM #ChurnTEMP_TABLE ct
JOIN ChurnTABLE c
ON c.PlanID = ct.PlanID;

-- ============== Question 6 ==============
SELECT COUNT(*)SubscriptionsAfterFreeTrial, ROUND(CAST(COUNT(*) AS FLOAT)/CAST((SELECT COUNT(*) TotalSubscriptions
	FROM Subscriptions) AS FLOAT)*100,2) 'SubscriptionsAfterFreeTrial(%)'		--3.Then divide by total subscriptions and multiply by 100
FROM Subscriptions s
JOIN Plans p
ON s.PlanID = p.PlanID
WHERE LOWER(p.PlanName) != 'trial';		/*	1.COUNT the number of subsrciptions
											2.and WHERE the planName IS NOT TRIAL */

/**** Is churn straight after free trial considered a plan...?********/

-- ============== Question 7 ==============
/*	2.COUNT all records, PARTITION BY PlanName
	3.Calculate the percentage relative to the total subscriptions		*/
SELECT DISTINCT s.PlanID, p.PlanName, COUNT(*) OVER(PARTITION BY p.PlanName ORDER BY s.PlanID) CustomerCount
	,ROUND((CAST(COUNT(*) OVER(PARTITION BY p.PlanName) AS FLOAT)/CAST((SELECT COUNT(*) FROM Subscriptions) AS FLOAT)*100),2) 'CustomerCount(%)'
FROM Subscriptions s
JOIN Plans p
ON s.PlanID = p.PlanID
WHERE StartDate <= '2020-12-31'		--1.Extract all records where the StartDate is before 2020-12-31

-- ============== Question 8 ==============
SELECT COUNT(*) 'AnnualSubscriptions(2020)'
FROM Subscriptions s
JOIN Plans p		--1.JOIN the Subscriptions and Plans tables on PlanID
ON s.PlanID = p.PlanID
WHERE LOWER(p.PlanName) LIKE '%annual%' AND YEAR(s.StartDate) = '2020'		--2.Extract and COUNT all records WHERE the PlanName contain 'annual' word and the Year is 2020

-- ============== Question 9 ==============
--1.Create a table for ANNUAL subscriptions
SELECT s.*, p.PlanName, p.Price
INTO AnnualSubscriptionsTABLE
FROM Subscriptions s
JOIN Plans p
ON s.PlanID = s.PlanID
WHERE LOWER(p.PlanName) LIKE '%annual%' AND s.PlanID = 3;

--3.Get the difference in days between the free trail's start date and annual's start date
SELECT a.CustomerID, DATEDIFF(DAY,f.StartDate, a.StartDate) DaysToUpgrade
	,AVG(DATEDIFF(DAY,f.StartDate, a.StartDate)) OVER() AverageDaysToUpgrade		--3.Compute the average of these differences
FROM AnnualSubscriptionsTABLE a
JOIN FreeTrialsTABLE f		--2.JOIN the AnnualSubscriptions table with the FreeTrails table on CustomerID
ON a.CustomerID = f.CustomerID;

/******* Might have to show the AverageDays only ******/

-- ============== Question 10 ==============
/* TODO:
	1.Below is the logic used to answer this question
		a.Number of those who took 0-30 days to upgrade
		b.Number of those who took 31-60 days to upgrade
		c.Number those of took 61-90 days to upgrade
		d.Number of those who took 91-120 days to upgrade
		e.Number of those who took 121-150 days to upgrade
		f.Number of those who took 151-180 days to upgrade
		g.Number of those who took 181-210 days to upgrade
		h.Number of those who took 211-240 days to upgrade
	2.
*/
SELECT DISTINCT Category, COUNT(*) OVER(PARTITION BY Category) SubscriptionsPerCateogry
FROM(
SELECT a.CustomerID, a.StartDate, DATEDIFF(DAY,f.StartDate, a.StartDate) DaysToUpgrade
	,AVG(DATEDIFF(DAY,f.StartDate, a.StartDate)) OVER() AverageDaysToUpgrade
	,CASE
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 0 AND 30 THEN '0-30'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 31 AND 60 THEN '31-60'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 61 AND 90 THEN '61-90'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 91 AND 120 THEN '91-120'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 121 AND 150 THEN '121-150'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 151 AND 180 THEN '151-180'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 181 AND 210 THEN '181-210'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 211 AND 240 THEN '211-240'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 241 AND 270 THEN '241-270'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 271 AND 300 THEN '271-300'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 301 AND 330 THEN '301-330'
		WHEN DATEDIFF(DAY,f.StartDate, a.StartDate) BETWEEN 331 AND 360 THEN '331-360'
	END Category
FROM AnnualSubscriptionsTABLE a
JOIN FreeTrialsTABLE f
ON a.CustomerID = f.CustomerID
) SubQuery
ORDER BY Category;

/********* TODO: FIND a better way to write the code above**************/

-- ============== Question 11 ==============
--1.Get the customers on PRO MONTHLY plan into a new table
SELECT s.*, p.PlanName
INTO ProMonthlyTABLE
FROM Subscriptions s
JOIN Plans p
ON p.PlanID =s.PlanID
WHERE LOWER(p.PlanName) = 'pro monthly'

--2.Get the customers on BASIC MONTHLY plan into a seperate table
SELECT s.*, p.PlanName
INTO BasicMonthlyTABLE
FROM Subscriptions s
JOIN Plans p
ON p.PlanID =s.PlanID
WHERE LOWER(p.PlanName) = 'basic monthly'

--3.JOIN the two tables on CustomerID 
SELECT COUNT(*) TotalCustomers		--5.COUNT all the records
FROM ProMonthlyTable pr
JOIN BasicMonthlyTable b
ON pr.CustomerID = b.CustomerID
WHERE b.StartDate > pr.StartDate AND YEAR(b.StartDate) = '2020';	/*	4.WHERE the PRO MONTHLY StartDate < BASIC MONTHLY StartDate
																		AND YEAR( BASIC MONTHLY'S StartDate is 2020)	*/
