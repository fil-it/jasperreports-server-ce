--
--
-- Updates to make dates 2006-2007
--
--

UPDATE time_by_day SET the_year = 2006 WHERE the_year = 1997;

UPDATE time_by_day SET the_year = 2007 WHERE the_year = 1998;


ALTER TABLE time_by_day ADD day_of_week int;

 
UPDATE time_by_day SET day_of_week = 1 WHERE the_day = 'Monday';
 
UPDATE time_by_day SET day_of_week = 2 WHERE the_day = 'Tuesday';
  
UPDATE time_by_day SET day_of_week = 3 WHERE the_day = 'Wednesday';
 
UPDATE time_by_day SET day_of_week = 4 WHERE the_day = 'Thursday';
 
UPDATE time_by_day SET day_of_week = 5 WHERE the_day = 'Friday';
 
UPDATE time_by_day SET day_of_week = 6 WHERE the_day = 'Saturday';
 
UPDATE time_by_day SET day_of_week = 7 WHERE the_day = 'Sunday';

UPDATE agg_c_10_sales_fact_1997 SET the_year = 2006 WHERE the_year = 1997;
UPDATE agg_c_14_sales_fact_1997 SET the_year = 2006 WHERE the_year = 1997;
UPDATE agg_c_special_sales_fact_1997 SET time_year = 2006 WHERE time_year = 1997;
UPDATE agg_lc_100_sales_fact_1997 SET the_year = 2006 WHERE the_year = 1997;

CREATE TABLE 
     monthly_profit AS
SELECT
        min(time_by_day.the_date) as the_date,    /* we retrieve the first day of each month */
        time_by_day.the_year AS the_year,
        time_by_day.the_month AS the_month,
        time_by_day.quarter AS the_quarter,
        time_by_day.month_of_year AS time_by_day_month_of_year,
        sum(sales_fact_1997.store_sales) AS store_sales,
        sum(sales_fact_1997.store_sales)-sum(sales_fact_1997.store_cost) AS profit,
    store.store_state AS store_state
FROM
        sales_fact_1997 sales_fact_1997 INNER JOIN store store ON sales_fact_1997.store_id = store.store_id
        INNER JOIN time_by_day time_by_day ON sales_fact_1997.time_id = time_by_day.time_id
WHERE
        store.store_state <> 'NULL' /* when param PickState contains ALL use NULL otherwise use PickState */
GROUP BY
        time_by_day.the_year,
        time_by_day.the_month,
        time_by_day.quarter,
        time_by_day.month_of_year,
        store.store_state
ORDER BY
        time_by_day.month_of_year ASC;

CREATE TABLE 
     product_sales AS
SELECT
     product.product_name AS product_product_name,
     sum(sales_fact_1997.store_sales)AS store_sales,
     product.product_id AS product_product_id
FROM
     sales_fact_1997 sales_fact_1997,
     product product
WHERE
     sales_fact_1997.product_id = product.product_id
GROUP BY
     product.product_name,
     product.product_id
ORDER BY
     store_sales DESC;

CREATE TABLE 
     customer_sales AS
SELECT
     customer.fullname AS customer_fullname,
     sum(sales_fact_1997.store_sales)AS store_sales,
     customer.customer_id AS customer_id
FROM
     sales_fact_1997 sales_fact_1997,
     customer customer
WHERE
     sales_fact_1997.customer_id = customer.customer_id
GROUP BY
     customer.fullname,
     customer.customer_id
ORDER BY
     store_sales DESC;

CREATE TABLE 
     promotion_sales AS
SELECT
     promotion.promotion_name AS promotion_promotion_name,
     sum(sales_fact_1997.store_sales)AS store_sales,
     promotion.promotion_id AS promotion_promotion_id
FROM
     sales_fact_1997 sales_fact_1997,
     promotion promotion
WHERE
     sales_fact_1997.promotion_id = promotion.promotion_id
GROUP BY
     promotion.promotion_name,
     promotion.promotion_id
HAVING
     promotion.promotion_name <> 'No Promotion'
ORDER BY
     store_sales DESC;



