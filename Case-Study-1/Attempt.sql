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

-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
