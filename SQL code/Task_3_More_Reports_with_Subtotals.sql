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

--b. Reports with proper sub-totals:
--REPORT 3(CUBE)
select cb.COMPANY_BRANCH,ct.DESCRIPTION as customer_type,st.SALES_TIMEID as sales_time,
SUM(sf.TOTAL_SALES_REVENUE) as SALES$
from Company_BranchDIM cb,customer_TypeDIM ct,Sales_TimeDIM st,salesFACT sf
where sf.COMPANY_BRANCH = cb.COMPANY_BRANCH
and ct.CUSTOMER_TYPE_ID = sf.CUSTOMER_TYPE_ID
and st.SALES_TIMEID = sf.SALES_TIMEID
group by cube(cb.COMPANY_BRANCH,ct.DESCRIPTION,st.SALES_TIMEID);

--REPORT 4(Partial CUBE)
select ct.DESCRIPTION as customer_type,cb.COMPANY_BRANCH,st.SALES_TIMEID as sales_time,
SUM(sf.TOTAL_SALES_REVENUE) as SALES$
from Company_BranchDIM cb,customer_TypeDIM ct,Sales_TimeDIM st,salesFACT sf
where sf.COMPANY_BRANCH = cb.COMPANY_BRANCH
and ct.CUSTOMER_TYPE_ID = sf.CUSTOMER_TYPE_ID
and st.SALES_TIMEID = sf.SALES_TIMEID
group by ct.DESCRIPTION,cb.COMPANY_BRANCH,cube(st.SALES_TIMEID);


--REPORT 5(Roll-up)
--Find out the total sales of the business and individual customer type in each company branch, and from the year 2018 to 2020.
select st.SALES_YEAR as sales_time,cb.COMPANY_BRANCH,ct.DESCRIPTION as customer_type,ca.CATEGORY_DESCRIPTION as category,
SUM(sf.TOTAL_SALES_REVENUE) as SALES$
from Company_BranchDIM cb,customer_TypeDIM ct,Sales_TimeDIM st,categoryDIM ca,salesFACT sf
where sf.COMPANY_BRANCH = cb.COMPANY_BRANCH
and ct.CUSTOMER_TYPE_ID = sf.CUSTOMER_TYPE_ID
and st.SALES_TIMEID = sf.SALES_TIMEID
and ca.CATEGORY_ID = sf.CATEGORY_ID
and ct.DESCRIPTION IN('Individual','Business')
and st.SALES_YEAR in ('2018','2019','2020')
group by rollup(st.SALES_YEAR,cb.COMPANY_BRANCH,ct.DESCRIPTION,ca.CATEGORY_DESCRIPTION);


--REPORT 6(Partial Roll-up)
--Find out the total sales of the individual and business category in each company branch of 2020.
select st.SALES_YEAR as sales_time,cb.COMPANY_BRANCH,ct.DESCRIPTION as customer_type,
SUM(sf.TOTAL_SALES_REVENUE) as SALES$
from Company_BranchDIM cb,customer_TypeDIM ct,Sales_TimeDIM st,salesFACT sf
where sf.COMPANY_BRANCH = cb.COMPANY_BRANCH
and ct.CUSTOMER_TYPE_ID = sf.CUSTOMER_TYPE_ID
and st.SALES_TIMEID = sf.SALES_TIMEID
and ct.DESCRIPTION IN('Individual','Business')
and st.SALES_YEAR in ('2020')
group by st.SALES_YEAR,rollup(cb.COMPANY_BRANCH,ct.DESCRIPTION);
