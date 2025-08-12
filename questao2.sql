SELECT
    t1.seller_id,
    t3.seller_state AS estado_vendedor,
    SUM(t1.price) AS faturamento_total,
    COUNT(DISTINCT t1.order_id) AS qnt_pedidos,
    COUNT(t1.product_id) AS qnt_produtos_vendidos,
    SUM(t1.price) / COUNT(DISTINCT t1.order_id) AS ticket_medio
FROM
    olist_order_items AS t1
LEFT JOIN
    olist_orders AS t2 ON t1.order_id = t2.order_id
LEFT JOIN
    olist_sellers AS t3 ON t1.seller_id = t3.seller_id
WHERE
    YEAR(t2.order_purchase_timestamp) = 2017
GROUP BY
    t1.seller_id,
    t3.seller_state
ORDER BY
    faturamento_total DESC
LIMIT 20;
