SELECT product_category_name, count(product_category_name) as pedido_cancelados
FROM olist_orders oo
JOIN 
	olist_order_items oi on oo.order_id = oi.order_id
JOIN 
	olist_products p on oi.product_id = p.product_id
where order_status='canceled'
group by product_category_name
order by pedido_cancelados DESC