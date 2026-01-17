use mysalesdbb;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- list all orders with customer date
select o.order_id,o.order_date,c.name
from orders o join customers c on c.customer_id=o.customer_id
order by o.order_id;

-- show each order with the product purchased
select o.order_id,p.product_name,oi.quantity
from orders o
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
order by o.order_id,p.product_name;

-- find city of each customer who placed an orders
select distinct c.customer_id,c.name,c.city
from customers c
join orders o on o.customer_id=c.customer_id
order by c.name; 

-- display customers who have never placed an order
select c.customer_id,c.name,c.city
from customers c
left join orders o on o.customer_id=c.customer_id
where o.order_id is  null
order by c.name;

-- get total quantity of each product sold
-- (inner join only counts products that were actually sold)
select p.product_id,p.product_name,sum(oi.quantity) as total_units_sold
from products p
join order_items oi on oi.product_id=p.product_id
group by p.product_id,p.product_name
order by total_units_sold desc;

-- find total spending per customer (name+total)
select c.customer_id,c.name,sum(oi.quantity*p.price)as total_spent
from customers c
join orders o on o.customer_id=c.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
group by c.customer_id,c.name
order by total_spent desc;

-- list products that have never been ordered
select p.product_id,p.product_name
from products p
left join order_items oi on oi.product_id=p.product_id
where oi.product_id is null
order by p.product_name;


-- show order detilas(order_id,customer_name,product_name,quantity)
select o.order_id,o.order_date,c.name,p.product_name,oi.quantity
from orders o
join customers c on c.customer_id=o.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
order by order_id,p.product_name;

-- find customers who bought more than 2 different products
select c.customer_id,c.name,
count(distinct oi.product_id)as distinct_products
from customers c
join orders o on o.customer_id=c.customer_id
join order_items oi on oi.order_id=o.order_id
group by c.customer_id,c.name having count(distinct oi.product_id)>2
order by distinct_products desc,c.name;

-- top 5 customer by total revenue
select c.customer_id,c.name,
sum(oi.quantity*p.price)as total_revenue
from customers c
join orders o on o.customer_id=c.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
group by c.customer_id,c.name
order by total_revenue desc
limit 5;

-- each city with total sales revenue
select c.city,sum(oi.quantity*price)as city_revenue
from customers c
join orders o on o.customer_id=c.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
group by city
order by city_revenue desc;

-- which product category sold most units
select p.category,sum(oi.quantity)as total_units
from products p
join order_items oi on oi.product_id=p.product_id
group by p.category
order by total_units desc
limit 1;
-- all order placed in last 120 days 
select o.order_id,o.order_date,c.name,p.product_name,oi.quantity,p.price
from orders o 
join customers c on c.customer_id=o.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
where o.order_date>=curdate()-interval 120 day
order by o.order_date desc,o.order_id;


--
select c.customer_id,c.name,p.product_name,p.price as most_expensive_price
from customers c
join orders o on o.customer_id=c.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
join(
select o.customer_id,max(p.price)as max_price from orders o
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id =oi.product_id
group by o.customer_id)x on x.customer_id=c.customer_id and p.price=x.max_price
order by c.name,p.price desc;

-- each customer with total orders and total tems purchased
select c.customer_id,c.name,
count(distinct o.order_id)as total_orders,
ifnull(sum(oi.quantity),0)as total_items
from customers c
left join orders o on o.customer_id=c.customer_id
left join order_items oi on oi.order_id=o.order_id
group by c.customer_id,c.name
order by total_orders desc,total_items desc,c.name;