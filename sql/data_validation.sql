use FuzzyFactory;
go

/* ========================================================================
   data validation & quality checks
   purpose: identify and fix data quality issues before analysis
   ======================================================================== */

-- 1. database exploration 
select * from INFORMATION_SCHEMA.TABLES;
select * from INFORMATION_SCHEMA.COLUMNS
order by TABLE_NAME asc;

/* ========================================================================
   2. null checks and invalid values
   ======================================================================== */

-- a. website_sessions
select 
    'website_sessions' as table_name,
    count(*) as total_rows,
    count(*) - count(utm_source) as null_sources,
    count(*) - count(utm_campaign) as null_campaigns,
    count(*) - count(utm_content) as null_content,
    count(*) - count(http_referer) as null_referer,
    sum(case when user_id is null then 1 else 0 end) as null_users
from website_sessions;

-- fix nulls: assume nulls mean organic traffic
update website_sessions
set utm_source = 'organic'
where utm_source = 'null';

update website_sessions
set utm_campaign = 'others'
where utm_campaign = 'null';

update website_sessions
set utm_content = 'others'
where utm_content = 'null';

update website_sessions
set http_referer = 'organic'
where http_referer = 'null';

-- b. website_pageviews
select 
    'website_pageviews' as table_name,
    count(*) as total_rows,
    sum(case when pageview_url is null then 1 else 0 end) as null_urls,
    sum(case when website_session_id is null then 1 else 0 end) as null_sessions
from website_pageviews;

-- c. orders
select 
    'orders' as table_name,
    sum(case when price_usd is null then 1 else 0 end) as null_price,
    sum(case when cogs_usd is null then 1 else 0 end) as null_cogs,
    sum(case when items_purchased is null then 1 else 0 end) as null_items
from orders;

-- d. order_items
select 
    'order_items' as table_name,
    sum(case when price_usd = 0 then 1 else 0 end) as zero_price_items,
    sum(case when cogs_usd > price_usd then 1 else 0 end) as negative_margin_items
from order_items;

-- e. products
select 
    'products' as table_name,
    count(*) - count(product_name) as null_names
from products;

-- f. refunds
select 
    'refunds' as table_name,
    count(*) - count(refund_amount_usd) as null_refunds,
    sum(case when refund_amount_usd = 0 then 1 else 0 end) as zero_refunds
from refunds;

/* ========================================================================
   3. outlier checks
   ======================================================================== */

select
    min(items_purchased) as min_qty, 
    max(items_purchased) as max_qty, 
    avg(items_purchased) as avg_qty, 
    min(price_usd) as min_price, 
    max(price_usd) as max_price, 
    avg(price_usd) as avg_price,
    min(cogs_usd) as min_costs, 
    max(cogs_usd) as max_costs, 
    avg(cogs_usd) as avg_cost
from orders;

/* ========================================================================
   4. duplicate checks (primary keys)
   ======================================================================== */

select 
    'orders' as table_name, 
    count(*) as total_rows, 
    count(distinct order_id) as unique_ids,
    count(*) - count(distinct order_id) as duplicate_count
from orders
union all
select 
    'order_items', 
    count(*), 
    count(distinct order_item_id),
    count(*) - count(distinct order_item_id)
from order_items
union all
select 
    'website_sessions', 
    count(*), 
    count(distinct website_session_id),
    count(*) - count(distinct website_session_id)
from website_sessions
union all
select 
    'website_pageviews', 
    count(*), 
    count(distinct website_pageview_id),
    count(*) - count(distinct website_pageview_id)
from website_pageviews
union all
select 
    'refunds', 
    count(*),
    count(distinct order_item_refund_id),
    count(*) - count(distinct order_item_refund_id)
from refunds; 

/* ========================================================================
   5. referential integrity checks (orphaned records)
   ======================================================================== */

select 'pageviews_without_sessions' as audit_type, count(*) as error_count
from website_pageviews wp 
left join website_sessions ws 
    on wp.website_session_id = ws.website_session_id 
where ws.website_session_id is null
union all
select 'orders_without_sessions', count(*)
from orders o 
left join website_sessions ws 
    on o.website_session_id = ws.website_session_id 
where ws.website_session_id is null
union all
select 'items_without_orders', count(*)
from order_items oi 
left join orders o 
    on oi.order_id = o.order_id 
where o.order_id is null
union all   
select 'refunds_without_items', count(*)
from refunds r 
left join order_items oi 
    on r.order_item_id = oi.order_item_id 
where oi.order_item_id is null;

/* ========================================================================
   6. business logic / sense checks
   ======================================================================== */

-- a. check date ranges (catch time travelers)
select 
    'date_range_check' as check_type,
    min(created_at) as earliest_data, 
    max(created_at) as latest_data 
from website_sessions; 

-- b. orders created before sessions (impossible)
select 
    'orders_before_sessions' as check_type,
    count(*) as error_count
from orders o
join website_sessions ws 
    on o.website_session_id = ws.website_session_id
where o.created_at < ws.created_at;

-- c. refund amount exceeds original price (suspicious)
select 
    'refund_exceeds_price' as check_type,
    count(*) as error_count
from refunds r
join order_items oi 
    on r.order_item_id = oi.order_item_id
where r.refund_amount_usd > oi.price_usd;

/* ========================================================================
   validation complete
   expected results: all error_counts should be 0
   ======================================================================== */
