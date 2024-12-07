# Amazon E-commerce SQL Project

![Project Banner Placeholder](https://www.catwalkyourself.com/wp-content/uploads/2016/05/Amazon.com-Logo.svg_1.png)

Welcome to my SQL project, where I analyze real-time data from **Amazon.com**! This project uses a dataset of **20,000+ sales records** and additional tables for payments, products, and shipping data to explore and analyze e-commerce transactions, product sales, and customer interactions. The project aims to solve business problems through SQL queries, helping Amazon make informed decisions.

## Table of Contents
- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Business Problems](#business-problems)
- [SQL Queries & Analysis](#sql-queries--analysis)
- [Getting Started](#getting-started)
- [Questions & Feedback](#questions--feedback)
- [Contact Me](#contact-me)

---

## Introduction

This project demonstrates essential SQL skills by analyzing e-commerce data from **Amazon**, focusing on sales, payments, products, and customer data. Through SQL, we answer critical business questions, uncover trends, and derive actionable insights that help improve business strategies and customer experiences. The project covers different SQL techniques including **Joins**, **Group By**, **Aggregations**, and **Date Functions**.

## Project Structure

1. **SQL Scripts**: Contains code to create the database schema and write queries for analysis.
2. **Dataset**: Real-time data representing e-commerce transactions, product details, customer information, and shipping status.
3. **Analysis**: SQL queries crafted to solve business problems, each focusing on understanding e-commerce sales and performance.

---

## Database Schema

Here’s an overview of the database structure:

### 1. **Customers Table**
- **customer_id**: Unique identifier for each customer
- **customer_name**: Name of the customer
- **state**: Location (state) of the customer

### 2. **Products Table**
- **product_id**: Unique identifier for each product
- **product_name**: Name of the product
- **price**: Price of the product
- **cogs**: Cost of goods sold
- **category**: Category of the product
- **brand**: Brand name of the product

### 3. **Sales Table**
- **order_id**: Unique order identifier
- **order_date**: Date the order was placed
- **customer_id**: Linked to the `customers` table
- **order_status**: Status of the order (e.g., Completed, Cancelled)
- **product_id**: Linked to the `products` table
- **quantity**: Quantity of products sold
- **price_per_unit**: Price per unit of the product

### 4. **Payments Table**
- **payment_id**: Unique payment identifier
- **order_id**: Linked to the `sales` table
- **payment_date**: Date the payment was made
- **payment_status**: Status of the payment (e.g., Payment Successed, Payment Failed)

### 5. **Shippings Table**
- **shipping_id**: Unique shipping identifier
- **order_id**: Linked to the `sales` table
- **shipping_date**: Date the order was shipped
- **return_date**: Date the order was returned (if applicable)
- **shipping_providers**: Shipping provider (e.g., Ekart, Bluedart)
- **delivery_status**: Status of delivery (e.g., Delivered, Returned)

## Business Problems

The following queries were created to solve specific business questions. Each query is designed to provide insights based on sales, payments, products, and customer data.

### Easy 
1. `Retrieve a list of all customers with the corresponding product names they ordered.`
```sql
select 
	customers.customer_name,
	products.product_name
from customers
Inner JOIN sales
ON sales.customer_id = customers.customer_id
Inner JOIN products
ON sales.product_id = products.product_id
Order By 1 ASC;
```
2. `List all products and show the details of customers who have placed orders for them. Include products that have no orders.`
```sql
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
```
3. `List all orders and their shipping status. Include orders that do not have any shipping records.`
```sql
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
```

4. `Retrieve all products, including those with no orders, along with their price.`
```sql
select 
	products.product_name,
	products.price,
	sales.price_per_unit
from sales
RIGHT JOIN products
ON sales.product_id = products.product_id;
```
5. `Get a list of all customers who have placed orders, including those with no payment records.`
```sql
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
```
6. `Find the total number of completed orders made by customers from the state 'Delhi'.`
```sql
select 
	COUNT(*) as total_number_of_completed_orders
from customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
Where customers.state = 'Delhi' and sales.order_status = 'Completed';
```
7. `Retrieve a list of products ordered by customers from the state 'Karnataka' with price greater than 10,000.`
```sql
select 
	products.product_name 
FROM customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
INNER JOIN products
ON sales.product_id = products.product_id
Where customers.state = 'Karnataka' and products.price > 10000;
```
8. `List all customers who have placed orders where the product category is 'Accessories' and the order status is 'Completed'.`
```sql
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
```
9. `Show the order details of customers who have paid for their orders, excluding those who have cancelled their orders.`
```sql
select
	*
FROM customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
INNER JOIN payments
ON payments.order_id = sales.order_id
WHERE sales.order_status <> 'Canceled' and payments.payment_status = 'Payment Successed';
```
10. `Retrieve products ordered by customers who are in the 'Gujarat' state and whose total order price is greater than 15,000`
```sql
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
```
11. `List all orders that were placed within the year 2023 (use order_date with the EXTRACT function).`
```sql
select *
from sales
Where Extract(YEAR from order_date) = 2023
Order by order_date ASC;
```
12. `Retrieve customers who have made purchases in the month of January.`
```sql
Select 
	sales.order_id,
	TO_CHAR(sales.order_date, 'Month') as month_name
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Where TO_CHAR(sales.order_date, 'Month') Like '%January%';
```
13. `Show all orders where the shipping date is after the payment date.`
```sql
select * 
from shippings
Inner Join payments
On shippings.order_id = payments.order_id
Where shippings.shipping_date > payments.payment_date;
```
   
### Medium to Hard
1. `Find the total quantity of each product ordered by customers from 'Delhi' and only include products with a quantity greater than 5.`
```sql

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

```

2. `Get the average payment amount per customer who has placed more than 3 orders.`
```sql

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

```
3. `Retrieve the total sales for each product category and only include categories where the total sales exceed 100,000.`
```sql

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

```
4. `Show the number of customers in each state who have made purchases with a total spend greater than 50,000.`
```sql

Select 
	customers.state,
	count(customers.customer_id)
From customers
INNER JOIN sales
ON customers.customer_id = sales.customer_id
Group By 1
HAVING SUM(sales.quantity * sales.price_per_unit) > 5000
ORDER BY count(customers.customer_id) DESC;
```
5. `List the total sales by brand for products that have been ordered more than 10 times.`
```sql

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
```
6. ` Retrieve the total sales per customer in 'Delhi' where the order status is 'Completed', only include those with total sales greater than 50,000, and order the results by total sales.`
```sql
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
```
7. `Show the total quantity sold per product in the 'Accessories' category where the total quantity sold is greater than 50 and order the results by product name`
```sql

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
```
8. `Find the total number of orders for customers from 'Maharashtra' who have spent more than 1,00,000, and order the results by the total amount spent.`
```sql

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
```
9. ` 4. Get the number of orders per product and filter to include only products that have been ordered more than 10 times, then order the results by the highest number of orders.`
```sql
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
```
10. `Retrieve the number of payments made per customer where the payment status is 'Payment Successed' and group by customer, ordering by payment count.` 
```sql

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
```
11. `Calculate the number of days between the payment_date and order_date for each order.`
```sql
select 
	sales.order_date,
	payments.payment_date,
	AGE(payments.payment_date, sales.order_date) as paid_by
from payments
Inner Join sales
On payments.order_id = sales.order_id
Order By paid_by DESC;
```
12. `Find the total sales for each year.`
```sql
select 
	Extract(Year from order_date) as financial_year,
	SUM(quantity * price_per_unit) as total_sales
from sales
Group by 1
Order By 1 ASC;
```
13. `Retrieve all products along with their total sales revenue from completed orders.`
```sql
select 
	products.product_id,
	products.product_name,
	SUM(sales.quantity * sales.price_per_unit) as total_revenue
from products
Inner join sales
On sales.product_id = products.product_id
Where sales.order_status = 'Completed'
Group By 1,2;
```
14. ` List all customers and the products they have purchased, showing only those who have ordered more than two products.`
```sql
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
```
15. `Retrieve the list of all orders that have not yet been shipped.`
```sql

select *
from sales
Left Join shippings
ON sales.order_id = shippings.order_id
Where shipping_id is null;
```
16. `Find the average order value per customer for orders with a quantity of more than 5.`
```sql
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
```
17. `Get the top 5 customers by total spending on 'Accessories'.`
```sql
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
```
18. `Retrieve a list of customers who have not made any payment for their orders.`
```sql
select
	customers.customer_id,
	customers.customer_name
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Inner Join payments
On payments.order_id = sales.order_id
Where payments.payment_status in ('Payment Failed', 'Refunded ');
```
19. `Find the most popular product based on total quantity sold in 2023.`
```sql
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
```
20. `List all orders that were cancelled and the reason for cancellation (if available).`
```sql
select 
 	sales.order_id,
	 payments.payment_status
from sales
Inner Join payments 
ON sales.order_id = payments.order_id
Where sales.order_status = 'Cancelled';
```
21. `Retrieve the total quantity of products sold by category in 2023.`
```sql
select 
	products.category,
	count(sales.order_id)
from products
Inner Join sales
ON sales.product_id = products.product_id
Where Extract(YEAR from sales.order_date) = '2023'
Group By 1;
```
22. `Get the count of returned orders by shipping provider in 2023.`
```sql
select 
	count(*) as returned_orders
from shippings
Where Extract(Year from shipping_date) = '2023' and delivery_status Like '%Returned%';
```
23. `Show the total revenue generated per month for the year 2023.`
```sql
Select 
	SUM(quantity * price_per_unit) as total_revenue
From sales
Where Extract(Year from order_date) = '2023'
````
24. `Find the customers who have made the most purchases in a single month.`
```sql
select 
	Extract(Month from order_date) as order_month,
	customers.customer_id,
	count(sales.order_id)
from customers
Inner Join sales
On customers.customer_id = sales.customer_id
Group by order_month, customers.customer_id
Order By 1 ASC;
```

25. `Retrieve the number of orders made per product category in 2023 and order by total quantity sold.`
```sql
select
	products.category as category,
	Count(sales.order_id) as  total_orders
From products
Inner Join sales
On products.product_id = sales.product_id
Where Extract(YEAR from sales.order_date) = '2023'
Group By products.category
Order by 2 DESC;
```

26. `List the products that have never been ordered (use LEFT JOIN between products and sales).`
```sql

select
	products.product_id,
	products.product_name
From products
Left Join sales
On products.product_id = sales.product_id
Where sales.order_id is null;
```

## SQL Queries & Analysis

The `analysis.sql` file contains all SQL queries developed for this project. Each query corresponds to a business problem and demonstrates skills in SQL syntax, data filtering, aggregation, grouping, and ordering.

---

## Getting Started

### Prerequisites
- PostgreSQL (or any SQL-compatible database)
- Basic understanding of SQL

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/Amazon-sql-project.git
   ```
2. **Set Up the Database**:
   - Run the `schema.sql` script to set up tables and insert sample data.

3. **Run Queries**:
   - Execute each query in `queries.sql` to explore and analyze the data.

---

## Questions & Feedback

Feel free to add your questions and code snippets below and submit them as issues for further feedback!

**Example Questions**:
1. **Question**: How can I filter orders placed in the last 6 months?
   **Code Snippet**:
   ```sql
   SELECT * FROM sales
   WHERE order_date >= CURRENT_DATE - INTERVAL '6 months';
   ```

---

## Contact Me
  
📧 **[Email](mailto:sudhinpillai1998@gmail.com)**    

---

## ERD (Entity-Relationship Diagram)

## Notice:
All customer names and data used in this project are computer-generated using AI and random
functions. They do not represent real data associated with Amazon or any other entity. This
project is solely for learning and educational purposes, and any resemblance to actual persons,
businesses, or events is purely coincidental.

![ERD Placeholder](![Amazon_SQL_Project_ERD_Diagram](https://github.com/user-attachments/assets/1d77c107-be1d-41f3-86ac-f2d86b2b857d)
)
