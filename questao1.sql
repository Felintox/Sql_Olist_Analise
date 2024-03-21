SELECT product_category_name,count(product_category_name) as qnt_vendas
FROM olist_order_items  ol_item
INNER JOIN olist_products ol_prod ON
ol_item.product_id=ol_prod.product_id
GROUP BY product_category_name
ORDER BY qnt_vendas DESC
LIMIT 10;

