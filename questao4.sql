SELECT 
    oi.product_id, 
    p.product_category_name, 
    ROUND(AVG(orv.review_score), 2) AS media_avaliacao, 
    COUNT(orv.review_score) AS qnt_avaliacoes
FROM 
    olist_order_reviews AS orv
JOIN 
    olist_order_items AS oi ON orv.order_id = oi.order_id
JOIN 
    olist_products AS p ON oi.product_id = p.product_id
GROUP BY 
    oi.product_id, 
    p.product_category_name
HAVING 
    COUNT(orv.review_score) >= 20 -- garante relevância
ORDER BY 
    media_avaliacao DESC, 
    qnt_avaliacoes DESC;

