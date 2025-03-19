/* RESTAURANT ORDER ANALYSIS MYSQL PROJECT*/
USE restaurant_db;

-- Objective 1: Explore the items table --
-- Your first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the 
-- item prices within each category.
-- 1. View the menu_items table and write a query to find the number of items on the menu --
SELECT * FROM menu_items;

SELECT COUNT(*) AS num_of_items
FROM menu_items;

-- 2. What are the least and most expensive items on the menu? --
SELECT item_name, price
FROM menu_items
ORDER BY price ASC;

SELECT item_name, price
FROM menu_items
ORDER BY price DESC;

-- 3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
SELECT COUNT(menu_item_id) AS num_ital_dish
FROM menu_items
WHERE category = 'Italian';

SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price ASC;

SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC;

-- 4. How many dishes are in each category? What is the average dish price within each category?
SELECT category, COUNT(menu_item_id) AS num_dish, ROUND(AVG(price),2) AS avg_price
FROM menu_items
GROUP BY category;

-- Objective 2: Explore the orders table --
-- Your second objective is to better understand the orders table by finding the date range, the number of items within each order, and the orders 
-- with the highest number of items.
-- 1. View the order_details table. What is the date range of the table?
select * from order_details;

select min(order_date), max(order_date)
from order_details;

-- 2. How many orders were made within this date range? How many items were ordered within this date range?
select count(distinct(order_id)) as num_ord
from order_details;

select count((order_details_id)) as num_items
from order_details;

-- 3. Which orders had the most number of items?
select order_id, count(item_id) as num_items
from order_details
group by order_id
order by num_items desc;

-- 4. How many orders had more than 12 items?
select count(*) from
(select order_id, count(item_id) as num_items
from order_details
group by order_id
having num_items > 12)
as num_items;

-- Objective 3: Analyze customer behavior
-- Your final objective is to combine the items and orders tables, find the least and most ordered categories, and dive into the details of the highest spend orders.
-- 1. Combine the menu_items and order_details tables into a single table
select * from menu_items
inner join order_details
on menu_items.menu_item_id = order_details.item_id;

-- 2. What were the least and most ordered items? What categories were they in?
select item_name, category, count(item_id) as num_items
from 
(select * from menu_items
inner join order_details
on menu_items.menu_item_id = order_details.item_id) as final_data
group by item_id
order by num_items;

select item_name, category, count(item_id) as num_items
from 
(select * from menu_items
inner join order_details
on menu_items.menu_item_id = order_details.item_id) as final_data
group by item_id
order by num_items DESC;

-- 3. What were the top 5 orders that spent the most money?
select order_id, sum(price) as total_price
from 
(select * from menu_items
inner join order_details
on menu_items.menu_item_id = order_details.item_id) as final_data
group by order_id
order by total_price DESC
limit 5;


