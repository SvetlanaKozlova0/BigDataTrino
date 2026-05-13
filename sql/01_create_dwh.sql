create schema if not exists clickhouse.dwh;

drop table if exists clickhouse.dwh.fact_sales;
drop table if exists clickhouse.dwh.dim_product;
drop table if exists clickhouse.dwh.dim_store;
drop table if exists clickhouse.dwh.dim_supplier;
drop table if exists clickhouse.dwh.dim_seller;
drop table if exists clickhouse.dwh.dim_customer_pet;
drop table if exists clickhouse.dwh.dim_customer;
drop table if exists clickhouse.dwh.stg_mock_data;

create table clickhouse.dwh.stg_mock_data
with (
    engine = 'MergeTree'
) as
select
    'clickhouse' as source_system,
    coalesce(cast(id as integer), 0) as source_id,
    cast(from_utf8(customer_first_name) as varchar) as customer_first_name,
    cast(from_utf8(customer_last_name) as varchar) as customer_last_name,
    cast(customer_age as integer) as customer_age,
    cast(from_utf8(customer_email) as varchar) as customer_email,
    cast(from_utf8(customer_country) as varchar) as customer_country,
    cast(from_utf8(customer_postal_code) as varchar) as customer_postal_code,
    cast(from_utf8(customer_pet_type) as varchar) as customer_pet_type,
    cast(from_utf8(customer_pet_name) as varchar) as customer_pet_name,
    cast(from_utf8(customer_pet_breed) as varchar) as customer_pet_breed,
    cast(from_utf8(seller_first_name) as varchar) as seller_first_name,
    cast(from_utf8(seller_last_name) as varchar) as seller_last_name,
    cast(from_utf8(seller_email) as varchar) as seller_email,
    cast(from_utf8(seller_country) as varchar) as seller_country,
    cast(from_utf8(seller_postal_code) as varchar) as seller_postal_code,
    cast(from_utf8(product_name) as varchar) as product_name,
    cast(from_utf8(product_category) as varchar) as product_category,
    cast(product_price as decimal(12, 2)) as product_price,
    cast(product_quantity as integer) as product_quantity,
    cast(date_parse(from_utf8(sale_date), '%c/%e/%Y') as date) as sale_date,
    cast(sale_customer_id as integer) as sale_customer_id,
    cast(sale_seller_id as integer) as sale_seller_id,
    cast(sale_product_id as integer) as sale_product_id,
    cast(sale_quantity as integer) as sale_quantity,
    cast(sale_total_price as decimal(12, 2)) as sale_total_price,
    cast(from_utf8(store_name) as varchar) as store_name,
    cast(from_utf8(store_location) as varchar) as store_location,
    cast(from_utf8(store_city) as varchar) as store_city,
    cast(from_utf8(store_state) as varchar) as store_state,
    cast(from_utf8(store_country) as varchar) as store_country,
    cast(from_utf8(store_phone) as varchar) as store_phone,
    cast(from_utf8(store_email) as varchar) as store_email,
    cast(from_utf8(pet_category) as varchar) as pet_category,
    cast(product_weight as decimal(12, 2)) as product_weight,
    cast(from_utf8(product_color) as varchar) as product_color,
    cast(from_utf8(product_size) as varchar) as product_size,
    cast(from_utf8(product_brand) as varchar) as product_brand,
    cast(from_utf8(product_material) as varchar) as product_material,
    cast(from_utf8(product_description) as varchar) as product_description,
    cast(product_rating as decimal(3, 1)) as product_rating,
    cast(product_reviews as integer) as product_reviews,
    cast(date_parse(from_utf8(product_release_date), '%c/%e/%Y') as date) as product_release_date,
    cast(date_parse(from_utf8(product_expiry_date), '%c/%e/%Y') as date) as product_expiry_date,
    cast(from_utf8(supplier_name) as varchar) as supplier_name,
    cast(from_utf8(supplier_contact) as varchar) as supplier_contact,
    cast(from_utf8(supplier_email) as varchar) as supplier_email,
    cast(from_utf8(supplier_phone) as varchar) as supplier_phone,
    cast(from_utf8(supplier_address) as varchar) as supplier_address,
    cast(from_utf8(supplier_city) as varchar) as supplier_city,
    cast(from_utf8(supplier_country) as varchar) as supplier_country
from clickhouse.default.mock_data

union all

select
    'postgres' AS source_system,
    coalesce(cast(id as integer), 0) AS source_id,
    cast(customer_first_name as varchar) as customer_first_name,
    cast(customer_last_name as varchar) as customer_last_name,
    cast(customer_age as integer) as customer_age,
    cast(customer_email as varchar) as customer_email,
    cast(customer_country as varchar) as customer_country,
    cast(customer_postal_code as varchar) as customer_postal_code,
    cast(customer_pet_type as varchar) as customer_pet_type,
    cast(customer_pet_name as varchar) as customer_pet_name,
    cast(customer_pet_breed as varchar) as customer_pet_breed,
    cast(seller_first_name as varchar) as seller_first_name,
    cast(seller_last_name as varchar) as seller_last_name,
    cast(seller_email as varchar) as seller_email,
    cast(seller_country as varchar) as seller_country,
    cast(seller_postal_code as varchar) as seller_postal_code,
    cast(product_name as varchar) as product_name,
    cast(product_category as varchar) as product_category,
    cast(product_price as decimal(12, 2)) as product_price,
    cast(product_quantity as integer) as product_quantity,
    cast(date_parse(sale_date, '%c/%e/%Y') as date) as sale_date,
    cast(sale_customer_id as integer) as sale_customer_id,
    cast(sale_seller_id as integer) as sale_seller_id,
    cast(sale_product_id as integer) as sale_product_id,
    cast(sale_quantity as integer) as sale_quantity,
    cast(sale_total_price as decimal(12, 2)) as sale_total_price,
    cast(store_name as varchar) as store_name,
    cast(store_location as varchar) as store_location,
    cast(store_city as varchar) as store_city,
    cast(store_state as varchar) as store_state,
    cast(store_country as varchar) as store_country,
    cast(store_phone as varchar) as store_phone,
    cast(store_email as varchar) as store_email,
    cast(pet_category as varchar) as pet_category,
    cast(product_weight as decimal(12, 2)) as product_weight,
    cast(product_color as varchar) as product_color,
    cast(product_size as varchar) as product_size,
    cast(product_brand as varchar) as product_brand,
    cast(product_material as varchar) as product_material,
    cast(product_description as varchar) as product_description,
    cast(product_rating as decimal(3, 1)) as product_rating,
    cast(product_reviews as integer) as product_reviews,
    cast(date_parse(product_release_date, '%c/%e/%Y') as date) as product_release_date,
    cast(date_parse(product_expiry_date, '%c/%e/%Y') as date) as product_expiry_date,
    cast(supplier_name as varchar) as supplier_name,
    cast(supplier_contact as varchar) as supplier_contact,
    cast(supplier_email as varchar) as supplier_email,
    cast(supplier_phone as varchar) as supplier_phone,
    cast(supplier_address as varchar) as supplier_address,
    cast(supplier_city as varchar) as supplier_city,
    cast(supplier_country as varchar) as supplier_country
from postgres.public.mock_data;

create table clickhouse.dwh.dim_customer
with (
    engine = 'MergeTree'
) as
select  
    coalesce(sale_customer_id, 0) as customer_id,
    max(customer_first_name) as first_name,
    max(customer_last_name) as last_name,
    max(customer_age) as age,
    max(customer_email) as email,
    max(customer_country) as country,
    max(customer_postal_code) as postal_code
from clickhouse.dwh.stg_mock_data
group by sale_customer_id;

create table clickhouse.dwh.dim_customer_pet
with (
    engine = 'MergeTree'
) as
select  
    coalesce(sale_customer_id, 0) as customer_id,
    max(customer_pet_type) as pet_type,
    max(customer_pet_name) as pet_name,
    max(customer_pet_breed) as pet_breed,
    max(pet_category) as pet_category 
from clickhouse.dwh.stg_mock_data
group by sale_customer_id;

create table clickhouse.dwh.dim_seller
with (
    engine = 'MergeTree'
) as
select
    coalesce(sale_seller_id, 0) as seller_id,
    max(seller_first_name) as first_name,
    max(seller_last_name) as last_name,
    max(seller_email) as email,
    max(seller_country) as country,
    max(seller_postal_code) as postal_code
from clickhouse.dwh.stg_mock_data
group by sale_seller_id;

create table clickhouse.dwh.dim_supplier
with (
    engine = 'MergeTree'
) as
select
    supplier_name,
    max(supplier_contact) as contact,
    max(supplier_email) as email,
    max(supplier_phone) as phone,
    max(supplier_address) as supplier_address,
    max(supplier_city) as city,
    max(supplier_country) as country
from clickhouse.dwh.stg_mock_data
group by supplier_name;

create table clickhouse.dwh.dim_store
with (
    engine = 'MergeTree'
) as
select
    store_name,
    max(store_location) as store_location,
    max(store_city) as city,
    max(store_state) as store_state,
    max(store_country) as country,
    max(store_phone) as phone,
    max(store_email) as email
from clickhouse.dwh.stg_mock_data
group by store_name;

create table clickhouse.dwh.dim_product
with (
    engine = 'MergeTree'
) as
select
    coalesce(sale_product_id, 0) as product_id,
    max(product_name) as product_name,
    max(product_category) as product_category,
    max(product_price) as price,
    max(product_quantity) as quantity,
    max(product_weight) as product_weight,
    max(product_color) as color,
    max(product_size) as product_size,
    max(product_brand) as brand,
    max(product_material) as material,
    max(product_description) as product_description,
    max(product_rating) as rating,
    max(product_reviews) as reviews,
    max(product_release_date) as date_release,
    max(product_expiry_date) as date_expiry
from clickhouse.dwh.stg_mock_data
group by sale_product_id;

create table clickhouse.dwh.fact_sales
with (
    engine = 'MergeTree'
) as
select
    row_number() over (
        order by source_system,
                 source_id,
                 sale_customer_id,
                 sale_seller_id,
                 sale_product_id
    ) as sale_id,
    sale_date,
    sale_customer_id as customer_id,
    sale_seller_id as seller_id,
    sale_product_id as product_id,
    store_name,
    supplier_name,
    sale_quantity as quantity,
    sale_total_price as total_price
from clickhouse.dwh.stg_mock_data;