CREATE SCHEMA `olist_`;
USE olist_;

-- 1. Clientes
CREATE TABLE olist_customers (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(5), 
    customer_city VARCHAR(100),
    customer_state VARCHAR(2),
    PRIMARY KEY (customer_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE olist_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- 2. Geolocalização
CREATE TABLE olist_geolocalizacao(
    geolocation_zip_code_prefix VARCHAR(5),
    geolocation_lat DECIMAL(30, 20), 
    geolocation_lng DECIMAL(30, 20), 
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocalizacao
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- 3. Produtos 
CREATE TABLE olist_products (
    product_id VARCHAR(255),
    product_category_name VARCHAR(255),
    product_name_length INT NULL,
    product_description_length INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,
    product_length_cm INT NULL,
    product_height_cm INT NULL,
    product_width_cm INT NULL,
    PRIMARY KEY (product_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, product_category_name,
 @product_name_length, @product_description_length, @product_photos_qty,
 @product_weight_g, @product_length_cm, @product_height_cm, @product_width_cm)
SET
    product_name_length = NULLIF(TRIM(@product_name_length), ''),
    product_description_length = NULLIF(TRIM(@product_description_length), ''),
    product_photos_qty = NULLIF(TRIM(@product_photos_qty), ''),
    product_weight_g = NULLIF(TRIM(@product_weight_g), ''),
    product_length_cm = NULLIF(TRIM(@product_length_cm), ''),
    product_height_cm = NULLIF(TRIM(@product_height_cm), ''),
    product_width_cm = NULLIF(TRIM(@product_width_cm), '');

-- 4. Vendedores
CREATE TABLE olist_sellers(
    seller_id VARCHAR(255),
    seller_zip_code_prefix VARCHAR(5), 
    seller_city VARCHAR(255),
    seller_state VARCHAR(255),
    PRIMARY KEY (seller_id) 
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE olist_sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- 5. Pedidos (Sem alterações necessárias na estrutura)
CREATE TABLE olist_orders (
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp datetime,
    order_approved_at datetime NULL,
    order_delivered_carrier_date datetime NULL,
    order_delivered_customer_date datetime NULL,
    order_estimated_delivery_date datetime NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES olist_customers(customer_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE olist_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, customer_id, order_status, order_purchase_timestamp, @order_approved_at, 
 @order_delivered_carrier_date, @order_delivered_customer_date, @order_estimated_delivery_date)
SET order_delivered_carrier_date = NULLIF(TRIM(@order_delivered_carrier_date), ''),
    order_delivered_customer_date = NULLIF(TRIM(@order_delivered_customer_date), ''),
    order_estimated_delivery_date = NULLIF(TRIM(@order_estimated_delivery_date), ''),
    order_approved_at = NULLIF(TRIM(@order_approved_at),'');

-- 6. Pagamentos
CREATE TABLE olist_order_payments (
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(255),
    payment_installments INT,
    payment_value DECIMAL(10, 2), 
    FOREIGN KEY (order_id) REFERENCES olist_orders(order_id) 
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- 7. Avaliações
CREATE TABLE olist_order_reviews (
    review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title VARCHAR(255) NULL,
    review_comment_message TEXT NULL,
    review_creation_date datetime,
    review_answer_timestamp datetime,
    FOREIGN KEY (order_id) REFERENCES olist_orders(order_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(review_id, order_id, review_score, @review_comment_title, @review_comment_message, review_creation_date, review_answer_timestamp)
SET
    review_comment_title = NULLIF(@review_comment_title, ''),
    -- Removida a função LEFT() para importar a mensagem completa, aproveitando o tipo TEXT
    review_comment_message = NULLIF(@review_comment_message, '');

-- 8. Itens de pedido
CREATE TABLE olist_order_items (
    order_id VARCHAR(255),
    order_item_id VARCHAR(255),
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date datetime,
    price DECIMAL(10, 2), 
    freight_value DECIMAL(10, 2), 
    FOREIGN KEY (order_id) REFERENCES olist_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products(product_id),
    FOREIGN KEY (seller_id) REFERENCES olist_sellers(seller_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE olist_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
