# Foodie-Fi

## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - 
he wanted to create a new streaming service that only had food related content - something like Netflix but
with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and
annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around
the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and
new features were decided using data. This case study focuses on using subscription style digital data to 
answer important business questions.

## Problem Description
Using subscription style digital data to answer important business questions and ensure all future investment
decision and new features were decided using data.

The provided 2 key datasets for this case study are:

	1.Subscriptions
	2.Plans
Moreover, the case study questions are as follows:

							A. Customer Journey
	Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief 
	description about each customer’s onboarding journey.

	Try to keep it as short as possible - you may also want to run some sort of join to make your explanations
	a bit easier!

							B.Data Analysis Questions
	1.How many customers has Foodie-Fi ever had?
	2.What is the monthly distribution of trial plan start_date values for our dataset - use the start of the
	  month as the group by value
	3.What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of 
	  events for each plan_name
	4.What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
	5.How many customers have churned straight after their initial free trial - what percentage is this rounded
	  to the nearest whole number?
	6.What is the number and percentage of customer plans after their initial free trial?
	7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
	8.How many customers have upgraded to an annual plan in 2020?
	9.How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
	10.Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
	11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

							C.Challenge Payment Question
	The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid
	by each customer in the subscriptions table with the following requirements:

	1.monthly payments always occur on the same day of month as the original start_date of any monthly paid
	  plan
	2.upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and 
	  start immediately
	3.upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts
	  at the end of the month period
	4.once a customer churns they will no longer make payments

							D.Outside The Box Questions
	The following are open ended questions which might be asked during a technical interview for this case study
	- there are no right or wrong answers, but answers that make sense from both a technical and a business 
	perspective make an amazing impression!

	1.How would you calculate the rate of growth for Foodie-Fi?
	2.What key metrics would you recommend Foodie-Fi management to track over time to assess performance of 
	  their overall business?
	3.What are some key customer journeys or experiences that you would analyse further to improve customer
	  retention?
	4.If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription,
	  what questions would you include in the survey?
	5.What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate 
	  the effectiveness of your ideas?

## Technologies used

	1.SQL - to analyse the data
	2.SQL Server Management Studio 21 - to write and execute the SQL queries

## Folder Structure

```
	├── Foodie-Fi/:
		 ├── src /: A text file that contains the answers to the case study questions
			├── Bronze/:
				├── CreateDB.sql:Contains the SQL code to create the database used to store data tables
				└── CreateTables.sql: Contains the SQL code to create tables, and insert data into the tables
			├── Gold/:
				├── AnswersToQuestions.txt: Contains the Case Study questions and answers
				├── SectionA.sql: Contains the cold sql code to answer Section A questions
				├── SectionB.sql: Contains the cold sql code to answer Section B questions
				├── SectionC.sql: Contains the cold sql code to answer Section C questions
				└── SectionD.sql: Contains the cold sql code to answer Section D questions
			└── Silver/:
				├── CreateTables_Silver.sql: Contains the SQL code used to create the tables to store clean data 
				└── DataCleaning.sql: Contains the SQL code used to clean the data loaded in the Bronze layer
		└── ReadME.md: The file you are currently reading, contains information about the project
```
## How to run the SQL code

	1.Download the Foodie-Fi zip folder on Github to your device
	2.Unzip the downloaded folder
	3.Open SQL Server Management Studio
	4.Navigate to the 'File' tab and select 'Open Folder'
	5.Select the unzipped folder
	6.Execute the query in CreateDB.sql file
	7.Execute the queries in CreateTables.sql file
	8.Execute the queries in SectionA.sql, SectionB.sql, SectionC.sql, SectionD.sql in the order they are written

## Project Status

INCOMPLETE

TO DO:

	1.Section C:Challenge Payment Question

## About Me

I am a recent BSc graduate in Applied Mathematics and Computer Science from the University of Johannesburg. With this project, I was actively learning and practising SQL in preparation for junior data roles. 

I welcome connections and conversations regarding opportunities, collaborations, or shared interests in technology and data. Please feel free to reach out through any of the following channels:

*  [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/donald-masine-17a430270/)  [![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:masinedonald@gmail.com)  [![WhatsApp](https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://wa.me/27647266704)  [![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=Tableau&logoColor=white)](https://public.tableau.com/app/profile/donald.masine/vizzes)  [![freeCodeCamp](https://img.shields.io/badge/freeCodeCamp-0A0A23?style=for-the-badge&logo=freecodecamp&logoColor=white)](https://www.freecodecamp.org/masined)
*  **Phone:** +27 71 436 6053


## Acknoledgements

This project is mainly formed by Case Study 2 of the 8WeekSQLChallenge. All the case study details can 
be found on https://8weeksqlchallenge.com/case-study-3/ # Foodie-Fi