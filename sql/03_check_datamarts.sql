-- количество строк в каждой таблице отчётов
select 
    'report_sales_products' as report_name,
    count(*) as row_count 
from datamarts.report_sales_products
union all 
select 
    'report_sales_customers',
    count(*)
from datamarts.report_sales_customers 
union all 
select 
    'report_sales_time',
    count(*)
from datamarts.report_sales_time 
union all 
select 
    'report_sales_stores',
    count(*)
from datamarts.report_sales_stores 
union all 
select 
    'report_sales_suppliers',
    count(*)
from datamarts.report_sales_suppliers 
union all 
select 
    'report_product_quality',
    count(*)
from datamarts.report_product_quality;


-- ВИТРИНА ПРОДАЖ ПО ПРОДУКТАМ
-- топ-10 самых продаваемых продуктов 
select 
    'Toп-10 самых продаваемых продуктов' as metric,
    product_id,
    avg_rating,
    product_name,
    total_quantity as quantity_sold
from 
    datamarts.report_sales_products 
order by 
    total_quantity desc 
limit 10;

-- общая выручка по категориям продуктов 
select 
    'Общая выручка по категориям' as metric,
    product_category,
    sum(total_revenue) as total_revenue
from 
    datamarts.report_sales_products 
group by 
    product_category 
order by 
    total_revenue desc 
limit 30;

-- средний рейтинг и количество отзывов для каждого продукта 
select 
    'Средний рейтинг и количество отзывов' as metric,
    product_name,
    avg_rating,
    review_count 
from 
    datamarts.report_sales_products 
order by 
    total_revenue desc 
limit 10;


-- ВИТРИНА ПРОДАЖ ПО КЛИЕНТАМ 
-- топ-10 клиентов с наибольшей общей суммой покупок
select 
    'Топ-10 клиентов по сумме покупок' as metric,
    customer_id,
    first_name,
    last_name,
    total_spent 
from 
    datamarts.report_sales_customers 
order by 
    total_spent desc 
limit 10;

-- распределение клиентов по странам
select 
    'Распределение клиентов по странам' as metric,
    country,
    count(*) as customers 
from 
    datamarts.report_sales_customers 
group by 
    country 
order by 
    customers desc 
limit 10;

-- средний чек для каждого клиента 
select 
    'Средний чек для каждого клиента' as metric,
    customer_id,
    first_name,
    last_name,
    avg_check 
from 
    datamarts.report_sales_customers 
order by 
    avg_check desc 
limit 10;


-- ВИТРИНА ПРОДАЖ ПО ВРЕМЕНИ 
-- месячные и годовые тренды продаж 
select 
    'Тренды продаж' as metric,
    sale_year,
    sale_month,
    total_revenue,
    total_orders, 
    total_quantity
from 
    datamarts.report_sales_time 
order by 
    sale_year, sale_month 
limit 12;

-- сравнение выручки за разные периоды (месяц к предыдущему месяцу)
select 
    'Сравнение выручки: месяц к предыдущему месяцу' as metric,
    sale_year,
    sale_month,
    total_revenue,
    previous_month_revenue,
    revenue_change_vs_previous_month
from 
    datamarts.report_sales_time
order by 
    sale_year, sale_month 
limit 12;

-- средний размер заказа по месяцам 
select 
    'Средний размер заказа по месяцам' as metric,
    sale_year,
    sale_month,
    avg_items_per_order
from 
    datamarts.report_sales_time 
order by 
    sale_year, sale_month 
limit 12;


-- ВИТРИНА ПРОДАЖ ПО МАГАЗИНАМ
-- топ-5 магазинов с наибольшей выручкой 
select 
    'Топ-5 магазинов по выручке' as metric,
    store_name,
    city,
    country,
    total_revenue 
from 
    datamarts.report_sales_stores 
order by 
    total_revenue desc 
limit 5;

-- распределение продаж по городам и странам 
select 
    'Распределение продаж по странам' as metric,
    country,
    sum(total_revenue) as revenue_by_country 
from 
    datamarts.report_sales_stores 
group by 
    country 
order by 
    revenue_by_country desc 
limit 10;

select 
    'Распределение продаж по городам' as metric,
    city,
    country,
    total_revenue 
from 
    datamarts.report_sales_stores 
order by 
    total_revenue desc 
limit 10;

-- средний чек для каждого магазина 
select 
    'Средний чек по каждому магазину' as metric,
    store_name,
    city,
    avg_check
from 
    datamarts.report_sales_stores 
order by 
    avg_check desc 
limit 10;


-- ВИТРИНА ПРОДАЖ ПО ПОСТАВЩИКАМ 
-- топ-5 поставщиков с наибольшей выручкой 
select 
    'Топ-5 поставщиков по выручке' as metric,
    supplier_name,
    country,
    total_revenue 
from 
    datamarts.report_sales_suppliers 
order by 
    total_revenue desc 
limit 5;

-- средняя цена товаров от каждого поставщика 
select 
    'Средняя цена товаров по поставщикам' as metric,
    supplier_name,
    avg_product_price
from 
    datamarts.report_sales_suppliers 
order by 
    avg_product_price desc 
limit 10;

-- распределение продаж по странам поставщиков 
select 
    'Распределение продаж по странам поставщиков' as metric,
    country,
    sum(total_revenue) as total_revenue 
from 
    datamarts.report_sales_suppliers 
group by 
    country 
order by 
    total_revenue desc 
limit 10;


-- ВИТРИНА КАЧЕСТВА ПРОДУКЦИИ 
-- продукты с наивысшим и наименьшим рейтингом
select 
    'Продукты с наивысшим рейтингом' as metric,
    product_id,
    product_name,
    rating,
    review_count,
    total_quantity_sold
from 
    datamarts.report_product_quality 
order by 
    rating desc 
limit 10;

select 
    'Продукты с наименьшим рейтингом' as metric,
    product_id,
    product_name,
    rating,
    review_count,
    total_quantity_sold 
from 
    datamarts.report_product_quality
order by 
    rating asc 
limit 10;

-- корреляция между рейтингом и объёмом продаж 
select 
    'Корреляция между рейтингом и объёмом продаж' as metric,
    round(rating_sales_correlation, 4) as correlation_coefficient 
from 
    datamarts.report_product_quality 
limit 1;

-- продукты с наибольшим количеством отзывов 
select 
    'Продукты с наибольшим количеством отзывов' as metric,
    product_id,
    product_name,
    review_count,
    rating,
    total_quantity_sold 
from 
    datamarts.report_product_quality 
order by 
    review_count desc 
limit 10;

    