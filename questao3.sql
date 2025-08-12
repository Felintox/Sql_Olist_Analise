SELECT
	status_entrega,
    COUNT(status_entrega) AS qnt_entrega,
    (COUNT(status_entrega)/(SELECT COUNT(*) FROM olist_orders WHERE order_status = 'delivered'))* 100 AS porcentagem
FROM (
	SELECT
		CASE
			WHEN TIMESTAMPDIFF(DAY,order_delivered_customer_date, order_estimated_delivery_date)>=0
            THEN 'No tempo'
            ELSE 'Atrasado'
		END AS status_entrega
	FROM olist_orders
    where order_status='delivered'
    ) AS subconsulta
GROUP BY status_entrega;


WITH EntregasStatusPorEstado AS (
    SELECT
        c.customer_state,
        CASE
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'No Prazo'
            ELSE 'Atrasado'
        END AS status_entrega
    FROM
        olist_orders AS o
    INNER JOIN
        olist_customers AS c ON o.customer_id = c.customer_id
    WHERE
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    customer_state AS Estado,
    COUNT(CASE WHEN status_entrega = 'No Prazo' THEN 1 END) AS Entregas_No_Prazo,
    COUNT(CASE WHEN status_entrega = 'Atrasado' THEN 1 END) AS Entregas_Atrasadas,
    COUNT(*) AS Total_Entregas,
    ROUND((COUNT(CASE WHEN status_entrega = 'No Prazo' THEN 1 END) * 100.0 / COUNT(*)), 2) AS Pct_No_Prazo,
    ROUND((COUNT(CASE WHEN status_entrega = 'Atrasado' THEN 1 END) * 100.0 / COUNT(*)), 2) AS Pct_Atrasadas
FROM
    EntregasStatusPorEstado
GROUP BY
    customer_state
ORDER BY
    ROUND((COUNT(CASE WHEN status_entrega = 'Atrasado' THEN 1 END) * 100.0 / COUNT(*)), 2) DESC ;
