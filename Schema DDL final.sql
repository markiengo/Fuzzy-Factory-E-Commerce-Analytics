use FuzzyFactory;
GO

-- ============================================
-- 1. PRODUCTS
-- ============================================
CREATE TABLE products (
    product_id          INT             NOT NULL PRIMARY KEY,
    created_at          DATETIME2(0)    NOT NULL,
    product_name        VARCHAR(100)    NOT NULL
);

-- ============================================
-- 2. WEBSITE_SESSIONS
-- ============================================
CREATE TABLE website_sessions (
    website_session_id  INT             NOT NULL PRIMARY KEY,
    created_at          DATETIME2(0)    NOT NULL,
    user_id             INT             NOT NULL,
    is_repeat_session   BIT             NOT NULL,
    utm_source          VARCHAR(50)     NULL,
    utm_campaign        VARCHAR(100)    NULL,
    utm_content         VARCHAR(100)    NULL,
    device_type         VARCHAR(20)     NULL,
    http_referer        VARCHAR(255)    NULL
);

-- ============================================
-- 3. WEBSITE_PAGEVIEWS
-- ============================================
CREATE TABLE website_pageviews (
    website_pageview_id BIGINT          NOT NULL PRIMARY KEY,  -- BIGINT for 1M+ rows
    created_at          DATETIME2(0)    NOT NULL,
    website_session_id  INT             NOT NULL,
    pageview_url        VARCHAR(255)    NOT NULL
);

-- ============================================
-- 4. ORDERS
-- ============================================
CREATE TABLE orders (
    order_id            INT             NOT NULL PRIMARY KEY,
    created_at          DATETIME2(0)    NOT NULL,
    website_session_id  INT             NOT NULL,
    user_id             INT             NOT NULL,
    primary_product_id  INT             NOT NULL,
    items_purchased     TINYINT         NOT NULL,
    price_usd           DECIMAL(10,2)   NOT NULL,
    cogs_usd            DECIMAL(10,2)   NOT NULL
);

-- ============================================
-- 5. ORDER_ITEMS
-- ============================================
CREATE TABLE order_items (
    order_item_id       INT             NOT NULL PRIMARY KEY,
    created_at          DATETIME2(0)    NOT NULL,
    order_id            INT             NOT NULL,
    product_id          INT             NOT NULL,
    is_primary_item     BIT             NOT NULL,
    price_usd           DECIMAL(10,2)   NOT NULL,
    cogs_usd            DECIMAL(10,2)   NOT NULL
);

-- ============================================
-- 6. ORDER_ITEM_REFUNDS
-- ============================================
CREATE TABLE order_item_refunds (
    order_item_refund_id    INT             NOT NULL PRIMARY KEY,
    created_at              DATETIME2(0)    NOT NULL,
    order_item_id           INT             NOT NULL,
    order_id                INT             NOT NULL,
    refund_amount_usd       DECIMAL(10,2)   NOT NULL
);


-- ============================================
-- INDEXES FOR QUERY PERFORMANCE
-- ============================================

-- Sessions: frequently filtered/joined on date and source
CREATE INDEX idx_sessions_created_at ON website_sessions(created_at);
CREATE INDEX idx_sessions_utm_source ON website_sessions(utm_source);

-- Pageviews: frequently joined on session_id, filtered by url
CREATE INDEX idx_pageviews_session_id ON website_pageviews(website_session_id);
CREATE INDEX idx_pageviews_url ON website_pageviews(pageview_url);
CREATE INDEX idx_pageviews_created_at ON website_pageviews(created_at);

-- Orders: frequently joined on session_id
CREATE INDEX idx_orders_session_id ON orders(website_session_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Order items: frequently joined on order_id and product_id
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_order_items_created_at ON order_items(created_at);

-- Refunds: frequently joined on order_item_id
CREATE INDEX idx_refunds_order_item_id ON order_item_refunds(order_item_id);
CREATE INDEX idx_refunds_order_id ON order_item_refunds(order_id);