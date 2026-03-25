create database base;
use base;
ALTER TABLE choco 
MODIFY amount decimal(15,3) NOT NULL;
SELECT 
    COUNT(*)
FROM
    choco;
UPDATE choco 
SET 
    amount = REPLACE(REPLACE(amount, '$', ''),
        ',',
        '');
SET SQL_SAFE_UPDATES = 0;
SELECT country,
    SUM(amount) as Total_Revenue,
    rank() over ( order by sum(amount) desc) as CountryRank
FROM
    choco
    group by country 
    order by Total_Revenue Desc;
    
select 
salesperson , sum(amount) as Sales,
count(*) as orders,
rank() over (order by sum(amount) desc) as SalesPersonRank
from
choco
group by salesperson;
SELECT 
    country, COUNT(salesperson)
FROM
    choco
GROUP BY country;
select * from(select
product , sum(amount), rank() over( order by sum(amount) desc) as RankProduct
from choco
group by product) as t
where RankProduct <=5;

SELECT 
    product, SUM(amount) / SUM(boxes) AS RevPerBox
FROM
    choco
GROUP BY product
ORDER BY RevPerBox DESC
LIMIT 5;

SELECT 
    DATE_FORMAT(date, '%Y-%m') AS MonthofYear,
    SUM(amount) AS MonthlyRev
FROM
    choco
GROUP BY MonthofYear
ORDER BY MonthofYear ASC;


SELECT 
    country,
    SUM(amount),
    round(SUM(amount) / (SELECT 
            SUM(amount)
        FROM
            choco) * 100,3) AS Percentage
FROM
    choco
GROUP BY country
ORDER BY Percentage DESC;

with monthly as
(
SELECT 
    DATE_FORMAT(date, '%Y-%m') AS MonthofYear,
    SUM(amount) AS MonthlyRev
FROM
    choco
GROUP BY MonthofYear
)
select MonthofYear, 
monthlyrev,
round((monthlyrev-lag( monthlyrev) over (ORDER BY MonthofYear ASC))/lag(monthlyrev) over (ORDER BY MonthofYear ASC)*100,2) as growth
from monthly;

select 
salesperson,
sum(amount) as rev,
rank() over ( order by
round( sum(amount)- (select avg(sales) from (select sum(amount) as sales from choco group by salesperson) t),2)  desc) as rankScored,
round( sum(amount)- (select avg(sales) from (select sum(amount) as sales from choco group by salesperson) t),2)  as performance 
from choco
group by salesperson
having performance >0;
SELECT 
    ROUND(AVG(sales), 2) AS average
FROM
    (SELECT 
        salesperson, SUM(amount) AS sales
    FROM
        choco
    GROUP BY salesperson) t;


select product,
round(sum(amount)/sum(boxes),3) as rev_per_box,
rank() over (order by round(sum(amount)/sum(boxes),3) desc) as prem_level
from choco
group by product;

with ranking as (
select country,sum(amount) as rev
from choco
group by country)
select country , rev,
round(sum(rev) / (select sum(amount) from choco) *100,0)
from ranking
group by country
;
select country,sum(amount) as rev,
RANK() OVER (ORDER BY SUM(amount) DESC) AS rnk
from choco
group by country;

WITH ranked AS (
    SELECT 
        country,
        SUM(amount) AS revenue,
        RANK() OVER (ORDER BY SUM(amount) DESC) AS rnk
    FROM choco
    GROUP BY country
)

SELECT 
    SUM(revenue) AS top2_revenue,
    ROUND(
        SUM(revenue) / (SELECT SUM(amount) FROM choco) * 100,
        2
    ) AS percent_of_total
FROM ranked
WHERE rnk <= 6;

select product, salesperson, sum(amount) as rev
from choco
group by product , salesperson
order by rev desc
;
select salesperson, sum(amount)/sum(boxes) as rek
from choco
group by salesperson
order by rek desc;

