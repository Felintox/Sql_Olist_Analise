-- Baseado na quantidade de produtos vendidos
SELECT product_category_name as Categoria,count(product_category_name) as qtd_pedidos
FROM olist_order_items  ol_item
LEFT JOIN olist_products ol_prod ON
ol_item.product_id=ol_prod.product_id
GROUP BY product_category_name
ORDER BY qtd_pedidos DESC
LIMIT 10;

-- Baseado no Ticket Médio de cada Categoria
SELECT product_category_name as Categoria,SUM(ol_item.price) as preco_pedidos
FROM olist_order_items  ol_item
LEFT JOIN olist_products ol_prod ON
ol_item.product_id=ol_prod.product_id
WHERE
  ol_prod.product_category_name IS NOT NULL AND ol_prod.product_category_name <> ''
GROUP BY product_category_name
ORDER BY preco_pedidos DESC
LIMIT 10;


