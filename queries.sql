SET search_path TO practise;

-- Customer Analysis
-- Find the total number of customers and categorize them based on their membership status.

SELECT c.membership_status , COUNT(*)
FROM practise.customers c 
GROUP BY c.membership_status;

-- Calculate the average amount spent by each customer in the last 6 months.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    AVG(s.total_amount) AS average_sales
FROM practise.sales s 
INNER JOIN practise.customers c 
    ON s.customer_id = c.customer_id
WHERE s.sale_date >= (
    SELECT MAX(sale_date) - INTERVAL '6 months'
    FROM practise.sales
)
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY average_sales DESC;


-- List the top 5 customers who have spent the most in the past year.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    AVG(s.total_amount) AS average_sales
FROM practise.sales s 
INNER JOIN practise.customers c 
    ON s.customer_id = c.customer_id
WHERE s.sale_date >= (
    SELECT MAX(sale_date) - INTERVAL '1 year'
    FROM practise.sales
)
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY average_sales DESC
LIMIT 5;


-- Product Performance
-- Find the most sold product by quantity in the last month.

SELECT 
	p.product_name AS most_sold,
	SUM(s.quantity_sold) AS total_quantity_sold
FROM practise.products p 
INNER JOIN practise.sales s 
	ON p.product_id = s.product_id
WHERE s.sale_date >= (
	SELECT MAX(sale_date) - INTERVAL '1 month'
	FROM practise.sales
)
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- Find the least sold product by quantity in the last month.

SELECT 
	p.product_name AS most_sold,
	SUM(s.quantity_sold) AS total_quantity_sold
FROM practise.products p 
INNER JOIN practise.sales s 
	ON p.product_id = s.product_id
WHERE s.sale_date >= (
	SELECT MAX(sale_date) - INTERVAL '1 month'
	FROM practise.sales
)
GROUP BY p.product_name
ORDER BY total_quantity_sold ASC
LIMIT 1;

-- Calculate the total sales per product (revenue) in the last quarter.

SELECT 
	p.product_name, 
	SUM(s.total_amount) AS revenue
FROM practise.products p 
INNER JOIN practise.sales s 
	ON s.product_id = p.product_id
WHERE s.sale_date >= (
	SELECT MAX(sale_date) - INTERVAL '3 months'
	FROM practise.sales 
)
GROUP BY p.product_name
ORDER BY revenue DESC;

-- Sales Analysis:
-- Calculate the total sales revenue generated in the last month.

SELECT 
	SUM(s.total_amount) AS revenue_lastmonth
FROM practise.sales s
WHERE s.sale_date >= (
	 SELECT MAX(sale_date) - INTERVAL '1 month'
	 FROM practise.sales s2 
);

-- Identify the peak sales days of the week and suggest which days are best for promotions.

SELECT 
    TO_CHAR(s.sale_date, 'Day') AS day_of_week,
    --EXTRACT(DOW FROM s.sale_date) AS day_number,  -- Sunday = 0, Saturday = 6
    SUM(s.total_amount) AS total_revenue,
    COUNT(*) AS total_sales
FROM practise.sales s
GROUP BY day_of_week
ORDER BY total_revenue DESC;

-- Find the products that generated the highest revenue in the last three months

SELECT 
    p.product_name, 
    SUM(s.total_amount) AS revenue
FROM 
    practise.products p 
INNER JOIN 
    practise.sales s 
ON 
    p.product_id = s.product_id
WHERE 
    s.sale_date >= (
        SELECT MAX(sale_date) - INTERVAL '3 months'
        FROM practise.sales
    )
GROUP BY 
    p.product_name 
ORDER BY 
    revenue DESC;

