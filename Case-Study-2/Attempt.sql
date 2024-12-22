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
select p.pizza_name, count(c.pizza_id)
from customer_orders c 
join runner_orders r on c.order_id = r.order_id 
join pizza_names p on c.pizza_id = p.pizza_id
where r.cancellation not in ('Customer Cancellation', 'Restaurant Cancellation') or cancellation is null
group by p.pizza_name
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- 6. What was the maximum number of pizzas delivered in a single order?
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- 8. How many pizzas were delivered that had both exclusions and extras?
-- 9. What was the total volume of pizzas ordered for each hour of the day?
-- 10. What was the volume of orders for each day of the week?

--            B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- 4. What was the average distance travelled for each customer?
-- 5. What was the difference between the longest and shortest delivery times for all orders?
-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- 7. What is the successful delivery percentage for each runner?
