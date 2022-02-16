SELECT * FROM store 
limit 10;
/*COUNTING DISTINCT ORDER_ID VALUES*/
SELECT COUNT(DISTINCT(order_id)) 
FROM store;

/*COUNT DISTINCT CUSTOMER_IDs*/
SELECT COUNT(DISTINCT(customer_id))
FROM store;

/*checking for duplicate data*/
SELECT customer_id, customer_email, customer_phone
FROM store
WHERE customer_id = 1;

SELECT item_1_id, item_1_name, item_1_price
FROM store
WHERE item_1_id = 4;

/*creating tables to normalize store table*/
CREATE TABLE customers AS 
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

/*Adding primary key to customers table*/
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

/*creating item table to normalize store table*/
CREATE TABLE items AS
SELECT DISTINCT item_1_id as item_id,
item_1_name as item_name,
item_1_price as item_price
FROM store
UNION
SELECT DISTINCT item_2_id as item_id,
item_2_name as item_name,
item_2_price as item_price
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT DISTINCT item_3_id as item_id,
item_3_name as item_name,
item_3_price as item_price
FROM store
WHERE item_3_id IS NOT NULL;
/*setting item_id as primary key*/
ALTER TABLE items
ADD PRIMARY KEY (item_id);

CREATE TABLE orders_items AS 
SELECT DISTINCT order_id, item_1_id as item_id
FROM store
UNION ALL
SELECT order_id, item_2_id as item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT order_id, item_3_id as item_id
FROM store
WHERE item_3_id IS NOT NULL;

/*CREATE orders table*/
CREATE TABLE orders AS
SELECT order_id, order_date, customer_id
FROM store;
/*setting primary and secondary keys*/
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id) 
REFERENCES items(item_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (order_id) 
REFERENCES orders(order_id);

/*select emails of customers who made orders after july 25,2019 FROM store from unnormalized table*/
SELECT customer_email FROM store
WHERE order_date > '2019-07-25';

/*select emails of customers who made orders after july 25,2019 FROM store from normalized table*/
SELECT customer_email
FROM customers, orders
WHERE customers.customer_id = orders.customer_id
AND orders.order_date > '2019-07-25';

/*select item_id and count the number of times a distinct item was ordered FROM store unnormalized table*/
WITH all_items AS (
SELECT item_1_id as item_id 
FROM store
UNION ALL
SELECT item_2_id as item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT item_3_id as item_id
FROM store
WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id; 

/*select item_id and count the number of times a distinct item was ordered normalized table*/
SELECT item_id, COUNT(order_id)
FROM orders_items
GROUP BY item_id;
