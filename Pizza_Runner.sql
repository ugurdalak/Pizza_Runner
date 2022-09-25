CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
--_______________________________________________________________________________________
select * from pizza_runner.customer_orders; --order_id,customer_id,pizza_id,exclusions,extras,order_time
select * from pizza_names pn ; --pizza_id,pizza_name
select * from pizza_recipes pr; --pizza_id,toppings
select * from pizza_toppings pt; --topping_id,topping_name
select * from runner_orders ro ; --order_id,runner_id,pickup_time,distance,duration,cancellation
select * from runners r ; --runner_id,registration_date


--
--DML 
--customer_orders table data cleaning
select 
    order_id,
    customer_id,
    pizza_id,
    case 
        when exclusions = 'null' then null
        else exclusions
    end as exclusions,
    case 
        when extras = 'null' then null
        else extras
    end as extras,
    order_time
into table customer_orders_upd
from customer_orders;
select * from customer_orders_upd; 
update customer_orders_upd set exclusions='null' where exclusions is null;
update customer_orders_upd set exclusions='null' where exclusions='';
update customer_orders_upd set extras='null' where extras is null;
update customer_orders_upd set extras='null' where extras='';
--runner_orders table data cleaning
select
	order_id,
	runner_id,
	case
		when pickup_time is null then 'null'
		else pickup_time end as pickup_time,
	case
			when distance like 'null' then 'null'
			when distance like '%km' then trim('km' from distance)
			else distance
		end as distance,
		case
			when duration like 'null' then 'null'
			when duration like '%mins' then TRIM('mins' from duration)
			when duration like '%minute' then TRIM('minute' from duration)
			when duration like '%minutes' then TRIM('minutes' from duration)
			else duration
		end as duration,
		case
			when cancellation is null
			or cancellation like 'null' then 'null'
			else cancellation
		end as cancellation
into
	table runner_orders_upd
from
	runner_orders;
select * from runner_orders_upd ;
update runner_orders_upd set cancellation='null' where order_id =1 ;
update runner_orders_upd set cancellation='null' where order_id =2;

--column checks--
select * from customer_orders_upd cou ; --order_id,customer_id,pizza_id,exclusions,extras,order_time
select * from pizza_names pn ; --pizza_id,pizza_name
select * from pizza_recipes pr; --pizza_id,toppings
select * from pizza_toppings pt; --topping_id,topping_name
select * from runner_orders_upd rou ; --order_id,runner_id,pickup_time,distance,duration,cancellation
select * from runners r ; --runner_id,registration_date
____________________________________________________________________________________________________________________________
--A. Pizza Metrics
--How many pizzas were ordered?
 select
	count(*) as pizza_orders
from
	customer_orders co;
	--How many unique customer orders were made?
select 
	count(distinct order_id) as unique_orders
from
	customer_orders co;
	--How many successful orders were delivered by each runner?
select
	runner_id,
	count(*) as order_count
from
	runner_orders_upd rou
where
	cancellation = 'null'
group by
	runner_id;
	--How many of each type of pizza was delivered?
	
select
	pn.pizza_name ,
	count(pn.pizza_id) as deliveredp
from
	customer_orders_upd cou
join pizza_names pn 
on
	cou.pizza_id = pn.pizza_id
join runner_orders_upd rou 
on
	rou.order_id = cou.order_id
where
	rou.cancellation = 'null'
group by
	pizza_name ;
	--How many Vegetarian and Meatlovers were ordered by each customer?
select
	cou.customer_id,
	pn.pizza_name,
	count(pn.pizza_id) as countofp
from
	customer_orders_upd cou
join pizza_names pn 
on
	cou.pizza_id = pn.pizza_id
group by
	customer_id ,
	pizza_name
order by
	customer_id ;

--What was the maximum number of pizzas delivered in a single order?
with maxpcount as
(
select
	cou.order_id,
	count(cou.pizza_id) as countofp
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null'
group by
	cou.order_id
order by
	2 desc)
select
	max(countofp) as maxpizzac
from
	maxpcount;

	--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select
	customer_id,
	sum(case when exclusions != 'null' or extras != 'null' then 1 else 0 end) as at_least_1_change,
	sum(case when exclusions = 'null' or extras = 'null' then 1 else 0 end) as no_change
from
	customer_orders_upd cou
join runner_orders_upd rou 
on
	cou.order_id = rou.order_id
where
	cancellation = 'null'
group by
	customer_id ;
	--How many pizzas were delivered that had both exclusions and extras?
select
	sum(case when exclusions != 'null' and extras != 'null' then 1 else 0 end) as both_exc_and_ext
from
	customer_orders_upd cou
join runner_orders_upd rou 
on
	cou.order_id = rou.order_id
where
	cancellation = 'null';
    --query check
select
	pizza_id ,
	exclusions ,
	extras,
	cancellation
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	exclusions != 'null'
	and extras != 'null'
	and cancellation = 'null';
	--What was the total volume of pizzas ordered for each hour of the day?
select
	date_part('hour', order_time) as hour_of_the_day,
	count(order_id) as pizzac
from
	customer_orders_upd cou
group by
	date_part('hour', order_time)
order by
	hour_of_the_day;
	--What was the volume of orders for each day of the week?
select
	to_char(cou.order_time, 'DAY'),
	count(order_id) as order_number
from
	customer_orders_upd cou
group by
	to_char(cou.order_time , 'DAY')
order by
	2 desc ;
	--B. Runner and Customer Experience
	--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01) 
select extract('week' from registration_date+3) sign_week,
count(runner_id) as n_of_runner
from runners r 
group by extract('week' from registration_date+3)
order by 1;

select * from runners r; 
	--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select
	runner_id,
	avg(to_timestamp((case when pickup_time = 'null' then null else pickup_time end), 'YYYY-MM-DD HH24:MI')-order_time) as avgtime
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null'
group by
	runner_id;
	--Is there any relationship between the number of pizzas and how long the order takes to prepare?

select
	cou.order_id,
	count(pizza_id) as nofpizza,
	order_time,
	pickup_time,
	to_timestamp((case when pickup_time = 'null' then null else pickup_time end), 'YYYY-MM-DD HH24:MI:SS')-order_time as timediff,
	(to_timestamp((case when pickup_time = 'null' then null else pickup_time end), 'YYYY-MM-DD HH24:MI:SS')-order_time)/ count(pizza_id) as perpizza
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null'
group by
	cou.order_id,
	order_time,
	pickup_time,
	timediff
order by
	1;
--It seems the average time to per pizza is around 10 mins(Except 8th order)
	--What was the difference between the longest and shortest delivery times for all orders?
with delivery_time as 
(
select
	cou.order_id,
	count(pizza_id) as nofpizza,
	order_time,
	pickup_time,
	to_timestamp((case when pickup_time = 'null' then null else pickup_time end), 'YYYY-MM-DD HH24:MI:SS')-order_time as timediff
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null'
group by
	cou.order_id,
	order_time,
	pickup_time,
	timediff
order by
	1)
select
	max(timediff)-min(timediff)
from
	delivery_time;
	--What was the average speed for each runner for each delivery and do you notice any trend for these values?
select
	runner_id,
	cou.order_id,
	distance,
	duration,
	round(distance::decimal / duration::decimal * 60, 2) as average_speed
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null'
group by
	rou.runner_id,
	cou.order_id,
	rou.distance,
	rou.duration
order by
	1;
	--What is the successful delivery percentage for each runner?
with t as
(
select
	runner_id,
	cou.order_id,
	case
		when cancellation = 'null' then '1'
		else '0'
	end as status
from
	runner_orders_upd rou
join customer_orders_upd cou on
	rou.order_id = cou.order_id
group by
	runner_id,
	cou.order_id,
	cancellation
order by
	1) 
select
	runner_id,
	concat('% ',(round(sum(status::decimal)/ count(*), 2)* 100))
from
	t
group by
	runner_id
	--C. Ingredient Optimisation
--______________________________________________________________
--creating a merged table for toppings-- 

with 
toppings_c as 
(select
	pizza_id,
	regexp_split_to_table(toppings, ',')::integer as toppings
from
	pizza_recipes pr)
select
	pizza_id,
	topping_id,
	topping_name
	into toppings_table
from
	toppings_c
join pizza_toppings pt on
	pt.topping_id = toppings_c.toppings
;
_______________________________________________________________
	--What are the standard ingredients for each pizza?
select * from toppings_table tt 
order by pizza_id ;
	--What was the most commonly added extra?
with common_added as
(select order_id, regexp_split_to_table(extras, ',')::integer as topping_id from customer_orders_upd cou
where extras != 'null')
select topping_name,count(tt.topping_id)
from toppings_table tt join common_added ca on ca.topping_id=tt.topping_id 
group by tt.topping_name
order by 2 desc;
	--What was the most common exclusion? 
with com_exc as
(
select
	regexp_split_to_table(exclusions, ', ')::integer as exclusions
from
	customer_orders_upd cou
where
	exclusions != 'null')
select
	topping_name,
	count(exclusions)
from
	com_exc
left join (
	select
		distinct topping_id,
		topping_name
	from
		toppings_table) tt on
	com_exc.exclusions = tt.topping_id
group by
	topping_name
order by
	2 desc;
	--D. Pricing and Ratings
	--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
with price as 
(
select
	cou.pizza_id ,
	case
		when pizza_id = 1 then 12
		else 10
	end as amount
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null')
select
	sum(amount)
from
	price;
--What if there was an additional $1 charge for any pizza extras? 
select sum(t_cost) from
(with ext_cost as
(
select
	order_id,
	pizza_id,
	regexp_split_to_table(extras, ',') as extras,
	(case
		when extras = 'null' then 1
		else 0
	end) as nl
from
	customer_orders_upd cou
group by
	order_id,
	pizza_id,
	extras
order by
	order_id)
select
	order_id,
	count(extras)+(case when pizza_id=1 then 12 else 10 end)-nl as t_cost
from
	ext_cost
 group by order_id,pizza_id,nl) t;

select * from customer_orders_upd cou;
	--Add cheese is $1 extra
	--The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
create table rating_orders
	(order_id integer,
	 rating_delivery integer,
	 review varchar(max)
	 )
	 insert
	into
	rating_orders
	 (order_id,
	rating,
	review)
values
	 ()
	 
    --Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
	--customer_id
	--order_id
	--runner_id
	--rating
	--order_time
	--pickup_time
	--Time between order and pickup
	--Delivery duration
	--Average speed
	--Total number of pizzas	 
select
	customer_id,
	cou.order_id,
	runner_id,
	order_time,
	pickup_time,
	duration,
	to_timestamp((case when pickup_time = 'null' then null else pickup_time end), 'YYYY-MM-DD HH24:MI:SS')-order_time as timediff, 
	count(pizza_id) as total_num_of_pizza,
	(case
		when distance = 'null' then null
		else distance
	end)::real /(case
		when duration = 'null' then null
		else duration
	end)::real*60 as average_speed,
	distance
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	duration != 'null'
group by
	customer_id,
	cou.order_id,
	rou.runner_id,
	cou.order_time,
	rou.pickup_time,
	rou.duration,
	rou.distance ;

select
	*
from
	customer_orders_upd cou ;
	--If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
with left_over as
(with dist_cost as
(
select
	cou.order_id,
	pizza_id,
	distance,
	round((rou.distance::decimal * 0.3), 2) as distancecost,
	cancellation
from
	customer_orders_upd cou
join runner_orders_upd rou on
	cou.order_id = rou.order_id
where
	cancellation = 'null')
select
	case
		when pizza_id = 1 then 12-distancecost
		else 10-distancecost
	end as left_over
from
	dist_cost)
select
	sum(left_over) as total_left_over
from
	left_over;