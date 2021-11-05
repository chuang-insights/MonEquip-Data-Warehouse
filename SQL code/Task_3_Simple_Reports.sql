--B. Data Analytic Stage (10%) -
--3. Create the following reports using OLAP queries

select * from Sales_TimeDIM;
select * from Hire_TimeDIM;
select * from Company_BranchDIM;
select * from categoryDIM;
select * from customer_TypeDIM;
select * from seasonDIM;
select * from sales_Price_ScaleDIM;
select * from salesFACT;
select * from hireFACT;

--a. Simple reports:

--REPORT 1
--Top n RANKING
--Find out the top 10 equipment categories by total sales in 2020.
SELECT *
FROM
(SELECT t.SALES_YEAR,c.CATEGORY_DESCRIPTION, SUM(s.TOTAL_SALES_REVENUE) as SALES$,
RANK() OVER (ORDER BY SUM(TOTAL_SALES_REVENUE) DESC ) AS CATEGORY_RANK
FROM salesFACT s,Sales_TimeDIM t,categoryDIM c
WHERE c.CATEGORY_ID = s.CATEGORY_ID
AND s.SALES_TIMEID = t.SALES_TIMEID
AND t.SALES_YEAR = '2020'
GROUP BY t.SALES_YEAR,c.CATEGORY_DESCRIPTION)
WHERE CATEGORY_RANK <= 10;

--REPORT 2
--Top n% RANKING
--Find out the top 30% company branches by total sales in 2020.
SELECT *
FROM
(SELECT t.SALES_YEAR,c.COMPANY_BRANCH, SUM(s.TOTAL_SALES_REVENUE) as SALES$,
percent_rank() OVER (ORDER BY SUM(TOTAL_SALES_REVENUE) DESC ) AS COMPANY_BRANCH_RANK
FROM salesFACT s,Sales_TimeDIM t,Company_BranchDIM c
WHERE c.COMPANY_BRANCH = s.COMPANY_BRANCH
AND s.SALES_TIMEID = t.SALES_TIMEID
AND t.SALES_YEAR = '2020'
GROUP BY t.SALES_YEAR,c.COMPANY_BRANCH)
WHERE COMPANY_BRANCH_RANK < 0.3;

