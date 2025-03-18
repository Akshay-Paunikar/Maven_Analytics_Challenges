/* RESTAURANT ORDER ANALYSIS MYSQL PROJECT*/
USE restaurant_db;

-- Objective 1: Explore the items table --
-- Your first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the 
-- item prices within each category.
-- 1. View the menu_items table and write a query to find the number of items on the menu --
SELECT * FROM menu_items;

SELECT COUNT(menu_item_id) AS num_of_items
FROM menu_items;

-- 2. What are the least and most expensive items on the menu? --
SELECT item_name, price
FROM menu_items
ORDER BY price ASC
LIMIT 1;

SELECT item_name, price
FROM menu_items
ORDER BY price DESC
LIMIT 1;



