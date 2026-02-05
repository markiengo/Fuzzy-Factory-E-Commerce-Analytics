use fuzzyfactory;
go

-- cleanup
drop view if exists dbo.vw_dim_products;
drop view if exists dbo.vw_dim_date;
drop view if exists dbo.vw_fact_sales;
drop view if exists dbo.vw_fact_funnel_performance;
drop view if exists dbo.vw_dim_sessions;
go

--------------------------------------------------
-- 1. DIMENSION: PRODUCTS
--------------------------------------------------
create view dbo.vw_dim_products as
select 
    product_id,
    product_name,
    created_at as launch_date
from products;
go

--------------------------------------------------
-- 2. DIMENSION: DATE
--------------------------------------------------
create view dbo.vw_dim_date as
with 
tally_base as (select 1 as n union all select 1),
tally_4 as (select a.n from tally_base a cross join tally_base b),
tally_16 as (select a.n from tally_4 a cross join tally_4 b),
tally_256 as (select a.n from tally_16 a cross join tally_16 b),
tally_65536 as (select a.n from tally_256 a cross join tally_256 b),
tally as (select row_number() over (order by (select null)) - 1 as n from tally_65536),
date_range as (
    select 
        min(cast(created_at as date)) as start_date,
        max(cast(created_at as date)) as end_date
    from website_sessions
)
select 
    dateadd(day, t.n, dr.start_date) as [date],
    year(dateadd(day, t.n, dr.start_date)) as [year],
    month(dateadd(day, t.n, dr.start_date)) as [month],
    format(dateadd(day, t.n, dr.start_date), 'MMMM') as month_name,
    month(dateadd(day, t.n, dr.start_date)) as month_number,
    left(format(dateadd(day, t.n, dr.start_date), 'MMMM'), 3) as month_short,
    datepart(quarter, dateadd(day, t.n, dr.start_date)) as [quarter],
    'q' + cast(datepart(quarter, dateadd(day, t.n, dr.start_date)) as varchar) as quarter_name,
    datepart(week, dateadd(day, t.n, dr.start_date)) as week_number,
    datename(weekday, dateadd(day, t.n, dr.start_date)) as day_of_week
from tally t
cross join date_range dr
where dateadd(day, t.n, dr.start_date) <= dr.end_date;
go

--------------------------------------------------
-- 3. FACT: SALES (ORDER_ITEM GRAIN)
--------------------------------------------------
create view dbo.vw_fact_sales as
select 
    -- keys
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    o.website_session_id,
    o.user_id,

    -- dates
    cast(oi.created_at as date) as item_date,
    oi.created_at as item_timestamp,

    -- financials (refunds safely aggregated)
    oi.price_usd as gross_revenue,
    oi.cogs_usd as cost_of_goods,
    isnull(r.total_refund_amount, 0) as refund_amount,
    oi.price_usd - isnull(r.total_refund_amount, 0) as net_revenue,
    oi.price_usd - oi.cogs_usd - isnull(r.total_refund_amount, 0) as net_profit,

    -- flags
    oi.is_primary_item,
    case when isnull(r.total_refund_amount,0) > 0 then 1 else 0 end as is_refunded,

    -- order-level attributes
    o.items_purchased as basket_size,
    o.primary_product_id as order_primary_product,

    -- session attributes
    ws.device_type,
    ws.is_repeat_session,
    ws.utm_source,
    ws.utm_campaign,

    -- BUSINESS-ALIGNED CHANNEL GROUPING
    case 
        when ws.utm_source = 'gsearch' and ws.utm_campaign = 'nonbrand' then 'gsearch nonbrand'
        when ws.utm_source = 'gsearch' and ws.utm_campaign = 'brand' then 'gsearch brand'
        when ws.utm_source = 'bsearch' and ws.utm_campaign = 'nonbrand' then 'bsearch nonbrand'
        when ws.utm_source = 'bsearch' and ws.utm_campaign = 'brand' then 'bsearch brand'
        when ws.utm_source = 'socialbook' then 'paid social'
        when ws.utm_source = 'organic' then 'organic search'
        when ws.utm_source = 'direct' then 'direct type-in'
        else 'other'
    end as channel_group

from order_items oi
inner join orders o 
    on oi.order_id = o.order_id
left join website_sessions ws 
    on o.website_session_id = ws.website_session_id
left join (
    select 
        order_item_id,
        sum(refund_amount_usd) as total_refund_amount
    from refunds
    group by order_item_id
) r 
    on oi.order_item_id = r.order_item_id;
go

--------------------------------------------------
-- 4. FACT: FUNNEL PERFORMANCE (SESSION GRAIN)
--------------------------------------------------
create view dbo.vw_fact_funnel_performance as
select 
    website_session_id,
    max(case when pageview_url in ('/home','/lander-1','/lander-2','/lander-3','/lander-4','/lander-5') then 1 else 0 end) as saw_homepage,
    max(case when pageview_url = '/products' then 1 else 0 end) as saw_products_page,
    max(case when pageview_url in (
        '/the-original-mr-fuzzy',
        '/the-forever-love-bear',
        '/the-birthday-sugar-panda',
        '/the-hudson-river-mini-bear'
    ) then 1 else 0 end) as saw_individual_product,
    max(case when pageview_url = '/cart' then 1 else 0 end) as saw_cart,
    max(case when pageview_url = '/shipping' then 1 else 0 end) as saw_shipping,
    max(case when pageview_url in ('/billing','/billing-2') then 1 else 0 end) as saw_billing,
    max(case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end) as saw_thank_you
from website_pageviews
group by website_session_id;
go

--------------------------------------------------
-- 5. FACT: DIM_SESSIONS (SESSION GRAIN). TO LINK FUNNEL PERFORMANCE TO SALES
--------------------------------------------------
create view dbo.vw_dim_sessions as
select
    ws.website_session_id,
    ws.created_at as session_timestamp,
    cast(ws.created_at as date) as session_date,
    ws.user_id,
    ws.device_type,
    ws.is_repeat_session,
    ws.utm_source,
    ws.utm_campaign,
    ws.utm_content,
    ws.http_referer,

    case
        when ws.utm_source = 'gsearch' and ws.utm_campaign = 'nonbrand' then 'gsearch nonbrand'
        when ws.utm_source = 'gsearch' and ws.utm_campaign = 'brand' then 'gsearch brand'
        when ws.utm_source = 'bsearch' and ws.utm_campaign = 'nonbrand' then 'bsearch nonbrand'
        when ws.utm_source = 'bsearch' and ws.utm_campaign = 'brand' then 'bsearch brand'
        when ws.utm_source = 'socialbook' then 'paid social'
        when ws.utm_source = 'organic' then 'organic search'
        when ws.utm_source = 'direct' then 'direct type-in'
        else 'other'
    end as channel_group
from website_sessions ws;
go
