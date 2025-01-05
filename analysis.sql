select * from customers;

select * from payments;

select * from products where product_id = 123;

select * from sales;

select * from shippings;


-- Joins - SQL

-- 1. Retrieve a list of all customers with the corresponding product names they ordered (use an INNER JOIN between customers and sales tables).

select 
	customers.customer_name,
	products.product_name
from customers
Inner JOIN sales
ON sales.customer_id = customers.customer_id
Inner JOIN products
ON sales.product_id = products.product_id
Order By 1 ASC;

-- 2. List all products and show the details of customers who have placed orders for them. Include products that have no orders (use a LEFT JOIN between products and sales tables).

select 
	products.product_name as Product,
	customers.customer_name as Customer
from products
LEFT JOIN sales
ON products.product_id = sales.product_id
LEFT JOIN customers
ON customers.customer_id = sales.customer_id
GROUP BY 1, 2
ORDER BY 1 ASC;

-- 3. List all orders and their shipping status. Include orders that do not have any shipping records (use a LEFT JOINbetween sales and shippings tables).


select 
	sales.order_id,
	sales.order_date,
	sales.order_status,
	shippings.shipping_date,
	shippings.shipping_providers,
	shippings.delivery_status
from sales
LEFT JOIN shippings
ON sales.order_id = shippings.order_id;

-- 4. Retrieve all products, including those with no orders, along with their price. Use a RIGHT JOIN between the products and sales tables.


select 
	products.product_name,
	products.price,
	sales.price_per_unit
from sales
RIGHT JOIN products
ON sales.product_id = products.product_id;

-- 5. Get a list of all customers who have placed orders, including those with no payment records. Use a FULL OUTER JOIN between the customers and payments tables.


select 
	Distinct(customers.customer_id),
	customers.customer_name,
	sales.order_id,
	payments.payment_id
from customers
LEFT JOIN sales
ON customers.customer_id = sales.customer_id
LEFT JOIN payments
ON payments.order_id = sales.order_id;


-- Joins + Where Clause

-- 1. Find the total number of completed orders made by customers from the state 'Delhi' (use INNER JOIN between customers and sales and apply a WHERE condition).

select 
	COUNT(*) as total_number_of_completed_orders
from customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
Where customers.state = 'Delhi' and sales.order_status = 'Completed';


-- 2. Retrieve a list of products ordered by customers from the state 'Karnataka' with price greater than 10,000 (use INNER JOIN between sales, customers, and products).

select 
	products.product_name 
FROM customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
INNER JOIN products
ON sales.product_id = products.product_id
Where customers.state = 'Karnataka' and products.price > 10000;

-- 3. List all customers who have placed orders where the product category is 'Accessories' and the order status is 'Completed' (use INNER JOIN with sales, customers, and products).


select
	DISTINCT(customers.customer_id),
	customers.customer_name
FROM customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
INNER JOIN products
ON sales.product_id = products.product_id
Where sales.order_status = 'Completed' and products.category = 'Accessories'
ORDER BY 1 ASC;


-- 3. Show the order details of customers who have paid for their orders, excluding those who have cancelled their orders (use INNER JOIN between sales and payments and apply WHERE for order_status).

select
	*
FROM customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
INNER JOIN payments
ON payments.order_id = sales.order_id
WHERE sales.order_status <> 'Canceled' and payments.payment_status = 'Payment Successed';

-- 4. Retrieve products ordered by customers who are in the 'Gujarat' state and whose total order price is greater than 15,000 (use INNER JOIN between sales, customers, and products)

select
	customers.customer_id,
	products.product_name,
	sales.quantity,
	sales.price_per_unit,
	customers.state
FROM customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
INNER JOIN products
ON sales.product_id = products.product_id
Where customers.state = 'Gujarat' and (sales.quantity * sales.price_per_unit) > 15000;

-- Joins + Group BY + Having

-- 1. Find the total quantity of each product ordered by customers from 'Delhi' and only include products with a quantity greater than 5 (use INNER JOIN with sales, customers, and products and group by product).

select 
	products.product_name,
	count(products.product_id) as total_quantity
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join products
ON products.product_id = sales.product_id
Where customers.state = 'Delhi'
GROUP BY 1
HAVING count(products.product_id) > 5
ORDER BY 2 DESC;


-- 2. Get the average payment amount per customer who has placed more than 3 orders (use INNER JOIN between paymentsand sales, group by customer, and apply a HAVING clause).

select 
	customers.customer_id,
	customers.customer_name,
	COUNT(customers.customer_id) as total_orders_placed,
	AVG(sales.quantity * sales.price_per_unit)
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join payments
ON payments.order_id = sales.order_id
GROUP BY 1, 2
HAVING COUNT(customers.customer_id) > 3
ORDER BY 4 DESC;

-- 3. Retrieve the total sales for each product category and only include categories where the total sales exceed 100,000 (use INNER JOIN between sales and products, group by category).

select distinct(order_status) from sales;

select 
	products.category,
	SUM(sales.quantity * sales.price_per_unit) as total_sales
from sales
INNER JOIN products
ON sales.product_id = products.product_id
WHERE sales.order_status = 'Completed'
GROUP BY 1
HAVING SUM(sales.quantity * sales.price_per_unit) > 100000;

-- 4. Show the number of customers in each state who have made purchases with a total spend greater than 50,000 (use INNER JOIN between sales and customers).

Select 
	customers.state,
	count(customers.customer_id)
From customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
Group By 1
HAVING SUM(sales.quantity * sales.price_per_unit) > 5000
ORDER BY count(customers.customer_id) DESC;


-- 5. List the total sales by brand for products that have been ordered more than 10 times (use INNER JOIN between salesand products, group by brand).

select 
	products.brand,
	-- sales.product_id,
	-- products.product_name,
	SUM(sales.quantity * sales.price_per_unit) as total_sales
	-- count(sales.product_id)
from sales
Inner Join products
On sales.product_id = products.product_id
Group By 1
Having count(sales.product_id) > 10
Order by products.brand ASC;


-- Joins + WHERE + Group BY + HAVING + ORDER BY

-- 1. Retrieve the total sales per customer in 'Delhi' where the order status is 'Completed', only include those with total sales 
--    greater than 50,000, and order the results by total sales (use INNER JOIN between sales and customers).

select 
	customers.customer_id,
	customers.customer_name,
	customers.state,
	SUM(sales.quantity * sales.price_per_unit) as total_sales
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Where customers.state = 'Delhi' and sales.order_status = 'Completed'
Group By 1,2,3
Having SUM(sales.quantity * sales.price_per_unit) > 50000
ORDER By total_sales;


-- 2. Show the total quantity sold per product in the 'Accessories' category where the total quantity sold is greater than 50 
--    and order the results by product name (use INNER JOIN between sales and products).


select 
	products.product_id,
	products.product_name,
	count(products.product_id)
from products
Inner Join sales
On products.product_id = sales.product_id
Where products.category = 'Accessories'
Group By 1,2
Having count(products.product_id) > 50
Order By 2;


-- 3. Find the total number of orders for customers from 'Maharashtra' who have spent more than 1,00,000, 
--    and order the results by the total amount spent (use INNER JOIN between sales and customers).


select 
	customers.customer_id,
	customers.customer_name,
	SUM(sales.quantity * sales.price_per_unit) as total_expenditure
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Where customers.state = 'Maharashtra'
Group By 1,2
Having SUM(sales.quantity * sales.price_per_unit) > 100000
Order by total_expenditure DESC;


-- 4. Get the number of orders per product and filter to include only products that have been ordered more than 10 times, 
--    then order the results by the highest number of orders (use INNER JOIN between sales and products).


select 
	products.product_id,
	products.product_name,
	count(sales.order_id) as number_of_times_ordered
from products
Inner Join sales
On products.product_id = sales.product_id
Group By 1, 2
Having count(sales.order_id) > 10
Order By 3 DESC;


-- 5. Retrieve the number of payments made per customer where the payment status is 'Payment Successed' and group by customer, 
--    ordering by payment count (use INNER JOIN between payments and customers).

select 
	customers.customer_id,
	customers.customer_name,
	count(payments.payment_id) as number_of_payments
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join payments
On payments.order_id = sales.order_id
Where payments.payment_status = 'Payment Successed'
Group By 1,2
Order By number_of_payments DESC;

-- DATE FUNCTIONS

-- 1. List all orders that were placed within the year 2023 (use order_date with the EXTRACT function).

select *
from sales
Where Extract(YEAR from order_date) = 2023
Order by order_date ASC;

-- 2. Retrieve customers who have made purchases in the month of January (use order_date and TO_CHAR to extract the month).

Select 
	sales.order_id,
	TO_CHAR(sales.order_date, 'Month') as month_name
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Where TO_CHAR(sales.order_date, 'Month') Like '%January%';


-- 3. Calculate the number of days between the payment_date and order_date for each order (use the AGE function).

select 
	sales.order_date,
	payments.payment_date,
	AGE(payments.payment_date, sales.order_date) as paid_by
from payments
Inner Join sales
On payments.order_id = sales.order_id
Order By paid_by DESC;

-- 4. Find the total sales for each year (use EXTRACT with order_date to group by year).

select 
	Extract(Year from order_date) as financial_year,
	SUM(quantity * price_per_unit) as total_sales
from sales
Group by 1
Order By 1 ASC;


-- 5. Show all orders where the shipping date is after the payment date (use date comparison).

select * 
from shippings
Inner Join payments
On shippings.order_id = payments.order_id
Where shippings.shipping_date > payments.payment_date;


-- Business Queries

-- 1. Retrieve all products along with their total sales revenue from completed orders.
select 
	products.product_id,
	products.product_name,
	SUM(sales.quantity * sales.price_per_unit) as total_revenue
from products
Inner join sales
On sales.product_id = products.product_id
Where sales.order_status = 'Completed'
Group By 1,2;

-- 2. List all customers and the products they have purchased, showing only those who have ordered more than two products.


select 
	customers.customer_id,
	customers.customer_name,
	-- count(customers.customer_name)
	products.product_name
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join products
On products.product_id = sales.product_id
Group By 1,2,3
Having count(customers.customer_name) > 2
Order By customers.customer_id;

-- 3. Find the total amount spent by customers in 'Gujarat' who have ordered products priced greater than 10,000.


-- select 
-- 	customers.customer_id,
-- 	customers.customer_name,
-- 	SUM(sales.quantity * sales.price_per_unit) as total_spent
-- from customers
-- Inner join sales
-- On customers.customer_id = sales.customer_id
-- Where customers.state = 'Gujarat';


-- select 
-- 	distinct(customers.customer_id)
-- from customers
-- Inner join sales
-- On customers.customer_id = sales.customer_id
-- Where sales.price_per_unit > 10000; 



-- 4. Retrieve the list of all orders that have not yet been shipped.

select *
from sales
Left Join shippings
ON sales.order_id = shippings.order_id
Where shipping_id is null;

-- 5. Find the average order value per customer for orders with a quantity of more than 5.

select 
	customers.customer_id,
	customers.customer_name,
	SUM(sales.quantity * sales.price_per_unit) / count(order_id) as avg_order_value
from customers
Inner Join sales
ON customers.customer_id = sales.customer_id
Where sales.quantity > 5
Group By 1, 2
Order by 3 DESC;

-- 6. Get the top 5 customers by total spending on 'Accessories'.


select 
	customers.customer_id,
	customers.customer_name,
	SUM(sales.quantity * sales.price_per_unit) as total_spending
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join products
On products.product_id = sales.product_id
Where products.category = 'Accessories'
Group By 1, 2
Order by 3 DESC
LIMIT 5;


-- 7. Retrieve a list of customers who have not made any payment for their orders.


select
	customers.customer_id,
	customers.customer_name
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join payments
On payments.order_id = sales.order_id
Where payments.payment_status in ('Payment Failed', 'Refunded ');



-- 8. Find the most popular product based on total quantity sold in 2023.

select 
	products.product_id,
	products.product_name,
	Count(sales.order_id) as total_sold
From products
Inner Join sales
On products.product_id = sales.product_id
Where Extract(YEAR from order_date) = '2023'
Group by 1,2
Order by 3 DESC
LIMIT 1;

-- 9.List all orders that were cancelled and the reason for cancellation (if available).

 select 
 	sales.order_id,
	 payments.payment_status
from sales
Inner Join payments 
ON sales.order_id = payments.order_id
Where sales.order_status = 'Cancelled';


-- 10. Retrieve the total quantity of products sold by category in 2023.

select 
	products.category,
	count(sales.order_id)
from products
Inner Join sales
ON sales.product_id = products.product_id
Where Extract(YEAR from sales.order_date) = '2023'
Group By 1;


-- 11. Get the count of returned orders by shipping provider in 2023.

select 
	count(*) as returned_orders
from shippings
Where Extract(Year from shipping_date) = '2023' and delivery_status Like '%Returned%';


-- 12.Show the total revenue generated per month for the year 2023.

Select 
	SUM(quantity * price_per_unit) as total_revenue
From sales
Where Extract(Year from order_date) = '2023'


-- 13. Find the customers who have made the most purchases in a single month.


select 
	Extract(Month from order_date) as order_month,
	customers.customer_id,
	count(sales.order_id)
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Group by order_month, customers.customer_id
Order By 1 ASC;


-- 14. Retrieve the number of orders made per product category in 2023 and order by total quantity sold.
select
	products.category as category,
	Count(sales.order_id) as  total_orders
From products
Inner Join sales
On products.product_id = sales.product_id
Where Extract(YEAR from sales.order_date) = '2023'
Group By products.category
Order by 2 DESC;

-- 15. List the products that have never been ordered (use LEFT JOIN between products and sales).
select
	products.product_id,
	products.product_name
From products
Left Join sales
On products.product_id = sales.product_id
Where sales.order_id is null;









































































































																																						   
