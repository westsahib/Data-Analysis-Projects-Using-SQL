-- Create and use database
CREATE DATABASE base;
USE base;

-- Q1 (Basic): Convert the 'amount' column into numeric format for analysis
ALTER TABLE choco 
MODIFY amount DECIMAL(15,3) NOT NULL;

-- Q2 (Basic): Find total number of transactions in the dataset
SELECT COUNT(*)
FROM choco;

-- Q3 (Basic): Clean the 'amount' column by removing '$' and commas
SET SQL_SAFE_UPDATES = 0;
UPDATE choco 
SET amount = REPLACE(REPLACE(amount, '$', ''), ',', '');

-- Q4 (Intermediate): Calculate total revenue by country and rank them
SELECT country,
       SUM(amount) AS Total_Revenue,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS CountryRank
FROM choco
GROUP BY country 
ORDER BY Total_Revenue DESC;

-- Q5 (Intermediate): Analyze salesperson performance (revenue, orders, ranking)
SELECT salesperson,
       SUM(amount) AS Sales,
       COUNT(*) AS orders,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS SalesPersonRank
FROM choco
GROUP BY salesperson;

-- Q6 (Basic): Count number of sales records per country
SELECT country,
       COUNT(salesperson)
FROM choco
GROUP BY country;

-- Q7 (Intermediate): Identify top 5 products based on revenue
SELECT *
FROM (
    SELECT product,
           SUM(amount),
           RANK() OVER (ORDER BY SUM(amount) DESC) AS RankProduct
    FROM choco
    GROUP BY product
) AS t
WHERE RankProduct <= 5;

-- Q8 (Intermediate): Calculate revenue per box for each product (efficiency metric)
SELECT product,
       SUM(amount) / SUM(boxes) AS RevPerBox
FROM choco
GROUP BY product
ORDER BY RevPerBox DESC
LIMIT 5;

-- Q9 (Intermediate): Analyze monthly revenue trend
SELECT DATE_FORMAT(date, '%Y-%m') AS MonthofYear,
       SUM(amount) AS MonthlyRev
FROM choco
GROUP BY MonthofYear
ORDER BY MonthofYear ASC;

-- Q10 (Intermediate): Calculate percentage contribution of each country to total revenue
SELECT country,
       SUM(amount),
       ROUND(SUM(amount) / (SELECT SUM(amount) FROM choco) * 100, 3) AS Percentage
FROM choco
GROUP BY country
ORDER BY Percentage DESC;

-- Q11 (Advanced): Calculate month-over-month revenue growth
WITH monthly AS (
    SELECT DATE_FORMAT(date, '%Y-%m') AS MonthofYear,
           SUM(amount) AS MonthlyRev
    FROM choco
    GROUP BY MonthofYear
)
SELECT MonthofYear,
       MonthlyRev,
       ROUND(
           (MonthlyRev - LAG(MonthlyRev) OVER (ORDER BY MonthofYear ASC)) /
           LAG(MonthlyRev) OVER (ORDER BY MonthofYear ASC) * 100, 2
       ) AS growth
FROM monthly;

-- Q12 (Advanced): Identify salespersons performing above average revenue
SELECT salesperson,
       SUM(amount) AS rev,
       RANK() OVER (
           ORDER BY ROUND(
               SUM(amount) - (
                   SELECT AVG(sales)
                   FROM (
                       SELECT SUM(amount) AS sales
                       FROM choco
                       GROUP BY salesperson
                   ) t
               ), 2
           ) DESC
       ) AS rankScored,
       ROUND(
           SUM(amount) - (
               SELECT AVG(sales)
               FROM (
                   SELECT SUM(amount) AS sales
                   FROM choco
                   GROUP BY salesperson
               ) t
           ), 2
       ) AS performance
FROM choco
GROUP BY salesperson
HAVING performance > 0;

-- Q13 (Intermediate): Calculate average revenue per salesperson
SELECT ROUND(AVG(sales), 2) AS average
FROM (
    SELECT salesperson, SUM(amount) AS sales
    FROM choco
    GROUP BY salesperson
) t;

-- Q14 (Advanced): Rank products based on revenue per box (premium products)
SELECT product,
       ROUND(SUM(amount) / SUM(boxes), 3) AS rev_per_box,
       RANK() OVER (ORDER BY ROUND(SUM(amount) / SUM(boxes), 3) DESC) AS prem_level
FROM choco
GROUP BY product;

-- Q15 (Advanced): Calculate country contribution using CTE
WITH ranking AS (
    SELECT country, SUM(amount) AS rev
    FROM choco
    GROUP BY country
)
SELECT country,
       rev,
       ROUND(rev / (SELECT SUM(amount) FROM choco) * 100, 0)
FROM ranking;

-- Q16 (Intermediate): Rank countries based on total revenue
SELECT country,
       SUM(amount) AS rev,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rnk
FROM choco
GROUP BY country;

-- Q17 (Advanced): Calculate contribution of top-performing countries
WITH ranked AS (
    SELECT country,
           SUM(amount) AS revenue,
           RANK() OVER (ORDER BY SUM(amount) DESC) AS rnk
    FROM choco
    GROUP BY country
)
SELECT SUM(revenue) AS top_revenue,
       ROUND(SUM(revenue) / (SELECT SUM(amount) FROM choco) * 100, 2) AS percent_of_total
FROM ranked
WHERE rnk <= 6;

-- Q18 (Intermediate): Analyze revenue by product and salesperson
SELECT product, salesperson, SUM(amount) AS rev
FROM choco
GROUP BY product, salesperson
ORDER BY rev DESC;

-- Q19 (Intermediate): Measure salesperson efficiency (revenue per box)
SELECT salesperson,
       SUM(amount) / SUM(boxes) AS rek
FROM choco
GROUP BY salesperson
ORDER BY rek DESC;
