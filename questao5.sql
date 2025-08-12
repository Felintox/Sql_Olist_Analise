WITH CancelamentoPorVendedor AS (
    SELECT
        oi.seller_id,
        COUNT(*) AS total_produtos,
        COUNT(CASE WHEN o.order_status = 'canceled' THEN 1 END) AS total_cancelados
    FROM
        olist_order_items AS oi
    INNER JOIN
        olist_orders AS o ON oi.order_id = o.order_id
    GROUP BY
        oi.seller_id
)
SELECT
    seller_id,
    total_produtos,
    total_cancelados,
    ROUND((total_cancelados * 100.0 / total_produtos), 2) AS pct_cancelados
FROM
    CancelamentoPorVendedor
WHERE
    total_produtos > 10
ORDER BY
    pct_cancelados DESC;
