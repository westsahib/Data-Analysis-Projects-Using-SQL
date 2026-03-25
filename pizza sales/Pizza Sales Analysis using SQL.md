Pizza Sales Analysis using SQL

This project explores a pizza sales dataset using SQL to answer real business questions. The goal was to move beyond basic querying and understand how data can be used to uncover insights related to revenue, demand, and customer behavior.

---
```sql
create table orders(
oid int not null,
odate date not null,
otime time not null,
primary key(oid));
drop table order_details;
create table order_details(
ord_det_id int primary key,
pizzaid varchar(90) not null,
quan int not null);
```



 Problem Statements & SQL Queries

Basic Level

**1. Retrieve the total number of orders placed**

```sql
SELECT COUNT(oid) AS total_orders
FROM orders;
```

**2. Calculate the total revenue generated from pizza sales**

```sql
SELECT ROUND(SUM(order_details.quantity * pizzas.price), 3) AS NetSales
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;
```

**3. Identify the highest-priced pizza**

```sql
SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;
```

**4. Identify the most common pizza size ordered**

```sql
SELECT pizzas.size, COUNT(order_details.order_details_id) AS order_count
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;
```

**5. List the top 5 most ordered pizza types along with their quantities**

```sql
SELECT pizza_types.name, SUM(order_details.quantity) AS total_quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;
```

---

Intermediate Level

**6. Find the total quantity of each pizza ordered**

```sql
SELECT pizza_id, SUM(quantity) AS total_quantity
FROM order_details
GROUP BY pizza_id;
```

**7. Find the total quantity of each pizza category ordered**

```sql
SELECT pizza_types.category, SUM(order_details.quantity) AS total_quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;
```

**8. Determine the distribution of orders by hour of the day**

```sql
SELECT HOUR(otime) AS hour_of_day, COUNT(oid) AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY hour_of_day;
```

**9. Find category-wise distribution of pizzas (number of variations)**

```sql
SELECT category, COUNT(name) AS variations
FROM pizza_types
GROUP BY category;
```

**10. Calculate the average number of pizzas ordered per day**

```sql
SELECT ROUND(AVG(total), 0) AS avg_pizzas_per_day
FROM (
    SELECT orders.odate, SUM(order_details.quantity) AS total
    FROM orders
    JOIN order_details ON orders.oid = order_details.order_id
    GROUP BY orders.odate
) AS daily_orders;
```

**11. Determine the top 3 most ordered pizza types based on revenue**

```sql
SELECT pizza_types.name AS pizza,
       SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza
ORDER BY revenue DESC
LIMIT 3;
```

---

 Advanced Level

**12. Calculate the percentage contribution of each pizza type to total revenue**

```sql
SELECT pizza_types.name AS pizza,
       ROUND(
           SUM(order_details.quantity * pizzas.price) /
           (SELECT SUM(order_details.quantity * pizzas.price)
            FROM order_details
            JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100, 0
       ) AS percentage
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = pizzas.pizza_id
GROUP BY pizza
ORDER BY percentage DESC;
```

**13. Analyze cumulative revenue generated over time**

```sql
SELECT odate,
       SUM(rev) OVER (ORDER BY odate) AS cumulative_revenue
FROM (
    SELECT orders.odate,
           SUM(order_details.quantity * pizzas.price) AS rev
    FROM orders
    JOIN order_details ON orders.oid = order_details.order_id
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY orders.odate
) AS sales;
```

**14. Determine the top 3 pizzas by revenue within each category**

```sql
SELECT *
FROM (
    SELECT pizza_types.category AS category,
           pizza_types.name AS pizza,
           SUM(order_details.quantity * pizzas.price) AS revenue,
           RANK() OVER (PARTITION BY pizza_types.category 
                        ORDER BY SUM(order_details.quantity * pizzas.price) DESC) AS rank_position
    FROM pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
    GROUP BY pizza_types.category, pizza_types.name
) AS ranked_pizzas
WHERE rank_position <= 3;
```

---
Final Note

This project helped me understand how SQL can be used not just to query data, but to answer meaningful business questions around sales performance, customer behavior, and product demand. It also strengthened my understanding of joins, aggregations, and window functions in a practical setting.

---

I
