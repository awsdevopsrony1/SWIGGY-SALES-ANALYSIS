select * from dim_date;
select * from dim_category;
select * from dim_dish;
select * from dim_dish;
select * from dim_restaurant;
select * from fact_swiggy_orders;


-- adavanced  quesions--
-- 1 Top 5 restaurants by revenue (Ranking)
select * from fact_swiggy_orders;
select * from dim_restaurant;

with cte1 as
(
select r.Restaurant_Name,sum(f.Price_INR) AS total_revnue,
rank()over(ORDER by sum(f.Price_INR) desc) as rn
from fact_swiggy_orders f join dim_restaurant r
on f.restaurant_id= r.restaurant_id
group by r.Restaurant_Name
)
select Restaurant_NAME,total_revnue
from cte1
where rn <= 5;

-- 2. Top dish in each category

select * from fact_swiggy_orders;
select * from dim_category;
select * from dim_dish;


with cte1 as
(
select c.category,d.Dish_name,count(*) as total_orders,
ROW_NUMBER()over(partition by c.category order by count(*) desc) as rn
from fact_swiggy_orders f join dim_category c
on f.category_id=c.category_id
join dim_dish d
on f.dish_id=d.dish_id
group by c.category,d.Dish_name
)
select category,Dish_name,total_orders
from cte1
where rn =1;





-- 3 Top 3 dishes in each city
select * from fact_swiggy_orders;
select * from dim_location;
select * from dim_dish;

with cte1 as
(
select l.city,d.Dish_name,count(*) as orders_count,
ROW_NUMBER()over(partition by l.city order by count(*) desc) as rn
from fact_swiggy_orders f join dim_location l
on f.location_id=l.location_id
join dim_dish d
on f.dish_id=d.dish_id
group by l.city,d.Dish_name
)
select  top 3 city,Dish_name,orders_count
from cte1
where rn  <=3;

-- 4 Restaurants with revenue above average
with restaurant_revenue as
(
    select 
    r.Restaurant_Name,
    sum(f.price_INR) AS revnue
    from fact_swiggy_orders f
    join dim_restaurant r
    on f.restaurant_id=r.restaurant_id
    group by r.Restaurant_Name
)
select Restaurant_Name,revnue
from restaurant_revenue
where revnue >
(
  select avg(revnue)
  from restaurant_revenue
  );
     
