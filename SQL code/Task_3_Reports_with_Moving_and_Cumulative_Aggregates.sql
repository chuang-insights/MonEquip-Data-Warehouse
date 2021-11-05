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

--c. Reports with moving and cumulative aggregates:
--REPORT 7
SELECT t.HIRE_YEAR,
TO_CHAR (SUM(hf.TOTAL_HIRING_REVENUE), '9,999,999,999') AS YEAR_HIRING_REVENUE,
TO_CHAR (SUM(SUM(hf.TOTAL_HIRING_REVENUE)) OVER
(ORDER BY t.HIRE_YEAR
ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM__HIRING_REVENUES
FROM hireFACT hf,Hire_TimeDIM t
WHERE t.HIRE_TIMEID = hf.HIRE_TIMEID
GROUP BY t.HIRE_YEAR;

SELECT t.HIRE_YEAR,C.CATEGORY_DESCRIPTION,
TO_CHAR (SUM(hf.TOTAL_HIRING_REVENUE), '9,999,999,999') AS YEAR_HIRING_REVENUE,
TO_CHAR (SUM(SUM(hf.TOTAL_HIRING_REVENUE)) OVER
(ORDER BY t.HIRE_YEAR
ROWS UNBOUNDED PRECEDING),
'9,999,999,999') AS CUM__HIRING_REVENUES
FROM hireFACT hf,Hire_TimeDIM t,categoryDIM C
WHERE t.HIRE_TIMEID = hf.HIRE_TIMEID
AND c.CATEGORY_ID = hf.CATEGORY_ID
AND CATEGORY_DESCRIPTION = 'Site Equipment'
GROUP BY t.HIRE_YEAR,C.CATEGORY_DESCRIPTION;


--REPORT 8(cumulative aggregates)
--For individual and business customer types, find out the three-month moving average of total sales revenue
SELECT ct.DESCRIPTION as customer_type,s.SALES_TIMEID,
TO_CHAR (SUM(sf.TOTAL_SALES_REVENUE), '9,999,999,999') AS Month_SALES_REVENUE,
TO_CHAR (AVG(SUM(sf.TOTAL_SALES_REVENUE)) OVER
(ORDER BY s.SALES_TIMEID
ROWS 2 PRECEDING),
'9,999,999,999') AS MOVING_3_MONTH_AVG
FROM salesFACT sf,Sales_TimeDIM s,customer_TypeDIM ct
WHERE s.SALES_TIMEID = sf.SALES_TIMEID
AND ct.CUSTOMER_TYPE_ID = sf.CUSTOMER_TYPE_ID
and ct.DESCRIPTION IN('Individual','Business')
GROUP BY ct.DESCRIPTION,s.SALES_TIMEID;

