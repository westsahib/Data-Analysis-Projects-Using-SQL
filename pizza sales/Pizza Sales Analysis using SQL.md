**Pizza Sales Analysis using SQL**



*This project explores a pizza sales dataset using SQL to answer real business questions. The goal was to move beyond basic querying and understand how data can be used to uncover insights related to revenue, demand, and customer behavior.*



\---

```sql

create table orders(

oid int not null,

odate date not null,

otime time not null,

primary key(oid));

drop table order\_details;

create table order\_details(

ord\_det\_id int primary key,

pizzaid varchar(90) not null,

quan int not null);

```







&#x20;Problem Statements \& SQL Queries



Basic Level



\*\*1. Retrieve the total number of orders placed\*\*



```sql

SELECT COUNT(oid) AS total\_orders

FROM orders;

```



\*\*2. Calculate the total revenue generated from pizza sales\*\*



```sql

SELECT ROUND(SUM(order\_details.quantity \* pizzas.price), 3) AS NetSales

FROM order\_details

JOIN pizzas ON order\_details.pizza\_id = pizzas.pizza\_id;

```



\*\*3. Identify the highest-priced pizza\*\*



```sql

SELECT pizza\_types.name, pizzas.price

FROM pizza\_types

JOIN pizzas ON pizza\_types.pizza\_type\_id = pizzas.pizza\_type\_id

ORDER BY pizzas.price DESC;

```



\*\*4. Identify the most common pizza size ordered\*\*



```sql

SELECT pizzas.size, COUNT(order\_details.order\_details\_id) AS order\_count

FROM pizzas

JOIN order\_details ON pizzas.pizza\_id = order\_details.pizza\_id

GROUP BY pizzas.size

ORDER BY order\_count DESC;

```



\*\*5. List the top 5 most ordered pizza types along with their quantities\*\*



```sql

SELECT pizza\_types.name, SUM(order\_details.quantity) AS total\_quantity

FROM pizza\_types

JOIN pizzas ON pizza\_types.pizza\_type\_id = pizzas.pizza\_type\_id

JOIN order\_details ON pizzas.pizza\_id = order\_details.pizza\_id

GROUP BY pizza\_types.name

ORDER BY total\_quantity DESC

LIMIT 5;

```



\---



Intermediate Level



\*\*6. Find the total quantity of each pizza ordered\*\*



```sql

SELECT pizza\_id, SUM(quantity) AS total\_quantity

FROM order\_details

GROUP BY pizza\_id;

```



\*\*7. Find the total quantity of each pizza category ordered\*\*



```sql

SELECT pizza\_types.category, SUM(order\_details.quantity) AS total\_quantity

FROM pizza\_types

JOIN pizzas ON pizza\_types.pizza\_type\_id = pizzas.pizza\_type\_id

JOIN order\_details ON pizzas.pizza\_id = order\_details.pizza\_id

GROUP BY pizza\_types.category

ORDER BY total\_quantity DESC;

```



\*\*8. Determine the distribution of orders by hour of the day\*\*



```sql

SELECT HOUR(otime) AS hour\_of\_day, COUNT(oid) AS total\_orders

FROM orders

GROUP BY hour\_of\_day

ORDER BY hour\_of\_day;

```



\*\*9. Find category-wise distribution of pizzas (number of variations)\*\*



```sql

SELECT category, COUNT(name) AS variations

FROM pizza\_types

GROUP BY category;

```



\*\*10. Calculate the average number of pizzas ordered per day\*\*



```sql

SELECT ROUND(AVG(total), 0) AS avg\_pizzas\_per\_day

FROM (

&#x20;   SELECT orders.odate, SUM(order\_details.quantity) AS total

&#x20;   FROM orders

&#x20;   JOIN order\_details ON orders.oid = order\_details.order\_id

&#x20;   GROUP BY orders.odate

) AS daily\_orders;

```



\*\*11. Determine the top 3 most ordered pizza types based on revenue\*\*



```sql

SELECT pizza\_types.name AS pizza,

&#x20;      SUM(order\_details.quantity \* pizzas.price) AS revenue

FROM pizza\_types

JOIN pizzas ON pizza\_types.pizza\_type\_id = pizzas.pizza\_type\_id

JOIN order\_details ON pizzas.pizza\_id = order\_details.pizza\_id

GROUP BY pizza

ORDER BY revenue DESC

LIMIT 3;

```



\---



&#x20;Advanced Level



\*\*12. Calculate the percentage contribution of each pizza type to total revenue\*\*



```sql

SELECT pizza\_types.name AS pizza,

&#x20;      ROUND(

&#x20;          SUM(order\_details.quantity \* pizzas.price) /

&#x20;          (SELECT SUM(order\_details.quantity \* pizzas.price)

&#x20;           FROM order\_details

&#x20;           JOIN pizzas ON order\_details.pizza\_id = pizzas.pizza\_id) \* 100, 0

&#x20;      ) AS percentage

FROM pizza\_types

JOIN pizzas ON pizza\_types.pizza\_type\_id = pizzas.pizza\_type\_id

JOIN order\_details ON pizzas.pizza\_id = pizzas.pizza\_id

GROUP BY pizza

ORDER BY percentage DESC;

```



\*\*13. Analyze cumulative revenue generated over time\*\*



```sql

SELECT odate,

&#x20;      SUM(rev) OVER (ORDER BY odate) AS cumulative\_revenue

FROM (

&#x20;   SELECT orders.odate,

&#x20;          SUM(order\_details.quantity \* pizzas.price) AS rev

&#x20;   FROM orders

&#x20;   JOIN order\_details ON orders.oid = order\_details.order\_id

&#x20;   JOIN pizzas ON order\_details.pizza\_id = pizzas.pizza\_id

&#x20;   GROUP BY orders.odate

) AS sales;

```



\*\*14. Determine the top 3 pizzas by revenue within each category\*\*



```sql

SELECT \*

FROM (

&#x20;   SELECT pizza\_types.category AS category,

&#x20;          pizza\_types.name AS pizza,

&#x20;          SUM(order\_details.quantity \* pizzas.price) AS revenue,

&#x20;          RANK() OVER (PARTITION BY pizza\_types.category 

&#x20;                       ORDER BY SUM(order\_details.quantity \* pizzas.price) DESC) AS rank\_position

&#x20;   FROM pizza\_types

&#x20;   JOIN pizzas ON pizza\_types.pizza\_type\_id = pizzas.pizza\_type\_id

&#x20;   JOIN order\_details ON pizzas.pizza\_id = order\_details.pizza\_id

&#x20;   GROUP BY pizza\_types.category, pizza\_types.name

) AS ranked\_pizzas

WHERE rank\_position <= 3;

```



\---

Final Note



This project helped me understand how SQL can be used not just to query data, but to answer meaningful business questions around sales performance, customer behavior, and product demand. It also strengthened my understanding of joins, aggregations, and window functions in a practical setting.



\---



I



