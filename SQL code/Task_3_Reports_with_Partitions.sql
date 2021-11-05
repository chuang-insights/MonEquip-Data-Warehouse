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

--d. Reports with Partitions:
--REPORT 9
SELECT cb.COMPANY_BRANCH, ht.HIRE_TIMEID AS month,
TO_CHAR(SUM(hf.NUM_EQUIPMENT_HIRED)) AS number_of_equipment_hired,
RANK() OVER (PARTITION BY cb.COMPANY_BRANCH
ORDER BY SUM(hf.NUM_EQUIPMENT_HIRED) DESC) AS RANK_BY_COMPANY_BRANCH,
RANK() OVER (PARTITION BY ht.HIRE_TIMEID
ORDER BY SUM(hf.NUM_EQUIPMENT_HIRED) DESC) AS RANK_BY_MONTH
FROM Hire_TimeDIM ht,Company_BranchDIM cb,hireFACT hf
WHERE ht.HIRE_TIMEID = hf.HIRE_TIMEID
AND cb.COMPANY_BRANCH = hf.COMPANY_BRANCH
GROUP BY cb.COMPANY_BRANCH, ht.HIRE_TIMEID
ORDER BY RANK_BY_COMPANY_BRANCH;