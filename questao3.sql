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