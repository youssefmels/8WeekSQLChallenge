/* --------------------
   Case Study Questions
   --------------------*/
--          A. Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT count(*) as Number_of_Pizzas_Ordered from customer_orders;
-- 2. How many unique customer orders were made?
SELECT count(distinct(order_id)) as Unique_Customer_Orders from customer_orders;
-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, count(distinct(order_id)) from runner_orders where cancellation NOT in ('Customer Cancellation', 'Restaurant Cancellation') or cancellation is NULL group by runner_id
-- 4. How many of each type of pizza was delivered?
select p.pizza_name, count(c.pizza_id) as Total_pizzas_deliveredfrom
from customer_orders c 
join runner_orders r on c.order_id = r.order_id 
join pizza_names p on c.pizza_id = p.pizza_id
where r.cancellation not in ('Customer Cancellation', 'Restaurant Cancellation') or cancellation is null
group by p.pizza_name
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, p.pizza_name, count(c.pizza_id) from customer_orders c 
join pizza_names p on c.pizza_id = p.pizza_id 
group by p.pizza_name, c.customer_id;
-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT c.order_id, count(c.pizza_id) as Total_pizzas_deliveredfrom customer_orders c
join runner_orders r on c.order_id = r.order_id 
where r.cancellation not in ('Customer Cancellation', 'Restaurant Cancellation') or cancellation is null
group by c.order_id order by Total_pizzas_ordered desc limit 1;
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id, count(pizza_id),
sum(CASE WHEN (c.exclusions is not null and length(c.exclusions) > 0 and c.exclusions <> 'null') or 
    (c.extras is not null and length(c.extras) > 0 and c.extras <> 'null') then 1 else 0 end) as at_least_1_change,
sum(CASE WHEN (c.exclusions is not null and length(c.exclusions) > 0 and c.exclusions <> 'null') or 
    (c.extras is not null and length(c.extras) > 0 and c.extras <> 'null') then 0 else 1 end)  as No_changes
from customer_orders c
join runner_orders r on c.order_id = r.order_id 
where (r.cancellation not in ('Customer Cancellation','Restaurant Cancellation') or cancellation is null)
group by c.customer_id order by c.customer_id;
-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT
sum(CASE WHEN (c.exclusions is not null and length(c.exclusions) > 0 and c.exclusions <> 'null') and 
    (c.extras is not null and length(c.extras) > 0 and c.extras <> 'null') then 1 else 0 end) as Pizzas_with_Exclusions_and_Extras
from customer_orders c
join runner_orders r on c.order_id = r.order_id 
where (r.cancellation not in ('Customer Cancellation','Restaurant Cancellation') or cancellation is null);
-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT DATE_PART('HOUR', order_time) as hour, count(c.pizza_id) as Total_Pizzas from customer_orders c group by hour order by hour;
-- 10. What was the volume of orders for each day of the week?
SELECT DATE_PART('DOW', order_time) as Day_of_week, count(c.pizza_id) as Total_Pizzas from customer_orders c group by Day_of_week order by Day_of_week;

--            B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
	DATE_TRUNC('week', registration_date) + INTERVAL '4 days' as Week, COUNT(runner_id) from runners
   group by DATE_TRUNC('week', registration_date) + INTERVAL '4 days';
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
	avg(EXTRACT(EPOCH FROM (r.pickup_time::timestamp - c.order_time)/60)) as Time, r.runner_id 
	from customer_orders c join runner_orders r on c.order_id = r.order_id where pickup_time <> 'null' 
group by r.runner_id
-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH CTE AS (SELECT
	ROUND((EXTRACT(EPOCH FROM (r.pickup_time::timestamp - c.order_time))/60)::numeric, 0) as Time,
    count(c.pizza_id) as num_pizzas, c.order_id from
    customer_orders c join runner_orders r on c.order_id = r.order_id
    where pickup_time <> 'null' 
group by c.order_id, r.pickup_time, c.order_time)

SELECT num_pizzas, round(avg(Time), 0) as Time from CTE group by num_pizzas order by num_pizzas
-- 4. What was the average distance travelled for each customer?
SELECT
	round(avg(replace(distance, 'km', '')::numeric), 1) as Int_Distance, customer_id from
    customer_orders c join runner_orders r on c.order_id = r.order_id
    where pickup_time <> 'null' group by customer_id
-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(SUBSTRING(duration,'[0-9]+')::int) - MIN(SUBSTRING(duration, '[0-9]+')::int) as Time_Difference FROM runner_orders
-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT runner_id, order_id, 
ROUND(AVG(REPLACE(distance,'km','')::numeric/(SUBSTRING(duration, '[0-9]+')::numeric)), 3) as Speed 
FROM runner_orders where distance <> 'null' group by runner_id, order_id order by runner_id, order_id
-- 7. What is the successful delivery percentage for each runner?
select runner_id, 
ROUND(SUM(
CASE
	WHEN
    		(cancellation NOT in ('Customer Cancellation', 'Restaurant Cancellation') or cancellation is NULL) THEN 1 
	ELSE 0
    	END)/count(order_id)::numeric * 100,0) as Successful_Deliveries_Percentage
from runner_orders 
group by runner_id
