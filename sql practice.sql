-- database creation
create database practice;

-- use database
use practice;

-- create table sales
create table sales(
sale_id int primary key,
product_id int ,
quantity_sold int,
sale_date date,
total_price decimal(10,2)
);

-- insertion of data into sales
insert into sales
values
(1, 101, 5, '2024-01-01', 2500.00),
(2, 102, 3, '2024-01-02', 900.00),
(3, 103, 2, '2024-01-02', 60.00),
(4, 104, 4, '2024-01-03', 80.00),
(5, 105, 6, '2024-01-03', 90.00);

-- display sales table
select * from sales;

-- create table product
create table product
(
product_id int primary key,
product_name varchar(20),
category VARCHAR(50),
unit_price DECIMAL(10, 2)
);

-- inserting data into product
insert into product values
(101, 'Laptop', 'Electronics', 500.00),
(102, 'Smartphone', 'Electronics', 300.00),
(103, 'Headphones', 'Electronics', 30.00),
(104, 'Keyboard', 'Electronics', 20.00),
(105, 'Mouse', 'Electronics', 15.00);

-- displaying data of table product
select * from product;

-- Filter the Sales table to show only sales with a total_price greater than $100.
select * from sales
where total_price>100;

-- Filter the Products table to show only products in the 'Electronics' category.
select * from product 
where category ='Electronics';

-- Retrieve the sale_id and total_price from the Sales table for sales made on January 3, 2024.
select * from sales
where sale_date='2024-01-03';

-- Retrieve the product_id and product_name from the Products table for products with a unit_price greater than $100.
select product_id, product_name from product
where unit_price>100;

-- Calculate the total revenue generated from all sales in the Sales table.
select sum(total_price) from sales;

--  Calculate the average unit_price of products in the Products table.
select round(avg(unit_price),0) from product;

-- Calculate the total quantity_sold from the Sales table.
select sum(quantity_sold) from sales;

-- Count Sales Per Day from the Sales table
select count(quantity_sold), sale_date from sales
group by sale_date;

-- Retrieve product_name and unit_price from the Products table with the Highest Unit Price
select product_name, unit_price from product
order by unit_price desc
limit 1;

-- Retrieve the sale_id, product_id, and total_price from the Sales table for sales with a quantity_sold greater than 4.
select sale_id, product_id, total_price from sales
where quantity_sold>4;

--  Retrieve the product_name and unit_price from the Products table, ordering the results by unit_price in descending order.
select product_name, unit_price from product
order by unit_price 
desc;

-- Retrieve the total_price of all sales, rounding the values to two decimal places.
select round(sum(total_price),2) from sales;

-- Retrieve the sale_id and sale_date from the Sales table, formatting the sale_date as 'YYYY-MM-DD'.
select sale_id, date_format(sale_date, '%d-%m-%Y') as formatted_date from sales;

-- Retrieve the product_name and unit_price from the Products table, filtering the unit_price to show only values between $20 and $600.
select product_name, unit_price from product
where unit_price between 20 and 600;

-- Calculate the total quantity_sold of products in the 'Electronics' category.
select sum(quantity_sold) from sales as s
join product as p
on s.product_id=p.product_id
where category="Electronics";

-- Retrieve the product_name and total_price from the Sales table, calculating the total_price as quantity_sold multiplied by unit_price. 
select product_name, quantity_sold*unit_price as total_price from sales as s
join product as p
on s.product_id=p.product_id;

-- Identify the Most Frequently Sold Product from Sales table
select p.product_name, p.product_id, sum(s.quantity_sold) as sale_count from sales s
join product p
on s.product_id=p.product_id
group by p.product_id
order by sale_count desc limit 1;
-- or
select product_name from product as p
join sales s 
on p.product_id=s.product_id
order by quantity_sold desc
limit 1;

-- Find the Products Not Sold from Products table
select product_id from sales
where quantity_sold=0;
-- or
select product_name, quantity_sold from product p
join sales s
on p.product_id=s.product_id
where quantity_sold=0;

-- Calculate the total revenue generated from sales for each product category.
select category, sum(total_price) as total_revenue from sales s
join product p
on s.product_id=p.product_id
group by category;

-- Find the product category with the highest average unit price.
select category, avg(unit_price) as a from product
group by category
order by a desc limit 1;

-- Identify products with total sales exceeding 30.
select product_name, sum(total_price) as t from sales s
join product p
on s.product_id=p.product_id
group by p.product_name
having t>30;

-- Count the number of sales made in each month.
select date_format(sale_date, '%Y-%m') as m , count(*) from sales
group by m;

-- Retrieve Sales Details for Products with 'Smart' in Their Name
select * from sales s
join product p
on s.product_id=p.product_id
where product_name like '%Smart%';

-- Determine the average quantity sold for products with a unit price greater than $100.
select avg(quantity_sold) from sales s
join product p
on s.product_id=p.product_id
where p.unit_price>100;

-- Retrieve the product name and total sales revenue for each product.
select p.product_name, sum(s.total_price) as t from sales s
join product p
on s.product_id=p.product_id
group by product_name;

-- Retrieve the product name and total sales revenue for each product.
select p.product_name, sum(s.quantity_sold*p.unit_price) as total_sales_revenue from sales s
join product p
on s.product_id=p.product_id
group by product_name;

-- Rank products based on total sales revenue.
select p.product_name, sum(s.total_price) as total_revenue, rank() over (order by sum(s.total_price) desc) as rev_rank
from sales s
join product p
on s.product_id=p.product_id
group by p.product_name;

-- Calculate the running total revenue for each product category. 
select p.category, p.product_name, s.sale_date, sum(s.total_price) over (partition by p.category order by s.sale_date) as running_rev
from sales s
join product p
on s.product_id=p.product_id;

-- Categorize sales as "High", "Medium",or "Low" based on total price 
-- (e.g., > $200 is High, $100-$200 is Medium, < $100 is Low).
select sale_id, 
	CASE
		When total_price>200 then "High"
        when total_price between 200 and 100 then "Medium"
        else "Low"
	end as sales_category
from sales;

-- Identify sales where the quantity sold is greater than the average quantity sold.
select * from sales
where quantity_sold>(select avg(quantity_sold) from sales);

-- Extract the month and year from the sale date and count the number of sales for each month.
select year(sale_date) as sale_year, month(sale_date) as sale_month, sum(quantity_sold) AS total_sales
from sales
group by sale_year, sale_month
order by sale_year, salE_month;

-- Calculate the number of days between the current date and the sale date for each sale.
select sale_id, datediff(now(), sale_date) as date_diff
from sales;

-- Identify sales made during weekdays versus weekends.
select sale_id,
		case
			when dayofweek(sale_date) in (1,7) then "Weekend"
            else "Weekday"
		end as day_type
from sales;