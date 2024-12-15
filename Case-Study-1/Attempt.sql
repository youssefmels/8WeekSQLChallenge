/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT
  	s.customer_id,
    sum(m.price)
FROM dannys_diner.sales s join dannys_diner.menu m on s.product_id = m.product_id
group BY s.customer_id;
-- 2. How many days has each customer visited the restaurant?
SELECT
  	s.customer_id,
    count(distinct(s.order_date))
FROM dannys_diner.sales s
group BY s.customer_id;
-- 3. What was the first item from the menu purchased by each customer?
SELECT customer_id, product_name, order_date
FROM (
  SELECT s.customer_id, s.order_date,  m.product_name,
         RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS date_rank,
         ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS date_row
  FROM dannys_diner.sales s
  JOIN menu m ON s.product_id = m.product_id
) AS subquery
WHERE date_row = 1;
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
WITH most_popular_item AS (
  SELECT m.product_name, COUNT(*) as total_purchases
  FROM dannys_diner.sales s
  JOIN dannys_diner.menu m ON s.product_id = m.product_id
  GROUP BY m.product_name
  ORDER BY total_purchases DESC
  LIMIT 1
)
SELECT 
  mpi.product_name, 
  mpi.total_purchases,
  s.customer_id,
  COUNT(*) as customer_item_purchases
FROM most_popular_item mpi
JOIN dannys_diner.menu m ON m.product_name = mpi.product_name
JOIN dannys_diner.sales s ON s.product_id = m.product_id
GROUP BY mpi.product_name, mpi.total_purchases, s.customer_id
-- 5. Which item was the most popular for each customer?
SELECT *
  FROM (
    SELECT s.customer_id ,m.product_id, m.product_name, count(s.product_id),
    RANK() OVER(PARTITION BY customer_id ORDER BY count(s.product_id) desc) as product_rank
    FROM dannys_diner.sales s
  JOIN dannys_diner.menu m ON s.product_id = m.product_id
group by m.product_name, m.product_id, s.customer_id
    ) as subquery
    where product_rank = 1
-- 6. Which item was purchased first by the customer after they became a member?
SELECT *
  FROM (
    SELECT s.customer_id ,m.product_name, a.join_date, s.order_date,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) as product_rank
    FROM dannys_diner.sales s
  JOIN dannys_diner.members a ON a.customer_id = s.customer_id
   JOIN dannys_diner.menu m ON m.product_id = s.product_id
 where s.order_date >= a.join_date
    
    ) as subquery
    where product_rank = 1
-- 7. Which item was purchased just before the customer became a member?
WITH CTE AS
  (
    SELECT s.customer_id ,m.product_name, a.join_date, s.order_date,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date desc) as product_rank,
    ROW_NUMBER () OVER(PARTITION BY s.customer_id ORDER BY s.order_date desc) as prod_row
    FROM dannys_diner.sales s
  JOIN dannys_diner.members a ON a.customer_id = s.customer_id
   JOIN dannys_diner.menu m ON m.product_id = s.product_id
 where s.order_date < a.join_date
    )
    select * from cte where product_rank = 1;
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
