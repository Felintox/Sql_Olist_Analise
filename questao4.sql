-- Maior Avaliação
SELECT 
    oi.product_id, 
    p.product_category_name, 
    AVG(orv.review_score) AS media_avaliacao, 
    COUNT(orv.review_score) AS qnt_avaliacoes
FROM 
    olist_order_reviews orv
JOIN 
    olist_order_items oi ON orv.order_id = oi.order_id
JOIN 
    olist_products p ON oi.product_id = p.product_id
GROUP BY 
    oi.product_id, 
    p.product_category_name
ORDER BY 
    qnt_avaliacoes DESC, 
    media_avaliacao DESC;

