create schema if not exists clickhouse.datamarts;

drop table if exists clickhouse.datamarts.report_sales_products;
drop table if exists clickhouse.datamarts.report_sales_customers;
drop table if exists clickhouse.datamarts.report_sales_time;
drop table if exists clickhouse.datamarts.report_sales_stores;
drop table if exists clickhouse.datamarts.report_sales_suppliers;
drop table if exists clickhouse.datamarts.report_product_quality;

create table clickhouse.datamarts.report_sales_products
with (
    engine = 'MergeTree'
) as
select
    p.product_id,
    p.product_name,
    p.product_category,
    sum(f.total_price) as total_revenue,
    sum(f.quantity) as total_quantity,
    count(*) as sales_count,
    avg(p.rating) as avg_rating,
    max(p.reviews) as review_count
from clickhouse.dwh.fact_sales f 
left join clickhouse.dwh.dim_product p 
on f.product_id = p.product_id
group by
    p.product_id,
    p.product_name,
    p.product_category;

create table clickhouse.datamarts.report_sales_customers
with (
    engine = 'MergeTree'
) as
select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country,
    count(*) as orders_count,
    sum(f.total_price) as total_spent,
    avg(f.total_price) as avg_check
from clickhouse.dwh.fact_sales f
left join clickhouse.dwh.dim_customer c 
on f.customer_id = c.customer_id 
group by
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country;

create table clickhouse.datamarts.report_sales_time
with (
    engine = 'MergeTree'
) as
with monthly_sales as (
    select
        year(f.sale_date) as sale_year,
        month(f.sale_date) as sale_month,
        sum(f.total_price) as total_revenue,
        count(*) as total_orders,
        sum(f.quantity) as total_quantity,
        avg(f.total_price) as avg_check,
        cast(sum(f.quantity) as double) / count(*) as avg_items_per_order
    from clickhouse.dwh.fact_sales f 
    group by 
        year(f.sale_date),
        month(f.sale_date)
),
    monthly_with_lag as (
        select
            sale_year,
            sale_month,
            total_revenue,
            total_orders,
            total_quantity,
            avg_check,
            avg_items_per_order,
            lag(total_revenue) over (
                order by sale_year, sale_month
            ) as previous_month_revenue
        from monthly_sales
    )
    select
        sale_year,
        sale_month,
        total_revenue,
        previous_month_revenue,
        total_revenue - previous_month_revenue as revenue_change_vs_previous_month,
        total_orders,
        total_quantity,
        avg_check,
        avg_items_per_order
    from monthly_with_lag;

create table clickhouse.datamarts.report_sales_stores 
with (
    engine = 'MergeTree'
) as
select
    s.store_name,
    s.city,
    s.country,
    count(*) as total_orders,
    sum(f.total_price) as total_revenue,
    sum(f.quantity) as total_quantity,
    avg(f.total_price) as avg_check
from clickhouse.dwh.fact_sales f 
left join clickhouse.dwh.dim_store s 
on f.store_name = s.store_name 
group by 
    s.store_name,
    s.city,
    s.country;

create table clickhouse.datamarts.report_sales_suppliers
with (
    engine = 'MergeTree'
) as
select
    sp.supplier_name,
    sp.country,
    sum(f.total_price) as total_revenue,
    sum(f.quantity) as total_quantity,
    avg(p.price) as avg_product_price
from clickhouse.dwh.fact_sales f 
left join clickhouse.dwh.dim_supplier sp 
on f.supplier_name = sp.supplier_name 
left join clickhouse.dwh.dim_product p 
on f.product_id = p.product_id 
group by 
    sp.supplier_name,
    sp.country;

create table clickhouse.datamarts.report_product_quality
with (
    engine = 'MergeTree'
) as 
with product_sales as (
    select 
        p.product_id,
        p.product_name,
        p.product_category,
        p.rating,
        p.reviews as review_count,
        coalesce(sum(f.quantity), cast(0 as bigint)) as total_quantity_sold,
        coalesce(sum(f.total_price), cast(0 as decimal(12, 2))) as total_revenue
    from clickhouse.dwh.dim_product p 
    left join clickhouse.dwh.fact_sales f 
    on p.product_id = f.product_id 
    group by 
        p.product_id,
        p.product_name,
        p.product_category,
        p.rating,
        p.reviews
),
    quality_correlation as (
        select 
            corr(
                cast(rating as double),
                cast(total_quantity_sold as double)
            ) as rating_sales_correlation
        from product_sales
    )
    select 
        ps.product_id,
        ps.product_name,
        ps.product_category,
        ps.rating,
        ps.review_count,
        ps.total_quantity_sold,
        ps.total_revenue,
        qc.rating_sales_correlation
    from product_sales ps 
    cross join quality_correlation qc;