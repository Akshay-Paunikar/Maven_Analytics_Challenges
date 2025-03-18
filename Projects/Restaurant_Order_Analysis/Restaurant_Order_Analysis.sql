/* RESTAURANT ORDER ANALYSIS MYSQL PROJECT*/
USE restaurant_db;

-- Objective 1: Explore the items table --
-- Your first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the 
-- item prices within each category.
-- 1. View the menu_items table and write a query to find the number of items on the menu --
SELECT * FROM menu_items;

SELECT COUNT(menu_items.menu_item_id) AS num_of_items
FROM menu_items;