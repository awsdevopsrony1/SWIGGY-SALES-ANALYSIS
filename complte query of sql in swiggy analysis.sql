create database swigyy;
select * from swiggy_data_new;

-- DATA validation and cleaning
-- NULL CHECK--
select
    sum(case when state is null then 1 else 0 end) as null_state,
    sum(case when city  is null then 1 else 0 end) as null_city,
    sum(case when Order_Date is null then 1 else 0 end) as null_order_date,
    sum(case when Restaurant_Name is null then 1 else 0 end) as null_Resaurant_name,
    sum(case when Location is null then 1 else 0 end) as null_location,
    sum(case when Category is null then 1 else 0 end) as null_category,
    sum(case when Dish_Name is null then 1 else 0 end) as Dish_Name,
    sum(case when Price_INR is null then 1 else 0 end) as null_price_INR,
    sum(case when Rating is null then 1 else 0 end) as null_Rating_Count
from swiggy_data_new;

-- Blank/Empty String Check
select *
from swiggy_data_new
where
State='' or City='' or Restaurant_Name='' or Location='' or Category='' or Dish_Name=''

-- Duplicate Detection
select
state,City,Order_Date,Restaurant_Name,Location,Category,Dish_Name,price_INR,rating,rating_count,count(*) as cnt
from swiggy_data_new
group by state,City,Order_Date,Restaurant_Name,Location,Category,Dish_Name,price_INR,rating,rating_count
having count(*) >1;

--Duplicate Duplication
with cte1 as
(
select * ,
ROW_NUMBER()over(partition by state,City,Order_Date,Restaurant_Name,Location,Category,Dish_Name,price_INR,rating,rating_count order by (select null)) as rn
from swiggy_data_new
)
delete from cte1 where rn >1;

-----------------Dimensional Modelling (Star Schema)---------------------------------------
-- creating schema--
-- DATE TABLE-
create table dim_date
(
date_id int IDENTITY(1,1) PRIMARY KEY,
Full_Date DATE,
year INT,
Month INT,
Month_Name varchar(20),
quarter int,
Day int,
Week int
)
select * from dim_date;
--location table--
create table dim_location
(
location_id int identity(1,1) primary key,
state varchar(100),
city varchar(100),
location varchar(200)
);
select * from dim_location;

-- restaurant table --
create table dim_restaurant
(
restaurant_id int identity (1,1) primary key,
Restaurant_Name varchar(200)
);

select * from dim_restaurant;

--- category table ---
create table dim_category
(
category_id int identity(1,1) primary key,
category varchar(200)
);

select * from dim_category;

-- dish table --
create table dim_dish
(
dish_id int identity (1,1) primary key,
Dish_name varchar(200)
);

select * from dim_dish;

-- FACT TABLE---
CREATE TABLE fact_swiggy_orders(
    order_id int identity (1,1) primary key,


    date_id int,
    Price_INR Decimal(10,2),
    Rating Decimal(4,2),
    Rating_count int,

    location_id int,
    restaurant_id int,
    category_id int,
    dish_id int,

    Foreign key (date_id) REFERENCES dim_date(date_id),
    Foreign key (location_id) REFERENCES dim_location(location_id),
    Foreign key (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
    Foreign key (category_id) REFERENCES dim_category(category_id),
    Foreign key (dish_id) REFERENCES dim_dish(dish_id)
    );

    select * from fact_swiggy_orders;
    select * from swiggy_data_new;



    --- insert data into table (DIMENSION TABLE)
    -- dim_date--

insert into dim_date (Full_Date,year,Month,Month_Name,quarter,Day,Week)
select distinct
    order_Date,
    year(order_Date),
    Month(order_Date),
    DATENAME(MONTH,order_Date),
    DATEPART(QUARTER,order_Date),
    DAY(order_Date),
    DATEPART(WEEK,ORDER_DATE)
FROM swiggy_data_new
WHERE Order_Date IS NOT NULL;

SELECT * FROM dim_date;

-- dim location--
insert into dim_location (state,city,location)
select distinct 
    state,
    city,
    location
from swiggy_data_new;

select * from dim_location;
-- dim restaurant --
insert into dim_restaurant (Restaurant_Name)
SELECT DISTINCT
     Restaurant_Name
from swiggy_data_new;

select * from dim_restaurant;

-- dim_category --
insert into dim_category(category)
select distinct
       category
from swiggy_data_new;

select * from dim_category;

-- dim dish--
insert into dim_dish (Dish_name)
select distinct
        Dish_name
from swiggy_data_new

select * from dim_dish;

-- insert into fact table--
insert into fact_swiggy_orders
(
    date_id,
    Price_INR,
    Rating,
    Rating_count,
    location_id,
    restaurant_id,
    category_id,
    dish_id
)
SELECT 
        dd.date_id,
        s.Price_INR,
        s.Rating,
        s.Rating_Count,

        dl.location_id,
        dr.restaurant_id,
        dc.category_id,
        dsh.dish_id
from swiggy_data_new s join dim_date dd  
     on dd.Full_Date=s.Order_Date
     join dim_location dl
     on dl.state=s.State
     AND dl.city=S.City
     and dl.location=s.Location
     join dim_restaurant dr
     on dr.Restaurant_Name=s.Restaurant_Name
     join dim_category dc
     on dc.category=s.Category
     join dim_dish dsh
     on dsh.Dish_name=s.Dish_Name;

select * from fact_swiggy_orders;


select * from dim_date;
select * from  dim_location;
select * from dim_restaurant
select * from dim_category
select * from dim_dish
select * from fact_swiggy_orders;

-- FINAL TABLE--
select * 
from fact_swiggy_orders f join dim_date d
on f.date_id= d.date_id
join dim_location l
on f.location_id= l.location_id
join dim_category c
on f.category_id=c.category_id
join dim_dish di
on f.dish_id=di.dish_id;
---- now we are used dimansion table and fact table ----(dim_data,dim_location,,,,fact_swigy_orders--)

-- KPI Development--
-- 1ans= total orders--
select count(*) as total_orders
from fact_swiggy_orders;

--•	Total Revenue (INR Million)
select sum(Price_INR)
as total_revenue 
from fact_swiggy_orders;
-- BUT QUESTION IS INR MILLION) SO WE HAVE DO IT
select 
format(sum(convert(float,Price_INR))/1000000, 'N2') + 'INR MILLION'
AS TOTAL_REVNUE
from fact_swiggy_orders;
--•	Average Dish Price

select
FORMAT(AVG(CONVERT(FLOAT,Price_INR)), 'N2') + 'INR'
as total_rvn
FROM fact_swiggy_orders;


---AVG RATNG--
SELECT avg(Rating)as avg_rating
from fact_swiggy_orders;


-- Deep-Dive Business Analysis--
-- Date-Based Analysis
-- 1)Monthly order trends

select * from fact_swiggy_orders;
select * from dim_date;

select d.year,d.Month,d.Month_name , count(*) as total_orders
from fact_swiggy_orders f join dim_date d
on f.date_id=d.date_id
group by d.year,d.Month,d.Month_name
order by count(*) desc;

-- 2)Quarterly order trends
select d.year,d.quarter,count(*) as total_orders
from fact_swiggy_orders f join dim_date d
on f.date_id=d.date_id
group by d.year,d.quarter;

-- 3)Year-wise growth
select d.year, count(*) as total_orders
from fact_swiggy_orders f join dim_date d
on f.date_id=d.date_id
group by d.year;

---- 4 ) •	Day-of-week patterns

select 
  DATENAME(weekday, d.full_date) as day_name,
  count(*) as total_orders
from fact_swiggy_orders f join dim_date d
on f.date_id=d.date_id
group by DATENAME(WEEKDAY , d.full_date),DATEPART(WEEKDAY , d.full_date)
order by DATEPART(weekday, d.full_date);

-----------Location-Based Analysis
	1)--Top 10 cities by order volume
	2)--Revenue contribution by states


    select * from dim_location;

--1)
select top 10 l.city,count(*) as total_orders
from fact_swiggy_orders f join dim_location l
on f.location_id = l.location_id
group by l.city
order by count(*) desc;

-- 2)
select l.state,sum(f.Price_INR) as total_revenue
from fact_swiggy_orders f join dim_location l
on f.location_id=l.location_id
group by l.state
order by sum(f.Price_INR) asc;


-- Food Performance
	--1Top 10 restaurants by orders
	--2Top categories (Indian, Chinese, etc.)
	--3Most ordered dishes
	--4Cuisine performance ? Orders + Avg Rating

--1
select top 10 r.restaurant_name,sum(f.Price_INR) as total_Revnue 
from fact_swiggy_orders f join dim_restaurant r
on f.restaurant_id=r.restaurant_id
group by r.restaurant_name
order by sum(f.Price_INR) desc;
--2 
select c.category,count(*) as total_orders
from fact_swiggy_orders f join dim_category c
on f.category_id=c.category_id
group by c.category
order by total_orders desc;

--3
select d.dish_name,count(*) as order_count
from fact_swiggy_orders f join dim_dish d
on f.dish_id=d.dish_id
group by d.Dish_name
order by order_count desc;
-- 4
select c.category,count(*) as total_orders,avg( f.rating) as avg_rating
from fact_swiggy_orders f join dim_category c
on f.category_id= c.category_id
group by c.category
order by total_orders desc;



/*
Customer Spending Insights
Buckets of customer spend:
•	Under 100
•	100–199
•	200–299
•	300–499
•	500+
*/
SELECT
CASE
WHEN Price_INR < 100 THEN 'Under 100'
WHEN Price_INR BETWEEN 100 AND 199 THEN '100-199'
WHEN Price_INR BETWEEN 200 AND 299 THEN '200-299'
WHEN Price_INR BETWEEN 300 AND 499 THEN '300-499'
ELSE '500+'
END AS price_bucket,
COUNT(*) AS orders_count
FROM fact_swiggy_orders
GROUP BY
CASE
WHEN Price_INR < 100 THEN 'Under 100'
WHEN Price_INR BETWEEN 100 AND 199 THEN '100-199'
WHEN Price_INR BETWEEN 200 AND 299 THEN '200-299'
WHEN Price_INR BETWEEN 300 AND 499 THEN '300-499'
ELSE '500+'
END;


-- rating count DIstribution (1-5)
select rating,count(*) as rating_count
from fact_swiggy_orders
group by Rating
order by rating;














