use FuzzyFactory;
go

/* ========================================================================
   exploratory data analysis (eda)
   purpose: understand patterns, distributions, and business context
   ======================================================================== */

/* ========================================================================
   1. dimensions exploration
   ======================================================================== */

-- a. traffic sources breakdown
select 
    utm_source, 
    utm_campaign, 
    utm_content, 
    http_referer,
    count(*) as session_count,
    round(cast(count(*) as float) / (select count(*) from website_sessions) * 100, 2) as pct_of_total
from website_sessions
group by utm_source, utm_campaign, utm_content, http_referer
order by session_count desc;

-- b. device distribution
select 
    device_type, 
    count(*) as session_count,
    round(cast(count(*) as float) / (select count(*) from website_sessions) * 100, 2) as pct_of_sessions
from website_sessions
group by device_type;

-- c. top landing pages / entry points
select 
    pageview_url, 
    count(*) as view_count,
    round(cast(count(*) as float) / (select count(*) from website_pageviews) * 100, 2) as pct_of_pageviews
from website_pageviews
group by pageview_url
order by view_count desc;

-- d. product catalog with launch dates
select  
    product_id, 
    product_name, 
    created_at as launch_date,
    datediff(YEAR, created_at, getdate()) as years_since_launch
from products
order by launch_date;

-- e. new vs returning customers
select 
    case when is_repeat_session = 1 then 'returning' else 'new' end as customer_type,
    count(*) as session_count,
    round(cast(count(*) as float) / (select count(*) from website_sessions) * 100, 2) as pct_of_sessions
from website_sessions
group by is_repeat_session;

-- f. refunds by product
select 
    coalesce(product_name, 'unknown') as product_name,
    count(order_item_refund_id) as refund_count,
    sum(refund_amount_usd) as total_refund_amount
from refunds r
left join order_items oi
    on r.order_item_id = oi.order_item_id
left join products p
    on oi.product_id = p.product_id
group by product_name
order by refund_count desc;

/* ========================================================================
   2. time range / temporal coverage
   ======================================================================== */

-- a. overall data range
select 
    'website_sessions' as table_name,
    min(created_at) as first_record,
    max(created_at) as last_record,
    datediff(day, min(created_at), max(created_at)) as days_of_data
from website_sessions
union all
select 
    'orders',
    min(created_at),
    max(created_at),
    datediff(day, min(created_at), max(created_at))
from orders
union all
select 
    'website_pageviews',
    min(created_at),
    max(created_at),
    datediff(day, min(created_at), max(created_at))
from website_pageviews
union all
select 
    'refunds',
    min(created_at),
    max(created_at),
    datediff(day, min(created_at), max(created_at))
from refunds;

/* ========================================================================
   3. volume metrics (counts)
   ======================================================================== */

select 
    (select count(*) from website_sessions) as total_sessions,
    (select count(*) from website_pageviews) as total_pageviews,
    (select count(*) from orders) as total_orders,
    (select sum(items_purchased) from orders) as total_items_purchased,
    (select count(*) from order_items) as total_order_items,
    (select count(*) from refunds) as total_refunds,
    (select count(distinct user_id) from website_sessions) as unique_users;

/* ========================================================================
   4. financial metrics
   ======================================================================== */

-- a. overall revenue & profit
select 
    sum(o.price_usd) as gross_revenue,
    sum(o.cogs_usd) as total_cogs,
    coalesce(sum(r.refund_amount_usd), 0) as total_refunds,
    sum(o.price_usd) - coalesce(sum(r.refund_amount_usd), 0) as net_revenue,
    sum(o.price_usd) - sum(o.cogs_usd) as gross_profit,
    sum(o.price_usd) - sum(o.cogs_usd) - coalesce(sum(r.refund_amount_usd), 0) as net_profit,
    round((sum(o.price_usd) - sum(o.cogs_usd)) / sum(o.price_usd) * 100, 2) as gross_margin_pct,
    round((sum(o.price_usd) - sum(o.cogs_usd) - coalesce(sum(r.refund_amount_usd), 0)) / sum(o.price_usd) * 100, 2) as net_margin_pct
from orders o   
left join (
    select order_id, sum(refund_amount_usd) as refund_amount_usd
    from refunds
    group by order_id
) r on o.order_id = r.order_id;

-- b. revenue by product
select 
    p.product_name,
    count(distinct o.order_id) as order_count,
    sum(o.price_usd) as total_revenue,
    sum(o.cogs_usd) as total_cogs,
    sum(o.price_usd) - sum(o.cogs_usd) as gross_profit,
    round((sum(o.price_usd) - sum(o.cogs_usd)) / sum(o.price_usd) * 100, 2) as margin_pct
from orders o
join products p
    on o.primary_product_id = p.product_id
group by p.product_name
order by total_revenue desc;

/* ========================================================================
   5. conversion & behavioral metrics
   ======================================================================== */
   use FuzzyFactory;
   go
-- a. overall conversion funnel
select 
    count(distinct ws.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    round(cast(count(distinct o.order_id) as float) / count(distinct ws.website_session_id) * 100, 2) as conversion_rate,
    round(cast(count(distinct wp.website_pageview_id) as float) / count(distinct ws.website_session_id), 2) as avg_pages_per_session
from website_sessions ws
left join orders o
    on ws.website_session_id = o.website_session_id
left join website_pageviews wp
    on ws.website_session_id = wp.website_session_id;

-- b. average order metrics
select 
    round(avg(price_usd), 2) as avg_order_value,
    round(avg(items_purchased), 2) as avg_items_per_order,
    round(avg(price_usd / nullif(items_purchased, 0)), 2) as avg_price_per_item,
    round(avg(cogs_usd), 2) as avg_cogs_per_order,
    round(avg(price_usd - cogs_usd), 2) as avg_profit_per_order
from orders;

-- c. refund rate
select 
    count(distinct o.order_id) as total_orders,
    count(distinct r.order_id) as orders_with_refunds,
    count(r.order_item_refund_id) as total_refund_transactions,
    round(cast(count(distinct r.order_id) as float) / count(distinct o.order_id) * 100, 2) as order_refund_rate_pct,
    round(avg(r.refund_amount_usd), 2) as avg_refund_amount
from orders o
left join refunds r
    on o.order_id = r.order_id;

/* ========================================================================
   6. segmentation analysis
   ======================================================================== */

-- a. performance by traffic source
select 
    utm_source,
    count(distinct ws.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    sum(o.price_usd) as revenue,
    round(cast(count(distinct o.order_id) as float) / count(distinct ws.website_session_id) * 100, 2) as conversion_rate,
    round(avg(o.price_usd), 2) as avg_order_value
from website_sessions ws
left join orders o
    on ws.website_session_id = o.website_session_id
group by utm_source
order by revenue desc;

-- b. performance by device type
select 
    device_type,
    count(distinct ws.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    sum(o.price_usd) as revenue,
    round(cast(count(distinct o.order_id) as float) / count(distinct ws.website_session_id) * 100, 2) as conversion_rate,
    round(avg(o.price_usd), 2) as avg_order_value
from website_sessions ws
left join orders o
    on ws.website_session_id = o.website_session_id
group by device_type
order by revenue desc;

-- c. new vs returning customer behavior
select 
    case when is_repeat_session = 1 then 'returning' else 'new' end as customer_type,
    count(distinct ws.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    sum(o.price_usd) as revenue,
    round(cast(count(distinct o.order_id) as float) / count(distinct ws.website_session_id) * 100, 2) as conversion_rate,
    round(avg(o.price_usd), 2) as avg_order_value
from website_sessions ws
left join orders o
    on ws.website_session_id = o.website_session_id
group by is_repeat_session
order by customer_type;

/* ========================================================================
   7. cross-sell / upsell analysis
   ======================================================================== */

-- a. multi-item orders
select 
    items_purchased,
    count(*) as order_count,
    round(cast(count(*) as float) / (select count(*) from orders) * 100, 2) as pct_of_orders,
    round(avg(price_usd), 2) as avg_order_value
from orders
group by items_purchased
order by items_purchased;

/* ========================================================================
   eda complete
   ======================================================================== */
