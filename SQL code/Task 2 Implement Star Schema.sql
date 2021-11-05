select * from MONEQUIP.customer_type;
select * from MONEQUIP.customer;
select * from MONEQUIP.address;
select * from MONEQUIP.category;
select * from MONEQUIP.equipment;
select * from MONEQUIP.hire;
select * from MONEQUIP.sales;
select * from MONEQUIP.staff;

----------------------------
--Data exploration
--Check for duplicate data
----customer_type
select count(CUSTOMER_TYPE_ID) from MONEQUIP.customer_type; --outcome: 2
select count(distinct CUSTOMER_TYPE_ID) from MONEQUIP.customer_type; --outcome: 2
----data before: customer
select count(CUSTOMER_ID) from MONEQUIP.customer;--outcome: 153
select count(distinct CUSTOMER_ID) from MONEQUIP.customer;--outcome: 150

--references from week3 UseLogDW_ExploringAndCleaning
SELECT CUSTOMER_ID, COUNT(*) AS duplicate_CUSTOMER_ID
FROM MONEQUIP.customer
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > 1;

select * 
from MONEQUIP.customer
where customer_id = 52;

----address
select count(ADDRESS_ID) from MONEQUIP.address;--outcome:150
select count(distinct ADDRESS_ID) from MONEQUIP.address;--outcome:150

----category
select count(CATEGORY_ID)from MONEQUIP.category; --outcome:15
select count(distinct CATEGORY_ID)from MONEQUIP.category; --outcome:15

----equipment
select count(EQUIPMENT_ID)from MONEQUIP.equipment; --outcome:158
select count(distinct EQUIPMENT_ID)from MONEQUIP.equipment; --outcome:158

----hire
select count(HIRE_ID) from MONEQUIP.hire; --outcome:305
select count(distinct HIRE_ID) from MONEQUIP.hire; --outcome:305

----sales
select count(SALES_ID)from MONEQUIP.sales; --outcome:151
select count(distinct SALES_ID)from MONEQUIP.sales; --outcome:151

----staff
select count(STAFF_ID)from MONEQUIP.staff; --outcome:50
select count(distinct STAFF_ID)from MONEQUIP.staff; --outcome:50

-------------------------------------------------------
--Check for null data
----customer_type
select * from MONEQUIP.customer_type;
select * from MONEQUIP.customer_type where CUSTOMER_TYPE_ID is null;
----customer
select * from MONEQUIP.customer;
select * from MONEQUIP.customer where CUSTOMER_ID is null;

----category
select * from MONEQUIP.category;
select * from MONEQUIP.category where category_id is null;
select * from MONEQUIP.category where category_description is null;

select * from MONEQUIP.category where category_description = 'null';

select * from MONEQUIP.equipment where category_id = 15;

----address
select * from MONEQUIP.address;
select * from MONEQUIP.address where ADDRESS_ID is null;

----equipment
select * from MONEQUIP.equipment;
select * from MONEQUIP.equipment where EQUIPMENT_ID is null;

----hire
select * from MONEQUIP.hire;
select * from MONEQUIP.hire where HIRE_ID is null;

----sales
select * from MONEQUIP.sales;
select * from MONEQUIP.sales where SALES_ID is null;

----staff
select * from MONEQUIP.staff;
select * from MONEQUIP.staff where STAFF_ID is null;


--------------------------------------
--Check for invalid data
select address_id from MONEQUIP.customer
where address_id 
not in (select address_id from MONEQUIP.address);

select CUSTOMER_TYPE_ID from MONEQUIP.customer
where CUSTOMER_TYPE_ID
not in (select CUSTOMER_TYPE_ID from MONEQUIP.customer_type);

select CUSTOMER_ID from MONEQUIP.hire
where CUSTOMER_ID
not in (select CUSTOMER_ID from MONEQUIP.customer); --CUSTOMER_ID:181

select STAFF_ID from MONEQUIP.hire
where STAFF_ID
not in (select STAFF_ID from MONEQUIP.staff);--staff_id:85,123,174,223

select * from MONEQUIP.hire where STAFF_ID in(85,123,174,223);

select STAFF_ID from MONEQUIP.sales
where STAFF_ID
not in (select STAFF_ID from MONEQUIP.sales);

select CUSTOMER_ID from MONEQUIP.sales
where CUSTOMER_ID
not in (select CUSTOMER_ID from MONEQUIP.customer);

select EQUIPMENT_ID from MONEQUIP.sales
where EQUIPMENT_ID
not in (select EQUIPMENT_ID from MONEQUIP.equipment);

select EQUIPMENT_ID from MONEQUIP.hire
where EQUIPMENT_ID
not in (select EQUIPMENT_ID from MONEQUIP.equipment);--EQUIPMENT_ID:190

select CATEGORY_ID from MONEQUIP.equipment
where CATEGORY_ID
not in (select CATEGORY_ID from MONEQUIP.category);

select * from MONEQUIP.sales where QUANTITY <0;--QUANTITY: -3

select * from MONEQUIP.hire where TOTAL_HIRE_PRICE <0; --TOTAL_HIRE_PRICE:-150,-1

select * from MONEQUIP.hire where START_DATE > END_DATE; --hire_id: 302,305


-----------------------------------
--drop tables if existing
drop table customer_type CASCADE CONSTRAINTS;
drop table customer CASCADE CONSTRAINTS;
drop table address CASCADE CONSTRAINTS;
drop table category CASCADE CONSTRAINTS;
drop table equipment CASCADE CONSTRAINTS;
drop table hire CASCADE CONSTRAINTS;
drop table sales CASCADE CONSTRAINTS;
drop table staff CASCADE CONSTRAINTS;

--Copy the tables from MONEQUIP account.
create table customer_type as
select distinct *
from MONEQUIP.customer_type;

create table customer as
select distinct *
from MONEQUIP.customer;

create table address as
select distinct *
from MONEQUIP.address;

create table category as
select distinct *
from MONEQUIP.category;

create table equipment as
select distinct *
from MONEQUIP.equipment;

create table hire as
select distinct *
from MONEQUIP.hire;

create table sales as
select distinct *
from MONEQUIP.sales;

create table staff as
select distinct *
from MONEQUIP.staff;

---------------------------------
--check the new tables
---------------------------------
select * from customer_type;
select * from customer;
select * from address;
select * from category;
select * from equipment;
select * from hire;
select * from sales;
select * from staff;


---------------------------------
--Data cleaning
---------------------------------

----after data cleaning: customer
select count(CUSTOMER_ID) from customer;--outcome: 150
select count(distinct CUSTOMER_ID) from customer;--outcome: 150

select * 
from customer
where customer_id = 52;

----after data cleaning: category;
UPDATE category
SET CATEGORY_DESCRIPTION = 'excavator'
WHERE CATEGORY_ID = 15;
commit;

select * from category;

----after data cleaning: invalid CUSTOMER_ID;
delete from hire where CUSTOMER_ID =181;
commit;

select CUSTOMER_ID from hire
where CUSTOMER_ID
not in (select CUSTOMER_ID from customer); 

select * from hire where CUSTOMER_ID =181;


----after data cleaning: invalid STAFF_ID in hire table;
delete from hire where STAFF_ID in(85,123,174,223);
commit;

select STAFF_ID from hire
where STAFF_ID
not in (select STAFF_ID from staff);

----after data cleaning: invalid EQUIPMENT_ID in hire table;
delete from hire where EQUIPMENT_ID =190;
commit;

select EQUIPMENT_ID from hire
where EQUIPMENT_ID
not in (select EQUIPMENT_ID from equipment);

----after data cleaning: invalid QUANTITY in sales table;
update sales
set QUANTITY = TOTAL_SALES_PRICE/ UNIT_SALES_PRICE
where QUANTITY <0;
commit;

select * from sales where SALES_ID =151;

----after data cleaning: invalid TOTAL_HIRE_PRICE in hire table;
select * from hire where TOTAL_HIRE_PRICE <0;

----after data cleaning: invalid date in hire table;
delete from hire where START_DATE > END_DATE; 
commit;

select * from hire where START_DATE > END_DATE;

--------------------------------------------------
--Implement version 1 star schema 
--------------------------------------------------
--Create Sales_TimeDIM table.
drop table Sales_TimeDIM CASCADE CONSTRAINTS;
create table Sales_TimeDIM
as select distinct
to_char(SALES_DATE, 'YYYYMM') as Sales_TimeID,
to_char(SALES_DATE, 'MM') as Sales_Month,
to_char(SALES_DATE, 'YYYY') as Sales_Year
from Sales;

select * from Sales_TimeDIM order by SALES_TIMEID;

--Create Hire_TimeDIM table.
drop table Hire_TimeDIM CASCADE CONSTRAINTS;
create table Hire_TimeDIM
as select distinct
to_char(START_DATE, 'YYYYMM') as Hire_TimeID,
to_char(START_DATE, 'MM') as Hire_Month,
to_char(START_DATE, 'YYYY') as Hire_Year
from hire;

select * from Hire_TimeDIM order by Hire_TimeID;

--Create Company_BranchDIM table.
drop table Company_BranchDIM CASCADE CONSTRAINTS;

create table Company_BranchDIM as
select distinct COMPANY_BRANCH
from staff;

select * from Company_BranchDIM;

--Create categoryDIM table.
drop table categoryDIM CASCADE CONSTRAINTS;

create table categoryDIM as 
select distinct * 
from category;

select * from categoryDIM;

--Create customertypeDIM table.
drop table customer_TypeDIM CASCADE CONSTRAINTS;

create table customer_TypeDIM as 
select distinct * 
from customer_type;

select * from customer_TypeDIM;

--Create seasonDIM table.
drop table seasonDIM CASCADE CONSTRAINTS;
create table seasonDIM
(
seasonID number(1),
season_Name varchar2(20),
season_Description varchar2(20)
);

Insert into seasonDIM values(1,'spring','September - November');
Insert into seasonDIM values(2,'summer','December - February');
Insert into seasonDIM values(3,'autumn','March - May');
Insert into seasonDIM values(4,'winter','June - August');
commit;

select* from seasonDIM;

--Create sales_Price_ScaleDIM table.
drop table sales_Price_ScaleDIM CASCADE CONSTRAINTS;

create table sales_Price_ScaleDIM
(
sales_Price_ScaleID number(1),
sales_Price_Scale varchar2(20),
sales_Price_Scale_Description varchar2(40)
);

Insert into sales_Price_ScaleDIM values(1,'low','sales <$5,000');
Insert into sales_Price_ScaleDIM values(2,'medium','sales between $5,000 and $10,000');
Insert into sales_Price_ScaleDIM values(3,'high','sales >$10,000');
commit;

select * from sales_Price_ScaleDIM;


--Create temp_salesFACT table.
drop table temp_salesFACT CASCADE CONSTRAINTS;
create table temp_salesFACT as
select sales.SALES_DATE,customer.CUSTOMER_TYPE_ID,equipment.CATEGORY_ID,staff.COMPANY_BRANCH,sales.QUANTITY,sales.TOTAL_SALES_PRICE
from sales,customer,equipment,staff
where customer.customer_id = sales.customer_id
and staff.staff_id = sales.staff_id
and sales.equipment_id = equipment.equipment_id;

select * from temp_salesFACT;

--add Sales_TimeID,seasonID,sales_Price_ScaleID columns
ALTER TABLE temp_salesFACT 
ADD 
(
Sales_TimeID number(10),
seasonID number(1),
sales_Price_ScaleID number(1)
);

--set Sales_TimeID values
update temp_salesFACT 
set Sales_TimeID = to_char(SALES_DATE, 'YYYYMM');

--To update the temp_salesFACT to turn SALES_DATE into season
update temp_salesFACT
set seasonID = 1
where to_char(SALES_DATE, 'MM') >= '09'
and to_char(SALES_DATE, 'MM') <= '11';

update temp_salesFACT
set seasonID = 3
where to_char(SALES_DATE, 'MM') >= '03'
and to_char(SALES_DATE, 'MM') <= '05';

update temp_salesFACT
set seasonID = 4
where to_char(SALES_DATE, 'MM') >= '06'
and to_char(SALES_DATE, 'MM') <= '08';

update temp_salesFACT
set seasonID = 2
where seasonID is null;

--To update the temp_salesFACT to turn TOTAL_SALES_PRICE into sales_Price_ScaleID
update temp_salesFACT
set SALES_PRICE_SCALEID = 1
where TOTAL_SALES_PRICE < 5000;

update temp_salesFACT
set SALES_PRICE_SCALEID = 2
where TOTAL_SALES_PRICE >= 5000
and TOTAL_SALES_PRICE <= 10000;

update temp_salesFACT
set SALES_PRICE_SCALEID = 3
where TOTAL_SALES_PRICE > 10000;

--To create SalesFACT
drop table salesFACT CASCADE CONSTRAINTS;

create table SalesFACT as
select
SALES_TIMEID,SEASONID,SALES_PRICE_SCALEID,CUSTOMER_TYPE_ID,CATEGORY_ID,COMPANY_BRANCH,
sum(TOTAL_SALES_PRICE) as Total_Sales_Revenue,
sum(QUANTITY) as Num_Equipment_Sold
from temp_salesFACT
group by SALES_TIMEID,SEASONID,SALES_PRICE_SCALEID,CUSTOMER_TYPE_ID,CATEGORY_ID,COMPANY_BRANCH;

select * from salesFACT;

--Create temp_hireFACT table.
drop table temp_hireFACT CASCADE CONSTRAINTS;
create table temp_hireFACT as
select hire.START_DATE,customer.CUSTOMER_TYPE_ID,equipment.CATEGORY_ID,staff.COMPANY_BRANCH,hire.QUANTITY,hire.TOTAL_HIRE_PRICE
from hire,customer,equipment,staff
where customer.customer_id = hire.customer_id
and hire.staff_id = staff.staff_id
and hire.equipment_id = equipment.equipment_id;

select * from temp_hireFACT;

--add Hire_TimeID,seasonID columns
ALTER TABLE temp_hireFACT
ADD 
(
Hire_TimeID number(10),
seasonID number(1)
);

--set HIRE_TIMEID values
update temp_hireFACT 
set HIRE_TIMEID = to_char(START_DATE, 'YYYYMM');

--To update the temp_hireFACT to turn SALES_DATE into season
update temp_hireFACT
set seasonID = 1
where to_char(START_DATE, 'MM') >= '09'
and to_char(START_DATE, 'MM') <= '11';

update temp_hireFACT
set seasonID = 3
where to_char(START_DATE, 'MM') >= '03'
and to_char(START_DATE, 'MM') <= '05';

update temp_hireFACT
set seasonID = 4
where to_char(START_DATE, 'MM') >= '06'
and to_char(START_DATE, 'MM') <= '08';

update temp_hireFACT
set seasonID = 2
where seasonID is null;

--To create hireFACT
drop table hireFACT CASCADE CONSTRAINTS;

create table hireFACT as
select
HIRE_TIMEID,SEASONID,TOTAL_HIRE_PRICE,CUSTOMER_TYPE_ID,CATEGORY_ID,COMPANY_BRANCH,
sum(TOTAL_HIRE_PRICE) as Total_Hiring_Revenue,
sum(QUANTITY) as Num_Equipment_Hired
from temp_hireFACT
group by HIRE_TIMEID,SEASONID,TOTAL_HIRE_PRICE,CUSTOMER_TYPE_ID,CATEGORY_ID,COMPANY_BRANCH;

select * from hireFACT;

